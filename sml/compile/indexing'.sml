(* Discovering indexes from patterns *)
(* Robert J. Simmons *)

structure Indexing':> sig

   (* Given free variables and a pattern, determines the mode in which 
    * the relation needs to be queried and the resulting substitution and 
    * constraints. *)
   val indexPat: Ast.typ MapX.map * Ast.pattern
      -> { (* A abstraction of the term as inputs and outputs *)
           index: Symbol.symbol * Ast.modedTerm list, 

           (* Every free variable of the pattern that is not bound by
            * in the incoming type environment will be bound in this map,
            * along with the one-or-more paths that it is equal to.
            * If a variable is bound to more than one path, that represents
            * an equality constraint: an index match will only be valid
            * in the cases where all of the paths bound to the same variable
            * are equal. *)
           outputs: (Ast.typ * Path.path list) MapX.map,

           (* Every path is bound to the variable (or underscore) that was
            * in that position in the input term. *)
           paths: Symbol.symbol option MapP.map }

end = struct

open Ast

fun mapi' n [] = []
  | mapi' n (x :: xs) = (n, x) :: mapi' (n+1) xs

fun mapi xs = mapi' 0 xs

fun fail _ = raise Fail "Invariant"

fun unionP ms = MapP.unionWith fail ms

fun minus ms = MapX.mergeWith (fn (SOME x, NONE) => SOME x | _ => NONE) ms

fun knownIndex (index, []) = false
  | knownIndex (index, (index' :: indexes)) = 
    index = index' orelse knownIndex (index, indexes)

fun modedVars mode path term = 
   case term of    
      Var (mode', typ) => 
      if mode = mode' then MapP.singleton (path, typ) else MapP.empty
    | Structured (f, terms) =>
      List.foldl unionP MapP.empty (map (modedVars' mode path) (mapi terms))
    | _ => MapP.empty 
and modedVars' mode path (i, term) = modedVars mode (path @ [ i ]) term

fun list fv = 
   String.concatWith ", " (map (Symbol.name o #1) (MapX.listItemsi fv))

(* Given a set of known variables, the path to the current term, and an 
 * Ast.term, indexTerm creates a IndexTerm.term, a term mapping from 
 * input Ast variables to paths (which encodes equational constraints), and a
 * mapping back from the output paths back to Ast variables. *)
fun indexTerm (known, path, (typ, term)) = 
   case term of 
      Ast.Var NONE => 
      {term = Var (false, typ), 
       outputs = MapX.empty,
       paths = MapP.singleton (path, NONE)}
    | Ast.Var (SOME x) => 
      (case MapX.find (known, x) of
          NONE => 
          {term = Var (false, typ), 
           outputs = MapX.singleton (x, (typ, [ path ])),
           paths = MapP.singleton (path, NONE)}
        | SOME typ =>
          {term = Var (true, typ),
           outputs = MapX.empty,
           paths = MapP.singleton (path, SOME x)})
    | Ast.Const c => 
      {term = Const c,
       outputs = MapX.empty, 
       paths = MapP.empty}
    | Ast.NatConst i => 
      {term = NatConst i, 
       outputs = MapX.empty,
       paths = MapP.empty}
    | Ast.StrConst s => 
      {term = StrConst s, 
       outputs = MapX.empty,
       paths = MapP.empty}
    | Ast.Structured (f, terms) =>
      let
         val (typs, typ) = ConTab.lookup f
         val typterms = ListPair.zipEq (typs, terms)
         val {terms, outputs, paths} = indexTerms (known, 0, path, typterms) 
      in 
         {term = Structured (f, terms), 
          outputs = outputs, 
          paths = paths} 
      end

and indexTerms (known, n, path, typterms) = 
   case typterms of 
      [] => {terms = [], outputs = MapX.empty, paths = MapP.empty}
    | typterm :: typterms =>
      let 
         val {term, outputs, paths} = indexTerm (known, path @ [ n ], typterm)
         val {terms, outputs = outputs', paths = paths'} = 
             indexTerms (known, n+1, path, typterms)
      in
         {terms = term :: terms,
          outputs = MapX.unionWith (fn ((t1, p1), (t2, p2)) => (t1, p1 @ p2))
                                   (outputs, outputs'),
          paths = MapP.unionWith fail (paths, paths')}
      end

fun indexPat (known, pat) = 
   case pat of 
      Ast.One => raise Fail "Unimplemented"
    | Ast.Atomic (a, terms) =>
      let 
         val typs = map #2 (#1 (RelTab.lookup a)) 
         val {terms, outputs, paths} = 
            indexTerms (known, 0, [], ListPair.zipEq (typs, terms))
      in
         {index = (a, terms), outputs = outputs, paths = paths}
      end
    | Ast.Conj _ => raise Fail "Unimplemented"
    | Ast.Exists (x, pat) =>
      if MapX.inDomain (known, x) 
      then indexPat (#1 (MapX.remove (known, x)), pat)
      else indexPat (known, pat)

end
