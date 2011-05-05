(* Coverage tools *)
(* Robert J. Simmons *)

(* Currently, this is only used in the complier; no coverage checking is done *)

structure Coverage':> sig

   (* A pathtree represents a covering set of patterns over a datatype *)
   datatype pathtree = 
      Unsplit of Ast.typ
    | Split of Ast.typ * pathtree list MapX.map
    | StringSplit of SetS.set 
    | NatSplit of SetII.set
    | SymbolSplit of SetX.set

   val isUnsplit: pathtree -> bool

   val makepath: 
      ('a -> Ast.typ) -> 'a Ast.term' -> pathtree

   val extendpath: 
      ('a -> Ast.typ) -> 'a Ast.term' * pathtree -> pathtree

   val extendpaths: 
      ('a -> Ast.typ) -> 'a Ast.term' list * pathtree list -> pathtree list

end = 
struct

open Ast

(* We maintain the invariant that these trees are always fully general. 
 * This means that when we split a structured type, we always split 
 * all possible types. Since a full split is impossible for strings, integers,
 * and symbols, these splits are necessarily partial. *)
datatype pathtree = 
   Unsplit of typ
 | Split of typ * pathtree list MapX.map
 | StringSplit of SetS.set 
 | NatSplit of SetII.set
 | SymbolSplit of SetX.set

fun isUnsplit (Unsplit _) = true
  | isUnsplit _ = false

(* Given an arbitrary term at a given type, split to the point where 
 * it generalizes the term. *)
fun makepath (typ: 'a -> typ) term: pathtree = 
   let
      fun subpath (f, terms) (constructor, pathtrees) = 
         let 
            val (typs, _) = valOf (ConTab.lookup constructor)
         in
            if f <> constructor
            then MapX.insert (pathtrees, constructor, map Unsplit typs)
            else MapX.insert (pathtrees, constructor, map (makepath typ) terms)
         end
         
      fun splitpath ((f, terms), typ) = 
         List.foldl (subpath (f, terms)) MapX.empty (TypeConTab.lookup typ)
   in 
      case term of 
         Var x => Unsplit (typ x)
       | Const c => 
         let val typ = #2 (valOf (ConTab.lookup c)) in
            if typ = TypeTab.t
            then SymbolSplit (SetX.singleton c)
            else Split (typ, splitpath ((c, []), typ))
         end
       | Structured (f, terms) => 
         let val typ = #2 (valOf (ConTab.lookup f)) 
         in Split (typ, splitpath ((f, terms), typ)) end
       | StrConst s => StringSplit (SetS.singleton s)
       | NatConst i => NatSplit (SetII.singleton i)
   end

(* Given a term and a path tree at the same type, extend the path tree
 * until it generalizes the term. *)
fun extendpath (typ: 'a -> typ) (term, pathtree) =
   case (term, pathtree) of 
      (Var _, _) => pathtree
    | (_, Unsplit _) => makepath typ term
    | (StrConst s, StringSplit set) => StringSplit (SetS.add (set, s))
    | (NatConst i, NatSplit set) => NatSplit (SetII.add (set, i))
    | (Const _, Split _) => pathtree
    | (Const c, SymbolSplit set) => SymbolSplit (SetX.add (set, c))
    | (Structured (f, terms), Split (splittyp, subtrees)) =>
      let 
         val pathtrees = extendpaths typ (terms, MapX.lookup (subtrees, f))
      in Split (splittyp, MapX.insert (subtrees, f, pathtrees)) end
    | _ => raise Fail "Match pathtree: type error?"

and extendpaths (typ: 'a -> typ) (terms, pathtrees) = 
   map (extendpath typ) (ListPair.zipEq (terms, pathtrees))

end
