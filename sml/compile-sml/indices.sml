
structure Indices:> 
sig
   type tables 

   (*[ val caonicalize: Atom.moded_t list -> tables ]*)
   val canonicalize: Atom.t list -> tables

   (* Split a function into inputs and outputs *)
   (*[ val query_paths: Term.moded_t ->
          Type.t Path.Dict.dict * Type.t Path.Dict.dict ]*)
   val query_paths: Atom.t -> Type.t Path.Dict.dict * Type.t Path.Dict.dict

   (* Explains how to actually *call* an index. The index must be one of the
    * ones that was canonicalized. *)
   (*[ val get_fold: tables -> Atom.prop_t -> 
          {label: int, 
           inputs: (Path.t * Type.t) list, 
           outputs: (Path.t * Type.t) list} ]*)
   val get_fold: tables -> Atom.t -> {label: int,
                                      inputs: (Path.t * Type.t) list, 
                                      outputs: (Path.t * Type.t) list}
 
   val emit: tables -> unit
end = 
struct

open Util

type tables = 
   (int * Atom.t) list * (* Tables indicated by a number. *)
   (int * Type.t list) DictX.dict (* The "all-output" table for a type. *)

(* XXX This creates way too many tables - reuse tables! *)
fun canonicalize indices = 
let
   val numbered_indices = mapi (fn (i, x) => (i+1,x)) indices
   fun allInputs [] = SOME []
     | allInputs (Term.Mode (Mode.Input, SOME t) :: terms) = 
         (case allInputs terms of
             NONE => NONE
           | SOME ts => SOME (t :: ts))
     | allInputs _ = NONE
   val dict = 
      List.foldr (fn ((i, (a, terms)), dict) => 
                    (case allInputs terms of
                        NONE => dict
                      | SOME ts => DictX.insert dict a (i, ts)))
         DictX.empty numbered_indices
in
   (numbered_indices, dict)
end


 

(* Given a moded term, get the paths of all the inputs and the paths of all
 * the outputs *)
type ios = Type.t Path.Dict.dict * Type.t Path.Dict.dict
(*[ val query_paths: Term.moded_t -> ios ]*)
fun query_paths (a, terms) = 
let
   exception DisjointPathInvariant
   val empty = (Path.Dict.empty, Path.Dict.empty)
   fun join ((xs,ys),(xs',ys')) = 
      (Path.Dict.union xs xs' (fn _ => raise DisjointPathInvariant), 
       Path.Dict.union ys ys' (fn _ => raise DisjointPathInvariant))

   (*[ val get_term: Path.t -> Term.moded_t -> ios ]*)
   (*[ val get_terms:
          Path.t -> int -> Term.moded_t list -> ios ]*)
   fun get_term path term = 
      case term of
         Term.SymConst _ => empty
       | Term.NatConst _ => empty
       | Term.StrConst _ => empty
       | Term.Mode (Mode.Input, SOME t) => 
            (Path.Dict.singleton path t, Path.Dict.empty)
       | Term.Mode (Mode.Output, SOME t) =>
            (Path.Dict.empty, Path.Dict.singleton path t)
       | Term.Mode (Mode.Ignore, SOME t) => empty
       | Term.Root (a, terms) => get_terms path 0 terms
   and get_terms path n terms =
      case terms of
         [] => empty
       | term :: terms => 
            join (get_term (path @ [ n ]) term, get_terms path (n+1) terms)
in
   get_terms [] 0 terms
end

exception FoldNotFound
fun get_fold' [] index = raise FoldNotFound
  | get_fold' ((i, index') :: numbered_indices) index = 
    let 
       fun return () = 
       let val (ins, outs) = query_paths index
       in {label=i,
           inputs=Path.Dict.toList ins, 
           outputs=Path.Dict.toList outs} end
    in 
       if Atom.eq (index, index') then return () 
       else get_fold' numbered_indices index
    end       
fun get_fold (numbered_indices, _) = get_fold' numbered_indices

(* The main database type is a record, and as such it needs to have a named
 * type so we don't have to deal with unresolved flex record errors. *)
fun emit_dbtype numbered_indices = 
let 
   fun tabletyp (i, atom) = 
   let 
      val () = emit ["(* "^Int.toString i^ ": "^Atom.toString atom^" *)"]
      val (ins, outs) = query_paths atom
      val outs = 
         case Path.Dict.toList outs of 
            [] => "unit list"
          | [ (path, t) ] => Strings.typ t ^ " list"
          | outs => 
            "("^String.concatWith " * " (map (Strings.typ o #2) outs)^") list"
      val ins = 
         rev (map (fn (_, x) => Strings.dict x^".dict") (Path.Dict.toList ins))
   in emit [Int.toString i^": "^outs^" "^String.concatWith " " ins^","] end

   fun tableemp (i, atom) = 
      case Path.Dict.toList (#1 (query_paths atom)) of
         [] => emit [Int.toString i^"=[],"]
       | (_, x) :: _ => emit [Int.toString i^"="^Strings.dict x^".empty,"]

   val tablelabel = 
      map (Int.toString o #1) numbered_indices @ ["worlds", "flag"]

   fun tablederef s = emit ["fun get_"^s^" (db: tables) = #"^s^" db"]
   fun tableupdate s = 
    ( emit ["fun set_"^s^" (db: tables) x = {"]
    ; incr ()
    ; app (fn x => 
             if x = s 
             then emit ["   "^x^" = x"^(if x="flag" then "}" else ",")]
             else emit ["   "^x^" = #"^x^" db"^(if x="flag" then "}" else ",")])
         tablelabel
    ; decr ()
    ; emit [""])
        
in
 ( emit ["type tables = {"]
 ; incr ()
 ; app tabletyp numbered_indices
 ; emit ["worlds: unit World.Dict.dict,","flag: bool}"]
 ; decr ()
 ; emit ["","fun empty (): tables = {"]
 ; incr ()
 ; app tableemp numbered_indices
 ; emit ["worlds=World.Dict.empty,","flag=false}",""]
 ; decr ()
 ; app tablederef tablelabel
 ; emit [""]
 ; app tableupdate tablelabel)
end

(* The folds are semi-public: they're used by the search functionality. 
 * In the future when I have implemented folds over built-in data types,
 * we will still need to emit all the fold_n functions that we do now, but
 * those fold functions may query a number of actual tables that is smaller
 * than n. *)
fun emit_folder (i, atom) = 
let
   val (ins, outs) = query_paths atom
   val ins = Path.Dict.toList ins
   val outs = Path.Dict.toList outs
   val s = Int.toString i
   exception EmitFolderInvariant
   fun lookups pre post ins =
      case ins of 
         [] => raise EmitFolderInvariant
       | [ (path, t) ] =>
            emit [pre^"("^Strings.dict t^".find dict "^Path.toVar path^")"^post]
       | ((path, t) :: ins) =>
          ( emit [pre^"(mapPartial "^Strings.dict t^".find "^Path.toVar path]
          ; lookups (pre^" ") (post^")") ins)
in
 ( emit ["fun fold_"^s^" f x (db as {"^s^"= dict, ...}: tables) " 
         ^Strings.tuple (map (Path.toVar o #1) ins)^" ="]
 ; incr ()
 ; if null ins
   then (emit ["List.foldr f x dict"])
   else ( emit ["fold f x"]
        ; incr ()
        ; lookups "" "" (rev ins)
        ; decr ())
 ; decr ()
 ; emit [""])
end

(* The insertion functions are not public: they directly add things to the 
 * database. Incidentally, this is one of the few places where we admit that
 * we're actually implementing the database imperatively (funcitonal record
 * updates seem expensive), and one of the few things that would need to 
 * change to make dbs actually functional. *)
(* XXX the eager generation of singletons should be replaced *)
fun emit_insert (i, atom) =
let
   val (ins, outs) = query_paths atom
   val ins = Path.Dict.toList ins
   val s = Int.toString i
   fun singletons [] = ()
     | singletons [ (path, _) ] = 
          emit ["val single_"^Path.toString path^" = [data]"]
     | singletons ((path, _) :: (ins as (nextpath, t) :: _)) = 
        ( singletons ins
        ; emit ["val single_"^Path.toString path^" = "
                ^Strings.dict t^".singleton "^Path.toVar nextpath^" "
                ^"single_"^Path.toString nextpath])
   fun insertions prefix postfix [] = emit [prefix^"(data :: this)"^postfix]
     | insertions prefix postfix ((path, t) :: ins) =
        ( emit [prefix^"("^Strings.dict t^".insertMerge this "
                ^Path.toVar path^" single_"^Path.toString path]
        ; emit [prefix^" (fn this =>"]
        ; insertions (prefix^"  ") (postfix^"))") ins)
in
 ( emit ["fun ins_"^s^Strings.optTuple (map (Path.toVar o #1) ins)
         ^" data (db: tables) ="]
 ; emit ["let"]
 ; incr ()
 ; emit ["val this =get_"^s^" db"]
 ; singletons ins
 ; decr ()
 ; emit ["in","   set_"^s^" db"]
 ; incr (); incr ()
 ; insertions "" "" ins
 ; decr (); decr ()
 ; emit ["end",""])
end

(* Outputs the insert_rel function and assert_rel function for one relation *)
(* "a" is the name of the relation, 
 * "i" is the index of the "all-lookups" fold for the relation "a" (the
 *    fold associated with the query "a + ... +", in other words)
 * "ts" is the actual indices and types [ (0, t_0), ..., (n-1,t_n-1) ] 
 *    corresponding to the n arguments of relation "a".
 *
 * Asserts are semi-public, but the inserts are internal, because they 
 * actually do definitely-the-work of inserting things into the appropriate
 * data structures. *)
fun emit_assert numbered_indices (a, (i, ts)) = 
let 
   val args = 
      Strings.tuple (mapi (fn (i, _) => "x_"^Int.toString i) ts)
   val a_indices =
      List.filter (fn (_, (a', _)) => Symbol.eq (a, a')) numbered_indices
   val splits = 
      List.foldl 
         (fn ((i, (a', terms)), splits) => Splitting.insertList splits terms)
         (Splitting.unsplit (Tab.lookup Tab.rels a))
         a_indices
in
 (* insert_rel *)
 ( emit ["fun insert_"^Symbol.toValue a^" "^args^" (db: tables) ="]
 ; CaseAnalysis.emit "" 
      (fn (postfix, shapes) => 
       let 
          fun get_insert (i, index, eqsubst) =
          let 
             val (ins, outs) = query_paths index
             val (ins, outs) = (Path.Dict.domain ins, Path.Dict.domain outs)
             (* One resolution of the ugly term.sml hack. This is almost 
              * certainly general enough. 
             val de_hack path = 
                Strings.build
                   (#2 (hd (#2 (DictX.lookup eqsubst 
                                   (Symbol.fromValue (Path.toVar path))))))
             val ins = Strings.optTuple (map de_hack ins)
             val outs = Strings.tuple (map de_hack outs)
             *)
             (* Another resolution of the ugly term.sml hack. I think this
              * is fully general? *)
             val ins = Strings.optTuple (map Path.toVar ins)
             val outs = Strings.tuple (map Path.toVar outs)
          in
             "ins_"^Int.toString i^ins^" "^outs
          end

          fun insert prefix postfix' [] = (* Impossible? *)
                 emit [prefix^"set_flag db true"^postfix'^postfix] 
            | insert prefix postfix' [ match ] = 
               ( emit [prefix^"("^get_insert match]
               ; emit [prefix^" (set_flag db true))"^postfix'^postfix])
            | insert prefix postfix' (match :: matches) =
               ( emit [prefix^"("^get_insert match]
               ; insert (prefix^" ") (postfix'^")") matches)
       in
        ( emit ["(* "^Atom.toString (a, shapes)^" *)"]
        ; insert "" "" 
             (List.mapPartial 
                 (fn (i, (a, terms)) => 
                   ( flush ()
                   ; case Term.gens (shapes, terms) of 
                        NONE => NONE
                      | SOME eqsubst => SOME (i, (a, terms), eqsubst)))
                 a_indices))
       end)
      (CaseAnalysis.cases splits)

 (* assert_rel *)
 ; emit ["fun assert_"^Symbol.toValue a^" "^args^" db ="]
 ; incr ()
 ; emit ["if fold_"^Int.toString i^" (fn _ => true) false db "^args^" then db"]
 ; emit ["else insert_"^Symbol.toValue a^" "^args^" db"]
 ; decr ()
 ; emit [""])
end

fun emit' (numbered_indices, lookups) =
let in
 ( emit ["(* L10 databases with required indexing (indices.sml) *)"]
 ; emit ["","structure L10_Tables =","struct"]
 ; incr ()
 ; emit_dbtype numbered_indices
 ; emit ["fun fold folder seed NONE = seed"]
 ; emit ["  | fold folder seed (SOME x) = List.foldr folder seed x",""]
 ; emit ["fun mapPartial lookup x NONE = NONE"]
 ; emit ["  | mapPartial lookup x (SOME dict) = lookup dict x",""]
 ; app emit_folder numbered_indices
 ; app emit_insert numbered_indices
 ; DictX.app (emit_assert numbered_indices) lookups
 ; decr ()
 ; emit ["end"])
end

val emit = emit'

end

