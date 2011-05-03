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

   val makepath: ModedTerm.term -> pathtree

   val extendpath: ModedTerm.term * pathtree -> pathtree

   val extendpaths: ModedTerm.term list * pathtree list -> pathtree list

end = 
struct

(* We maintain the invariant that these trees are always fully general. 
 * This means that when we split a structured type, we always split 
 * all possible types. Since a full split is impossible for strings, integers,
 * and symbols, these splits are necessarily partial. *)
datatype pathtree = 
   Unsplit of Ast.typ
 | Split of Ast.typ * pathtree list MapX.map
 | StringSplit of SetS.set 
 | NatSplit of SetII.set
 | SymbolSplit of SetX.set

fun isUnsplit (Unsplit _) = true
  | isUnsplit _ = false

(* Given an arbitrary term at a given type, split to the point where 
 * it generalizes the term. *)
fun makepath term: pathtree = 
   let
      fun subpath (f, terms) (constructor, pathtrees) = 
         let 
            val (typs, typ) = valOf (ConTab.lookup constructor)
         in
            if f <> constructor
            then MapX.insert (pathtrees, constructor, map Unsplit typs)
            else MapX.insert (pathtrees, constructor, map makepath terms)
         end
         
      fun splitpath ((f, terms), typ) = 
         List.foldl (subpath (f, terms)) MapX.empty (TypeConTab.lookup typ)
   in 
      case term of 
         ModedTerm.Var (_, typ) => Unsplit typ
       | ModedTerm.Const c => 
         let val typ = #2 (valOf (ConTab.lookup c)) in
            if typ = TypeTab.t
            then SymbolSplit (SetX.singleton c)
            else Split (typ, splitpath ((c, []), typ))
         end
       | ModedTerm.Structured (f, terms) => 
         let val typ = #2 (valOf (ConTab.lookup f)) 
         in Split (typ, splitpath ((f, terms), typ)) end
       | ModedTerm.StrConst s => StringSplit (SetS.singleton s)
       | ModedTerm.NatConst i => NatSplit (SetII.singleton i)
   end

(* Given a term and a path tree at the same type, extend the path tree
 * until it generalizes the term. *)
fun extendpath (term, pathtree) =
   case (term, pathtree) of 
      (ModedTerm.Var _, _) => pathtree
    | (_, Unsplit typ) => makepath term
    | (ModedTerm.StrConst s, StringSplit set) => StringSplit (SetS.add (set, s))
    | (ModedTerm.NatConst i, NatSplit set) => NatSplit (SetII.add (set, i))
    | (ModedTerm.Const _, Split _) => pathtree
    | (ModedTerm.Const c, SymbolSplit set) => SymbolSplit (SetX.add (set, c))
    | (ModedTerm.Structured (f, terms), Split (typ, subtrees)) =>
      let 
         val pathtrees = extendpaths (terms, MapX.lookup (subtrees, f))
      in Split (typ, MapX.insert (subtrees, f, pathtrees)) end
    | _ => raise Fail "Match pathtree: type error?"

and extendpaths (terms, pathtrees) = 
   map extendpath (ListPair.zipEq (terms, pathtrees))

end
