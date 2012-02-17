(* Worlds and atomic propositions are 'atoms' *)

structure Atom = struct
   type t = Symbol.symbol * Term.t list
   (*[ sortdef world = Symbol.symbol * Term.term list ]*)
   (*[ sortdef world_t = Symbol.symbol * Term.term_t list ]*)
   (*[ sortdef prop = Symbol.symbol * Term.term list ]*) 
   (*[ sortdef prop_t = Symbol.symbol * Term.term_t list ]*) 
   (*[ sortdef ground_world = Symbol.symbol * Term.ground list ]*) 
   (*[ sortdef ground_prop = Symbol.symbol * Term.ground list ]*) 
   (*[ sortdef moded = Symbol.symbol * Term.moded list ]*) 
   (*[ sortdef moded_t = Symbol.symbol * Term.moded_t list ]*) 

   fun fv (_, terms) = Term.fvs terms

   fun fvs atoms = 
      List.foldr (fn (atom, set) => SetX.union (fv atom) set) SetX.empty atoms

   fun hasUscore (_, terms) = List.exists Term.hasUscore terms

   (*[ val eq: (t * t) -> bool ]*)
   fun eq ((a1, terms1), (a2, terms2)) =
     Symbol.eq (a1, a2) andalso List.all Term.eq (ListPair.zip (terms1, terms2))

   (*[ val toString': bool -> t -> string ]*) 
   (*[ val toString: t -> string ]*) 
   fun toString' parens (w, []) = Symbol.toValue w
     | toString' parens (w, terms) =
          ( if parens then "(" else "")
          ^ Symbol.toValue w 
          ^ String.concat (map (fn term => " " ^ Term.toString term) terms)
          ^ (if parens then ")" else "")
   val toString = toString' false

   fun hasUscore (_, term) = List.exists Term.hasUscore term 
end
