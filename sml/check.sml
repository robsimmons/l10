(* structure DeclTab = 
struct

local 
   exception Decl
   structure Tab = Symtab(type entrytp = A.decl)
in
open Tab
fun declWorld x = 
   case SymTab.find x of 
      SOME (Ast.DeclWorld (_, args)) => args 
    | _ => raise Decl

end
end *)
 

structure Check = struct

structure A = Ast
structure T = Term

type whorn = A.term list * A.world list

structure SearchTab = Multitab(type entrytp = whorn)

exception MatchFail
exception Invariant

fun assert b subst = if b then subst else raise MatchFail

fun matchTerm pat term subst = 
   case (pat, T.prj term) of 
      (A.Const x, T.Structured (y, [])) => assert (x = y) subst
    | (A.Structured (x, pats), T.Structured (y, terms)) =>
      if x <> y then raise MatchFail
      else matchTerms pats terms subst
    | (A.NatConst n1, T.NatConst n2) => assert (n1 = n2) subst
    | (A.StrConst s1, T.StrConst s2) => assert (s1 = s2) subst
    | (A.Var NONE, _) => subst
    | (A.Var (SOME x), _) => 
      (case Subst.find subst x of
          NONE => Subst.extend subst (x, term)
        | SOME t1 => assert (Term.eq (t1, term)) subst)
    | _ => raise MatchFail

and matchTerms [] [] subst = subst
  | matchTerms (pat :: pats) (term :: terms) subst =
    matchTerms pats terms (matchTerm pat term subst)
  | matchTerms _ _ _ = (print "matchTerms\n"; raise Invariant)

type gworld = Symbol.symbol * Term.term list

fun strWorld (w, terms) = 
  case terms of 
     [] => Symbol.name w
   | _ => 
     Symbol.name w
     ^ String.concat (map (fn term => " " ^ Term.strTerm' true term) terms)

fun eqWorld ((w1, terms1): gworld, (w2, terms2)) = 
   w1 = w2 andalso ListPair.all Term.eq (terms1, terms2)

(* Gets all immediate world dependencies of a world based on SearchTab *)
fun immediateDependencies (world as (w, terms)) = 
   let 
      val filter: gworld list -> gworld list =
         List.filter (fn world' => not (eqWorld (world, world')))
      val apply: Subst.subst -> A.world -> gworld =
         fn subst => fn (w, pats) => (w, map (Subst.apply subst) pats)
      fun mapper (pats, prems) = 
         filter (map (apply (matchTerms pats terms Subst.empty)) prems)
         handle MatchFail => []
   in
      List.concat (map mapper (SearchTab.lookup w))
   end

(* Ascertain all dependencies for a given world
  Invariants
  - Keys(refmap) = Keys(depmap) ∪ Keys(goalmap)
  - depmap contains all the immediate dependencies of 
  - refmap(world) = occurances of world in depmap
  - goalmap is the set of all unfilled goals in depmap
*)
fun search' (depmap, refmap, goalmap) = 
   case PredMap.remove goalmap of
      NONE => (depmap, refmap)
    | SOME (goalmap, world, ()) => 
      let
         val () = print ("Immediate dependencies of " ^ strWorld world ^ "\n")

         val deps = immediateDependencies world

         val () = print ("There are " ^ Int.toString (length deps) ^ "\n")

         fun dependencies (world, goalmap) = 
            if isSome (PredMap.find (depmap, world)) 
            then (print ("World " ^ strWorld world ^ " already considered\n")
                  ; goalmap)
            else if isSome (PredMap.find (goalmap, world)) (* XXX cosmetic *)
            then (print ("World " ^ strWorld world ^ " already among goals\n")
                  ; goalmap)
            else (print ("World " ^ strWorld world ^ " not yet consdiered\n")
                  ; PredMap.insert (goalmap, world, ()))

         fun references (world, refmap) = 
            case PredMap.find (refmap, world) of
               NONE => PredMap.insert (refmap, world, 1)
             | SOME n => PredMap.insert (refmap, world, n+1)
      in
         search' (PredMap.insert (depmap, world, deps)
                  , List.foldl references refmap deps
                  , List.foldl dependencies goalmap deps)
      end

fun search goal = 
    search' (PredMap.empty,
             PredMap.empty,
             PredMap.insert (PredMap.empty, goal, ()))

fun check decl = 
   case decl of
      A.DeclConst (s, _, _) => 
      print ("=== Term constant " ^ Symbol.name s ^ " ===\n")
    | Ast.DeclDatabase (db, _, (w, terms)) => 
      let 
         val world = (w, map (Subst.apply Subst.empty) terms) 
      in
         print ("=== Database: " ^ Symbol.name db ^ "===\n")
         ; ignore (search world)
      end
    | Ast.DeclDepends ((w, pats), worlds) => 
      let in
         print ("=== Dependency for " ^ Symbol.name w ^ " ===\n")
         ; SearchTab.bind (w, (pats, worlds))
      end
    | Ast.DeclRelation (s, _, _) => 
      print ("=== Relation " ^ Symbol.name s ^ " ===\n")
    | Ast.DeclRule (ls, s) => 
      print ("=== Rule ===\n")
    | Ast.DeclType s => 
      print ("=== Type " ^ Symbol.name s ^ " ===\n")
    | Ast.DeclWorld (s, _) => 
      print ("=== World " ^ Symbol.name s ^ " ===\n")

end
