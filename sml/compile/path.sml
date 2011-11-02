(* Paths into terms, coverage, and generalization *)
(* Robert J. Simmons *)

structure Path:> sig

   (* Paths uniquely identify positions in terms *)
   type path = int list 
   val str: int list -> string (* strPath [ 1, 2, 5 ] = 1_2_5 *)
   val var: int list -> string (* varPath [ 1, 2, 5 ] = x_1_2_5 *)

   (* substPath (p, term, term') substitues term' at location p in term *)
   (* substPaths (i::p, terms, term') substitues in the i'th term in terms *)
   (* It is an error if the path doesn't point to an Ast.Var *)
   val subst: path * 'a Ast.term' * 'a Ast.term' -> 'a Ast.term' 
   val substs: path * 'a Ast.term' list * 'a Ast.term' -> 'a Ast.term' list

   (* A pathtree represents a covering set of patterns over a datatype *)
   datatype tree = 
      Unsplit of Ast.typ
    | Split of Ast.typ * tree list MapX.map
    | StringSplit of SetS.set 
    | NatSplit of SetII.set
    | SymbolSplit of SetX.set

   val isUnsplit: tree -> bool

   val makepath: 
      ('a -> Ast.typ) -> 'a Ast.term' -> tree

   val extendpath: 
      ('a -> Ast.typ) -> 'a Ast.term' * tree -> tree

   val extendpaths: 
      ('a -> Ast.typ) -> 'a Ast.term' list * tree list -> tree list

   (* Pathtrees are primarily used to create split-enough terms.
    * Given a shape that is split-enough with respect to the term, genTerm
    * returns true if the term generalizes the shape. genTerm treats both
    * the shape and the term as if all variable occurances were linear.
    *
    * genTerm (s (s _), s N) = true
    * genTerm (s (s _), s z) = false 
    * genTerm (s (s _), s (s (s N)) = FAILS INVARIANT 
    * genTerm (f (_, _), f(X, X)) = true *)
   val genTerm: 'a Ast.term' * 'b Ast.term' -> bool
   val genTerms: 'a Ast.term' list -> 'b Ast.term' list -> bool
end = 
struct

open Ast

type path = int list

fun str path = String.concatWith "_" (map Int.toString path)

fun var path = "x_" ^ str path


(* Substitution *)

fun subst ([], Ast.Var _, term) = term 
  | subst (path, Ast.Structured (f, terms), term) = 
    Ast.Structured (f, substs (path, terms, term))
  | subst _ = raise Fail "substPath invariant"

and substs (i :: path, terms, term) = 
    List.take (terms, i) 
    @ [ subst (path, List.nth (terms, i), term) ]
    @ tl (List.drop (terms, i))
  | substs _ = raise Fail "substPaths invariant"


(* Generalization *)

fun genTerm (shape, term) = 
   case (shape, term) of
      (_, Ast.Var _) => true
    | (Ast.Var _, _) => raise Fail "Shape not sufficiently general"
    | (Ast.Const _, Ast.Structured _) => false
    | (Ast.Structured _, Ast.Const _) => false
    | (Ast.Const c, Ast.Const c') => c = c'
    | (Ast.Structured (f, terms), Ast.Structured (f', terms')) =>
      f = f' andalso genTerms terms terms'
    | (Ast.NatConst i, Ast.NatConst i') => i = i'
    | (Ast.StrConst s, Ast.StrConst s') => s = s'
    | _ => raise Fail "Typing invariant in shape"

and genTerms shapes terms = 
   List.all genTerm (ListPair.zipEq (shapes, terms))


(* We maintain the invariant that these trees are always fully general. 
 * This means that when we split a structured type, we always split 
 * all possible types. Since a full split is impossible for strings, integers,
 * and symbols, these splits are necessarily partial. *)
datatype tree = 
   Unsplit of typ
 | Split of typ * tree list MapX.map
 | StringSplit of SetS.set 
 | NatSplit of SetII.set
 | SymbolSplit of SetX.set

fun isUnsplit (Unsplit _) = true
  | isUnsplit _ = false

(* Given an arbitrary term at a given type, split to the point where 
 * it generalizes the term. *)
fun makepath (typ: 'a -> typ) term = 
   let
      fun subpath (f, terms) (constructor, pathtrees) = 
         let 
            val (typs, _) = ConTab.lookup constructor
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
         let val typ = #2 (ConTab.lookup c) in
            if typ = TypeTab.t
            then SymbolSplit (SetX.singleton c)
            else Split (typ, splitpath ((c, []), typ))
         end
       | Structured (f, terms) => 
         let val typ = #2 (ConTab.lookup f)
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
