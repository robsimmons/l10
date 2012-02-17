
structure Rule = struct
   type t = (Pos.t * Prem.t) list * (Pos.t * Atom.t) list   
   (*[ sortdef rule = 
          (Pos.t * Prem.prem) list * (Pos.t * Atom.prop) conslist ]*)
   (*[ sortdef rule_t = 
          (Pos.t * Prem.prem_t) list * (Pos.t * Atom.prop_t) conslist ]*)
   (*[ sortdef rule_checked = 
          (Pos.t * Prem.prem_t) list * (Pos.t * Atom.prop_t) conslist ]*)

   (*[ val fv: rule_t -> SetX.set ]*)
   fun fv ((prems, concs): t) =
      SetX.union 
         (List.foldl (fn (x, y) => SetX.union x y)
            SetX.empty (map (Prem.fv o #2) prems))
         (List.foldl (fn (x, y) => SetX.union x y) 
            SetX.empty (map (Atom.fv o #2) concs))   
end
