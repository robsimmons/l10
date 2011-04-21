structure Mode = 
struct

structure A = Ast
open Symbol
  
(* pullWorld uses RelTab; takes an atomic proposition and gets a world *)
fun pullWorld (a, terms) = 
   case RelTab.lookup a of
      NONE => raise Fail "Invariant"
    | SOME (args, (w, worldterms)) =>
      let 
         fun folder ((arg, _), term, map) =
            case arg of 
               NONE => map
             | SOME x => MapX.insert (map, x, term)
         val map = ListPair.foldl folder MapX.empty (args, terms)
      in
         (w, valOf (A.subTerms (map, worldterms)))
      end

(* pullConcs checks that all conclusions are at the same world
 * and returns that world. *)
fun pullConcs [] = raise Fail "Invariant"
  | pullConcs [ conc ] = pullWorld conc
  | pullConcs (conc :: concs) = 
    let val world = pullConcs concs in
       if A.eqWorld (pullWorld conc, world) then world
       else raise Fail ("Conclusion " ^ A.strAtomic conc ^ " at world " 
                        ^ A.strWorld (pullWorld conc) 
                        ^ ", but earlier conclusions were at world " 
                        ^ A.strWorld world)
    end


(* pullDependency takes a rule and produces a dependency; it only checks
 * that all the conclusions are at the same world. *)
fun pullDependency (prems, concs) = (pullConcs concs, map pullWorld prems) 

(* Checks that a dependency is well-moded *)
(* Returns the free variables grounded by the world *)
(* XXX does this need to check about underscores? - RJS 4/21/11 *)
fun checkDependency (world, worlds) = 
   let
      val headFV = A.fvWorld world
      fun checkprem world =
         case SetX.listItems (SetX.difference (headFV, A.fvWorld world)) of
            [] => ()
          | (x :: _) => 
            raise Fail ("Variable " ^ Symbol.name x 
                        ^ ", which determines world, bound in premise and not "
                        ^ " conclusion.")
   in
      app checkprem worlds;
      headFV
   end

(* Checks that a rule is well-moded given variables known to be ground *)
(* Pulls one trick: swaps the order of equality judgments so that the first
 * one is always ground. This is the only change it makes to the premeses *)
fun checkWorld ((prems, concs), groundedByWorld) =
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
          | A.Binrel (A.Eq, term1, term2) =>
            let val (fv1, fv2) = (A.fvTerm term1, A.fvTerm term2) in
               if SetX.isSubset (fv1, ground) 
               then (prem, SetX.union (ground, fv2)) 
               else if SetX.isSubset (fv2, ground)
               then (A.Binrel (A.Eq, term2, term1), SetX.union (ground, fv1))
               else raise Fail "Equality between two non-ground terms"
            end
          | A.Binrel (_, term1, term2) =>
            if SetX.isSubset (A.fvTerm term1, A.fvTerm term2)
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

(*
(* Input: a set of symbols, a term (which may include Var NONE) *)
(* Output: *)
fun fvTerm (set, term) =
   case term of 
      Var NONE => 
      let val s = unique set "_" 
      in (SetX.insert (set, s), Var (SOME s)) end
    | Var (SOME s) => (SetX.insert (set, s), 
*)

end
