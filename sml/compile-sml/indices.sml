
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

type tables = (int * Atom.t) list

(* XXX This creates way too many tables - reuse tables! *)
fun canonicalize x = mapi (fn (i, x) => (i+1,x)) x 

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
fun get_fold [] index = raise FoldNotFound
  | get_fold ((i, index') :: table) index = 
    let 
       fun return () = 
       let val (ins, outs) = query_paths index
       in {label=i,
           inputs=Path.Dict.toList ins, 
           outputs=Path.Dict.toList outs} end
    in 
       if Atom.eq (index, index') then return () else get_fold table index
    end       

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
 ( emit ["fun fold_"^s^" folder seed ({"^s^"=ref dict, ...}: tables)" 
         ^Strings.optTuple (map (Path.toVar o #1) ins)^" ="]
 ; incr ()
 ; if null ins
   then (emit ["List.foldr folder seed dict"])
   else (emit ["fold folder seed"]; incr (); lookups "" "" (rev ins); decr ())
 ; decr ()
 ; emit [""])
end

fun emit_dbtype tables = 
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
 ; app tabletyp tables
 ; emit ["worlds: unit World.Dict.dict ref}"]
 ; decr ()
 ; emit [""])
end

fun emit' tables = 
let in
 ( emit ["", "", "(* L10 databases with required indexing (indices.sml) *)"]
 ; List.app
      (fn (n, index) =>
          emit ["(* "^Int.toString n^ " - "
                ^Atom.toString index^" *)"])
   tables
 ; emit ["","structure L10_Tables =","struct"]
 ; incr ()
 ; emit_dbtype tables
 ; emit ["fun fold folder seed NONE = seed"]
 ; emit ["  | fold folder seed (SOME x) = List.foldr folder seed x",""]
 ; emit ["fun mapPartial lookup x NONE = NONE"]
 ; emit ["  | mapPartial lookup x (SOME dict) = lookup dict x",""]
 ; app emit_folder tables
 ; decr ()
 ; emit ["end"])
end

val emit = emit'

end

