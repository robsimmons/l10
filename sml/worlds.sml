(* Managing the relationship between worlds and relations *)
(* Robert J. Simmons *)

structure Worlds:> sig

   exception WorldError of Pos.t * string

   (*[ val ofProp: Pos.t * Atom.prop_t -> Pos.t * Atom.world_t ]*)
   val ofProp: Pos.t * Atom.t -> Pos.t * Atom.t
  
   (*[ val ofRule: Rule.rule_t -> Decl.depend_t ]*)
   val ofRule: Rule.t -> ((Pos.t * Atom.t) * (Pos.t * Atom.t) list)

end = 
struct

exception Invariant
exception WorldError of Pos.t * string

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
   in
      case apply (Tab.lookup Tab.rels a) DictX.empty terms of
         (_, NONE) => raise Invariant (* Well-typed classifiers are closed *)
       | (w, SOME terms) => (pos, (w, terms))
   end
  
(*[ val ofRule: Rule.rule_t -> Decl.depend_t ]*)
fun ofRule (prems, conc :: concs) =
   let 
      val world = ofProp conc
      (*[ val checkconc: Pos.pos * Atom.prop_t -> unit ]*)
      fun checkconc conc' = 
         let val world' = ofProp conc' in
            if Atom.eq (#2 world, #2 world') then ()
            else raise WorldError (#1 world', "World associated with\
                                              \ conclusion `" 
                                              ^ Atom.toString (#2 conc')
                                              ^ "` is `"
                                              ^ Atom.toString (#2 world')
                                              ^ "`, which differs from earlier\
                                              \ conclusion `"
                                              ^ Atom.toString (#2 conc)
                                              ^ "` with has associated world `"
                                              ^ Atom.toString (#2 world))

      fun ofPat pos pat = 
         case pat of 
            Pat.Atomic prop => (ofProp (pos, prop), Atom.fv (#2 prop))
          | Pat.Exists (x, SOME _, pat) => 
            let val (world, fv) = ofPat pat in
               if not (SetX.member fv x) then (world, fv)
               else raise WorldError (pos, "Local variable `"
                                           ^ Symbol.toValue x "` used in a\
                                           \ world-sensitive position")
            end
      
      fun pullPrem prem = 
         case Prem of 
            Prem.Normal (pos, pat) => SOME (#1 (ofPat pos pat))
          | Prem.Negated (pos, pat) =>
            (* This is one of many cases where *)
            let val world = 
SOME (#1 (ofPat pos pat))
          | Prem.Binrel _ = NONE
   in
      ( app checkconc concs
      ; (world, ))
   end

end
