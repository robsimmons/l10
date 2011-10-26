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
   (*[ val checkRule: Rule.rule_t * SetX.set -> Rule.rule_t ]*)
   val checkRule: Rule.t * SetX.set -> Rule.t
end = 
struct

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
            else raise ModeError (pos, ( "Underscore present where argument \
                                       \ is needed to determine world"))
       | (x :: _) => 
            raise ModeError (pos, ( "Variable " ^ Symbol.toValue x 
                                  ^ ", which determines world, bound in\
                                  \ premise and not in conclusion"))
   in
    ( app checkprem worlds
    ; headFV)
   end

(* Checks that a rule is well-moded given variables known to be ground *)
(* Pulls one trick: swaps the order of equality judgments so that the first
 * one is always ground. This is the only change it makes to the premeses *)
fun checkRule ((prems, concs), groundedByWorld) = raise Match
(*
   let
      fun checkNormalPrem (pat, ground) =
         case pat of 
            A.Atomic (a, terms) => SetX.union (ground, A.fvTerms terms)
          | A.Exists (x, pat1) => 
            let 
               val pre_ground = SetX.difference (ground, SetX.singleton x)
               val post_ground = checkNormalPrem (pat1, ground)
            in
               if SetX.member (ground, x)
               then SetX.add (post_ground, x) (* ok if it's already there *)
               else SetX.difference (post_ground, SetX.singleton x)
            end
          | A.Conj (pat1, pat2) =>
            checkNormalPrem (pat2, checkNormalPrem (pat1, ground))
          | A.One => ground

      fun checkNegatedPrem (pat, ground, locals) =
          case pat of
             A.Atomic (a, terms) => 
             if SetX.isSubset (A.fvTerms terms, SetX.union (ground, locals))
             then ()
             else raise Fail "Term in negated premise not ground or local"
           | A.Exists (x, pat1) => 
             checkNegatedPrem (pat1, ground, SetX.add (locals, x))
           | A.Conj (pat1, pat2) => 
             (checkNegatedPrem (pat1, ground, locals)
              ; checkNegatedPrem (pat2, ground, locals))
           | A.One => ()

      fun checkPrem (prem, ground) =
         case prem of 
            A.Normal pat => (prem, checkNormalPrem (pat, ground))
          | A.Negated pat => 
            (checkNegatedPrem (pat, ground, SetX.empty); (prem, ground))
          | A.Count _ => raise Fail "Count not supported yet"
          (* XXX probably need to check for underscores - RJS 4/22/11 *)
          (* Actually not sure about here - RJS 5/5/11 *)
          | A.Binrel (A.Eq, term1, term2) =>
            let val (fv1, fv2) = (A.fvTerm term1, A.fvTerm term2) in
               if SetX.isSubset (fv1, ground) 
               then (prem, SetX.union (ground, fv2)) 
               else if SetX.isSubset (fv2, ground)
               then (A.Binrel (A.Eq, term2, term1), SetX.union (ground, fv1))
               else raise Fail "Equality between two non-ground terms"
            end
          | A.Binrel (_, term1, term2) =>
            if SetX.isSubset 
                   (SetX.union (A.fvTerm term1, A.fvTerm term2), ground)
            then (prem, ground)
            else raise Fail "Terms must be ground before inequality check"

      fun checkPrems ([], checked_prems, ground) = (rev checked_prems, ground)
        | checkPrems (prem :: prems, checked_prems, ground) = 
          let val (checked_prem, ground) = checkPrem (prem, ground) 
          in checkPrems (prems, checked_prem :: checked_prems, ground) end

      fun checkConc ground (a, terms) = 
         if not (SetX.isSubset (A.fvTerms terms, ground))
         then raise Fail "Ungrounded variable in conclusion"
         else if A.uscoresInTerms terms
         then raise Fail "Underscores in a conclusion are not allowed"
         else ()

      val (checked_prems, ground) = checkPrems (prems, [], groundedByWorld)
      val () = List.app (checkConc ground) concs

   in (checked_prems, concs) end
*)

end
