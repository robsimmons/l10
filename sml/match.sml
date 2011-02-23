(* Tinybot term matching
 * Robert J. Simmons
 * 
 * Given a ground term t, match t against every premise in the program,
 * giving the substitution σ for which sσ = t.
 * 
 * The McAllester complexity result demands that this take time 
 * proportional to the size of the program. The dumb solution implemented 
 * here - just to try to match against every single premise - actually
 * satisfies this requirement (if equality is a constant time operation).
 *
 * In practice you'd want to do some clever term indexing. *)

signature MATCH = sig


end

structure Match :> sig

   datatype match = M of {rule : int, premise : int, subst : Subst.subst}
   val match : Syntax.prog -> Term.term -> match list

end = 
struct

open Syntax

datatype match = M of {rule : int, premise : int, subst : Subst.subst}
    
fun match (rules : rule list) : Term.term -> match list = 
   let
      (* Matches a list of subgoals against a substitution *)
      fun match_goals (subst, []) = SOME subst
        | match_goals (subst, (Var x,tm2) :: goals) = 
          let in
             case Subst.find subst x of
                NONE => match_goals(Subst.extend subst (x,tm2), goals)
              | SOME tm1 => 
                if Term.eq(tm1, tm2) then match_goals(subst, goals)
                else NONE
          end
        | match_goals (subst, (Atom(x,tm1s),tm2) :: goals) =
          let val Term.Atom(y,tm2s) = Term.prj tm2 in
             if x = y then match_goals(subst, ListPair.zip(tm1s,tm2s) @ goals)
             else NONE
          end

      (* Initial conditions for match_goals *)
      fun match_premise term prem = 
          match_goals (Subst.empty, [(prem, term)])

      (* After match_premise has been mapped across the premise, collect all
       * the successful matching substitutions (SOME s instead of NONE) *)
      fun match_rule (r, p, [], matches) = matches
        | match_rule (r, p, NONE::prems, matches) =
          match_rule (r, p+1, prems, matches)
        | match_rule (r, p, SOME s::prems, matches) = 
          match_rule (r, p+1, prems, M{rule=r, premise=p, subst=s} :: matches)

      (* Collect all matches *)
      fun match_rules (r, [], matches) term = matches
        | match_rules (r, R{prem,...} :: rules, matches) term = 
          let 
             val matched_prems = map (match_premise term) prem
             val matches = match_rule (r, 0, matched_prems, matches)
          in match_rules (r+1, rules, matches) term end
    in
       match_rules(0, rules, [])
    end

end
