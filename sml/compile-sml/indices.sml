
structure Indices:> 
sig
   type tables 

   (*[ val caonicalize: Atom.moded_t list -> tables ]*)
   val canonicalize: Atom.t list -> tables

   val get_fold: tables -> Atom.t -> {label: int,
                                      inputs: (Path.t * Type.t) list, 
                                      outputs: (Path.t * Type.t) list}
(* 
   (*[ val lookup: Atom.prop_t ->  ]*)
   val lookup: tables -> Atom.moded_t ->  
                  -> {prop: Atom.t, input: SetX.set, output: SetX.set}
                  -> {id: int,
                      inputs: Symbol.symbol list,
                      outputs: Symbol.symbol option list}
*)
 
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

fun emit_folder (i, world) = 
let
   val (ins, outs) = query_paths world
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
 ( emit ["fun fold_"^s^" folder (db as {"^s^"=ref dict, ...}: tables) " 
         ^Strings.tuple (map (Path.toVar o #1) ins)^" ="]
 ; incr ()
 ; if null ins
   then (emit ["List.foldr folder db dict"])
   else (emit ["fold folder db"]; incr (); lookups "" "" (rev ins); decr ())
 ; decr ()
 ; emit [""])
end

fun emit_dbtype numbered_indices = 
let 
   fun tabletyp (i, world) = 
   let 
      val (ins, outs) = query_paths world
      val outs = 
         case Path.Dict.toList outs of 
            [] => "unit list"
          | [ (path, t) ] => Strings.typ t ^ " list"
          | outs => 
            "("^String.concatWith " * " (map (Strings.typ o #2) outs)^") list"
      val ins = 
         rev (map (fn (_, x) => Strings.dict x^".dict ") (Path.Dict.toList ins))
   in emit [Int.toString i^": "^outs^" "^String.concat ins^"ref,"] end
in
 ( emit ["type tables = {"]
 ; incr ()
 ; app tabletyp numbered_indices
 ; emit ["worlds: unit World.Dict.dict ref,","flag: bool ref}"]
 ; decr ()
 ; emit [""])
end

fun emit_assert numbered_indices (a, (i, ts)) = 
let 
   val args = 
      Strings.tuple (mapi (fn (i, _) => "x_"^Int.toString i) ts)
   val splits = 
      List.foldl 
         (fn ((i, (a', terms)), splits) => 
             if Symbol.eq (a, a') 
             then (Splitting.insertList splits terms)
             else (splits))
         (Splitting.unsplit (Tab.lookup Tab.rels a))
         numbered_indices
in
 ( emit ["fun insert_"^Symbol.toValue a^" "^args^" ((), db: tables) ="]
 ; emit ["let val () = (#flag db) := true","in"]
 ; CaseAnalysis.emit "" 
      (fn (postfix, shapes) => emit ["db"^postfix])
      (CaseAnalysis.cases splits)
 ; emit ["end"]
 ; emit ["fun assert_"^Symbol.toValue a^" "^args^" db ="]
 ; emit ["   fold_"^Int.toString i
         ^" (insert_"^Symbol.toValue a^" "^args^") db "^args]
 ; emit [""])
end

fun emit' (numbered_indices, lookups) =
let in
 ( emit ["", "", "(* L10 databases with required indexing (indices.sml) *)"]
 ; List.app
      (fn (n, index) =>
          emit ["(* "^Int.toString n^ " - "
                ^Atom.toString index^" *)"])
      numbered_indices
 ; emit ["","structure L10_Tables =","struct"]
 ; incr ()
 ; emit_dbtype numbered_indices
 ; emit ["fun fold folder seed NONE = seed"]
 ; emit ["  | fold folder seed (SOME x) = List.foldr folder seed x",""]
 ; emit ["fun mapPartial lookup x NONE = NONE"]
 ; emit ["  | mapPartial lookup x (SOME dict) = lookup dict x",""]
 ; app emit_folder numbered_indices
 ; DictX.app (emit_assert numbered_indices) lookups
 ; decr ()
 ; emit ["end"])
end

val emit = emit'

end

