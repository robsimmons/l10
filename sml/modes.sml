(* Mode checking *)
(* Robert J. Simmons *)

structure Modes:> 
sig
   exception ModeError of Pos.t * string

   (* Checks that a dependency is well-moded. Returns the set of variables
    * bound by the head world of the dependency. *)
   (*[ val checkDepend: 
          (Pos.t * Atom.world_t) * (Pos.t * Prem.wprem_t) list -> SetX.set ]*)
   val checkDepend: (Pos.t * Atom.t) * (Pos.t * Prem.t) list -> SetX.set

   (* Checks that a rule is well-moded given variables known to be ground.
    * While it's at it, swaps the order of equality judgments so that the first
    * one is always ground. This is the only change it makes to the premeses *)
   (*[ val checkRule: Rule.rule_t -> SetX.set -> Rule.rule_t ]*)
   val checkRule: Rule.t -> SetX.set -> Rule.t
end = 
struct

exception Invariant
exception ModeError of Pos.t * string

(*[ val checkDepend: 
       (Pos.t * Atom.world_t) * (Pos.t * Prem.wprem_t) list -> SetX.set ]*)
fun checkDepend ((pos, world), worlds) = 
let
   val headFV = Atom.fv world

   (*[ val hasUscore: Prem.wprem_t -> bool ]*)
   fun hasUscore (Prem.Normal (Pat.Atom atom)) = Atom.hasUscore atom
     | hasUscore (Prem.Negated (Pat.Atom atom)) = Atom.hasUscore atom

   (*[ val checkprem: Pos.t * Prem.wprem_t -> unit ]*)
   fun checkprem (pos, prem) =
      case SetX.toList (SetX.difference (Prem.fv prem) headFV) of
         [] => 
            if not (hasUscore prem) then ()
            else raise ModeError (pos, ( "Underscore present where argument\
                                       \ is needed to determine world"))
       | (x :: _) => 
            raise ModeError (pos, ( "Variable `" ^ Symbol.toValue x 
                                  ^ "`, which determines world, not bound in\
                                  \ in the conclusion's world"))
   in
    ( app checkprem worlds
    ; headFV)
   end

(*[ val checkRule: Rule.rule_t -> SetX.set -> Rule.rule_t ]*)
fun checkRule (prems, concs) groundedByWorld = 
let
   (*[ val checkNormal: Pos.t -> Pat.pat_t -> SetX.set -> SetX.set ]*)
   fun checkNormal pos pat ground = 
      case pat of 
         Pat.Atom atom => SetX.union ground (Atom.fv atom)
       | Pat.Exists (x, SOME t, pat) => 
         let 
            val pre_ground = SetX.remove ground x
            val post_ground = checkNormal pos pat pre_ground
         in
          ( if SetX.member post_ground x then ()
            else (* Probably dead code due to typechecking - rjs Oct 26 2011 *) 
                 raise ModeError (pos, ( "Existential variable `" 
                                       ^ Symbol.toValue x ^ "` not used"))
          ; if SetX.member ground x 
            then post_ground (* if x was already there, leave it *)
            else SetX.remove post_ground x )
         end

   (*[ val checkNegated: 
          Pos.t -> Pat.pat_t -> SetX.set -> unit ]*)
   fun checkNegated pos pat ground =
      case pat of
         Pat.Atom atom => 
         let 
            val fvs = Atom.fv atom
         in case SetX.toList (SetX.difference fvs ground) of
               [] => ()
             | x :: _ => raise ModeError (pos, ( "Variable `" 
                                               ^ Symbol.toValue x
                                               ^ "` in negated premise not\
                                               \ ground"))
         end
       | Pat.Exists (x, SOME t, pat) => 
            checkNegated pos pat (SetX.insert ground x)

   (*[ val checkPrem: 
          (Pos.t * Prem.prem_t) 
          -> SetX.set
          -> (Pos.t * Prem.prem_t) * SetX.set ]*)
   fun checkPrem (pos, prem) ground = 
      case prem of 
         Prem.Normal pat => 
            ((pos, prem), checkNormal pos pat ground)
       | Prem.Negated pat =>
          ( checkNegated pos pat ground 
          ; ((pos, prem), ground))
       | Prem.Binrel (Binrel.Eq, term1, term2, SOME t) =>
         let val (fv1, fv2) = (Term.fv term1, Term.fv term2) 
         in 
            if SetX.subset (fv1, ground)
            then ((pos, prem), SetX.union ground fv1)
            else if SetX.subset (fv2, ground)
            then ( (pos, Prem.Binrel (Binrel.Eq, term2, term1, SOME t))
                 , SetX.union ground fv2)
            else raise ModeError (pos, ( "Cannot check for equality between\
                                       \ two non-ground-terms"))
         end
       | Prem.Binrel (_, term1, term2, _) =>
         let val fv = SetX.union (Term.fv term1) (Term.fv term2) 
         in case SetX.toList (SetX.difference fv ground) of
               [] => ((pos, prem), ground)
             | x :: _ => raise ModeError (pos, ( "Variable `"
                                               ^ Symbol.toValue x ^ "` in\
                                               \ comparison not ground"))
         end

   (*[ val checkPrems: 
          (Pos.t * Prem.prem_t) list 
          -> SetX.set
          -> ((Pos.t * Prem.prem_t) list * SetX.set) ]*)
   fun checkPrems [] ground = ([], ground) 
     | checkPrems (prem :: prems) ground = 
       let
          val (prem', ground') = checkPrem prem ground 
          val (prems', ground'') = checkPrems prems ground'
       in (prem' :: prems', ground'')
       end

   (*[ val checkConcArgs: 
          Pos.t -> Term.term_t list -> Class.rel_t -> SetX.set -> unit ]*)
   fun checkConcArgs pos terms class ground = 
      case class of 
         Class.Rel _ => ()
       | Class.Arrow (_, class) =>
         (* This index is not grounded by the world, and must be checked. *)
         let val fv = Term.fv (hd terms) 
         in 
          ( case SetX.toList (SetX.difference fv ground) of 
               [] => ()
             | x :: _ => 
                  raise ModeError (pos, ( "Variable `" ^ Symbol.toValue x
                                        ^ "` in conclusion not ground"))
          ; if Term.hasUscore (hd terms)
            then raise ModeError (pos, "Underscore in illegal position\
                                       \ in conclusion")
            else ()
          ; checkConcArgs pos (tl terms) class ground)
         end
       | Class.Pi (_, _, class) =>
         (* This index is grounded by the world, and can be ignored. *)
            checkConcArgs pos (tl terms) class ground

   (*[ val checkConc: SetX.set -> (Pos.t * Atom.prop_t) -> unit ]*)
   fun checkConc ground (pos, (a, terms)) = 
      checkConcArgs pos terms (Tab.lookup Tab.rels a) ground

   val (checked_prems, ground) = checkPrems prems groundedByWorld
in
 ( List.app (checkConc ground) concs   
 ; (checked_prems, concs))
end

end
