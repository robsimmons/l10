
structure Pat = struct
   datatype t =
      Atom of Atom.t
    | Exists of Symbol.symbol * Type.t option * t
    | Conj of t * t (* Should be implemented, difficult - rjs Oct 12 2011 *)
    | One (* Could be implemented without much trouble *)
(*[
   datasort pat = 
      Atom of Atom.prop
    | Exists of Symbol.symbol * Type.t none * pat

   datasort pat_t = 
      Atom of Atom.prop_t
    | Exists of Symbol.symbol * Type.t some * pat_t

   datasort wpat = Atom of Atom.world

   datasort wpat_t = Atom of Atom.world_t
]*)

   (*[ val fv: pat_t -> SetX.set ]*)
   fun fv pat = 
      case pat of 
         Atom atomic => Atom.fv atomic
       | Exists (x, _, pat) => 
         let val vars = fv pat 
         in if SetX.member vars x then SetX.remove vars x else vars 
         end

   (*[ val fvs: pat_t list -> SetX.set ]*)
   fun fvs pats = 
      foldl (fn (x, y) => SetX.union x y) SetX.empty (map fv pats)

   fun toString pat = 
      case pat of
         Atom atm => Atom.toString' false atm
       | Exists (x, NONE, pat0) => 
            "(Ex " ^ Symbol.toValue x ^ ". " ^ toString pat0 ^ ")"
       | Exists (x, SOME t, pat0) => 
            if String.isPrefix "USCORE_" (Symbol.toValue x) then toString pat0
            else "(Ex " ^ Symbol.toValue x ^ ":" ^ Symbol.toValue t ^ ". "
                 ^ toString pat0 ^ ")"
       | Conj (pat1, pat2) => toString pat1 ^ ", " ^ toString pat2
       | One => "1"
end
