(* Coverage tools *)
(* Robert J. Simmons *)

(* Currently, this is only used in the complier; no coverage checking is done *)

structure Coverage:> sig

   (* A pathtree represents a covering set of patterns over a datatype *)
   datatype paths = 
      Unsplit
    | Split of (Ast.typ * paths) list MapX.map
    | StringSplit of SetS.set 
    | IntSplit of SetII.set
    | SymbolSplit of SetX.set
   type pathtree = Ast.typ * paths

   val isUnsplit: paths -> bool

   val makepaths: Ast.term * Ast.typ -> pathtree

   val extendpaths: Ast.term * pathtree -> pathtree

end = 
struct

structure A = Ast

(* We maintain the invariant that these trees are always fully general. 
 * This means that when we split a structured type, we always split 
 * all possible types. Since a full split is impossible for strings, integers,
 * and symbols, these splits are necessarily partial. *)
datatype paths = 
   Unsplit
 | Split of (A.typ * paths) list MapX.map
 | StringSplit of SetS.set 
 | IntSplit of SetII.set
 | SymbolSplit of SetX.set

fun isUnsplit Unsplit = true
  | isUnsplit _ = false

(* It's helpful to tag every point in the tree with its type. *)
type pathtree = A.typ * paths

(* Given an arbitrary term at a given type, split to the point where 
 * it generalizes the term. *)
fun makepaths (term, typ) : pathtree = 
   let
      fun subpath (f, terms) (constructor, pathtrees) = 
         let 
            val types = (#1 (valOf (ConTab.lookup constructor)))
            val termtypes = ListPair.zip (terms, types)
            val function =
               if f <> constructor
               then (fn _ => (typ, Unsplit)) 
               else makepaths
         in
            MapX.insert (pathtrees, constructor, map function termtypes)
         end
         
      fun splitpath ((f, terms), typ) = 
         List.foldl (subpath (f, terms)) MapX.empty (TypeConTab.lookup typ)
   in 
      case term of 
         A.Var x => (typ, Unsplit)
       | A.Const x => 
         if TypeTab.lookup typ = SOME TypeTab.CONSTANTS 
         then (typ, SymbolSplit (SetX.singleton x))
         else (typ, Split (splitpath ((x, []), typ)))
       | A.Structured (f, terms) => (typ, Split (splitpath ((f, terms), typ)))
       | A.StrConst s => (typ, StringSplit (SetS.singleton s))
       | A.NatConst i => (typ, IntSplit (SetII.singleton i))
   end

(* Given a term and a path tree at the same type, extend the path tree
 * until it generalizes the term. *)
fun extendpaths (term, (typ, paths)) : pathtree = 
   case (term, paths) of 
      (A.Var _, Unsplit) => (typ, Unsplit)
    | (_, Unsplit) => makepaths (term, typ)
    | (A.StrConst s, StringSplit set) => 
      (typ, StringSplit (SetS.add (set, s)))
    | (A.NatConst i, IntSplit set) => 
      (typ, IntSplit (SetII.add (set, i)))
    | (A.Const _, Split _) => 
      (typ, paths) (* By invariant, constant is already map *)
    | (A.Structured (f, terms), Split subtrees) =>
      (typ, Split (MapX.insert (subtrees, f,
         map extendpaths (ListPair.zip (terms, MapX.lookup (subtrees, f))))))
    | _ => raise Fail "Match pathtree: type error?"

end
