
structure Prem = struct
   datatype t = 
      Normal of Pat.t
    | Negated of Pat.t
    | Binrel of Binrel.t * Term.t * Term.t * Type.t option
    | WorldStatic of Atom.t
    | WorldDynamic of Atom.t
(*[ 
   datasort prem = 
      Normal of Pat.pat
    | Negated of Pat.pat
    | Binrel of Binrel.t * Term.term * Term.term * Type.t none

   datasort prem_t = 
      Normal of Pat.pat_t
    | Negated of Pat.pat_t
    | Binrel of Binrel.t * Term.term_t * Term.term_t * Type.t some

   datasort prem_checked = 
      Normal of Pat.pat_t
    | Negated of Pat.pat_t
    | Binrel of Binrel.t * Term.term_t * Term.term_t * Type.t some
    | WorldStatic of Atom.world_t
    | WorldDynamic of Atom.world_t
]*)

   (*[ val fv: prem_t -> SetX.set
             & prem_checked -> SetX.set ]*)
   fun fv prem = 
      case prem of 
         Normal pat => Pat.fv pat
       | Negated pat => Pat.fv pat
       | Binrel (_, term1, term2, _) => 
           SetX.union (Term.fv term1) (Term.fv term2)
       | WorldStatic world => Atom.fv world
       | WorldDynamic world => Atom.fv world

   fun toString prem =  
      case prem of 
         Normal pat => Pat.toString pat
       | Negated pat => "not (" ^ Pat.toString pat ^ ")"
       | Binrel (br, term1, term2, _) => 
          ( Term.toString term1 ^ " "
          ^ Binrel.toString br ^ " "
          ^ Term.toString term2)
       | WorldStatic _ => "<world static>"
       | WorldDynamic _ => "<world dynamic>"
end
