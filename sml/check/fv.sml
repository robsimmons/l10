(* Free variables of well typed terms: returns the types of the variables *)
(* Robert J. Simmons *)

structure FV:> sig

   type fv = Ast.typ MapX.map

   val fvTerm: Ast.term * Ast.typ -> fv
   val fvTerms: Ast.term list * Ast.typ list -> fv
   val fvAtomic: Ast.atomic -> fv
   val fvWorld: Ast.world -> fv

end = struct

open Ast

type fv = Ast.typ MapX.map

fun fvTerm (term, typ) = 
   case term of 
      Var (SOME x) => MapX.singleton (x, typ)
    | Structured (f, terms) =>
      fvTerms (terms, #1 (valOf (ConTab.lookup f)))
    | _ => MapX.empty

and fvTerms (terms, typs) = 
   List.foldr fvFolder MapX.empty (ListPair.zipEq (terms, typs))

and fvFolder ((term, typ), map) =
   MapX.unionWith #1 (map, fvTerm (term, typ))

fun fvAtomic (a, terms) = fvTerms (terms, map #2 (#1 (valOf (RelTab.lookup a))))

fun fvWorld (w, terms) = fvTerms (terms, valOf (WorldTab.lookup w))

fun fvPat pat = 
   case pat of 
      Atomic atomic => fvAtomic atomic
    | Exists (x, pat) => 
      let val fv = fvPat pat 
      in if MapX.inDomain (fv, x) then #1 (MapX.remove (fv, x)) else fv end
    | Conj (pat1, pat2) => MapX.unionWith #1 (fvPat pat1, fvPat pat2)
    | One => MapX.empty

end
