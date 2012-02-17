(* Managing the relationship between worlds and relations *)

structure Worlds:> 
sig
   exception WorldsError of Pos.t * string

   (*[ val ofProp: Pos.t * Atom.prop_t -> Pos.t * Atom.world_t ]*)
   val ofProp: Pos.t * Atom.t -> Pos.t * Atom.t
   
   (*[ val ofPat: Pos.t -> Pat.pat_t -> Atom.world_t * SetX.set ]*)
   val ofPat: Pos.t -> Pat.t -> Atom.t * SetX.set
end = 
struct

exception Invariant
exception WorldsError of Pos.t * string

(*[ val ofProp: Pos.t * Atom.prop_t -> Pos.t * Atom.world_t ]*)
fun ofProp (pos, (a, terms)) = 
let
   (*[ val apply: Class.rel_t -> Term.term_t DictX.dict -> 
          Term.term_t list -> (Symbol.symbol * Term.term_t list option)  ]*)
   fun apply class subst args = 
      case (class, args) of 
         (Class.Rel (_, (w, terms)), []) =>
            (w, Term.substs (subst, terms))
       | (Class.Arrow (t, class), term :: terms) => 
            apply class subst terms
       | (Class.Pi (x, SOME _, class), term :: terms) => 
            apply class (DictX.insert subst x term) terms
       | (Class.Rel _, _) => raise Invariant
       | (_, []) => raise Invariant
in case apply (Tab.lookup Tab.rels a) DictX.empty terms of
      (_, NONE) => raise Invariant (* Well-typed classifiers are closed *)
    | (w, SOME terms) => (pos, (w, terms))
end
  

(*[ val ofPat: Pos.t -> Pat.pat_t -> Atom.world_t * SetX.set ]*)
fun ofPat pos pat = 
   case pat of 
      Pat.Atom prop => 
      let val (pos, world) = ofProp (pos, prop) 
      in (world, Atom.fv world)
      end
    | Pat.Exists (x, SOME _, pat) => 
      let val (world, fv) = ofPat pos pat 
      in
         if not (SetX.member fv x) then (world, fv)
         else raise WorldsError (pos, ("Locally-quantified variable `"
                                       ^Symbol.toValue x^"` used in a \
                                       \world-sensitive position"))
      end
      
(*[ val ofPrem: Pos.t * Prem.prem_t -> (Pos.t * Prem.wprem_t) option ]*)
fun ofPrem (pos, prem) = 
   case prem of 
      Prem.Normal pat => 
         SOME (pos, Prem.Normal (Pat.Atom (#1 (ofPat pos pat))))
    | Prem.Negated pat => 
         SOME (pos, Prem.Negated (Pat.Atom (#1 (ofPat pos pat))))
    | Prem.Binrel _ => NONE
end
