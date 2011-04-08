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

structure RelTab = Symtab(type entrytp = A.arg list * A.world)
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
         (* val () = print ("Immediate deps of " ^ strWorld world ^ "\n") *)

         val deps = immediateDependencies world

         (* val () = print ("There are " ^ Int.toString (length deps) ^ "\n") *)

         fun dependencies (world, goalmap) = 
            if isSome (PredMap.find (depmap, world)) 
            then ((*print ("World " ^ strWorld world ^ " already considered\n")
                  ;*) goalmap)
            (* else if isSome (PredMap.find (goalmap, world)) (* XXX cosmetic *)
            then ((*print ("World " ^ strWorld world ^ " already among goals\n")
                  ;*) goalmap) *)
            else ((*print ("World " ^ strWorld world ^ " not yet consdiered\n")
                  ;*) PredMap.insert (goalmap, world, ()))

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
            PredMap.insert (PredMap.empty, goal, 0),
            PredMap.insert (PredMap.empty, goal, ()))

structure Heap = HeapFn(type priority = int val compare = Int.compare)

fun schedule (depmap, refmap) numplaces = 
    let
       val heap = Heap.empty ()
       fun insert (world, refs) = Heap.insert heap refs world
       val handles = PredMap.mapi insert refmap
       val sched = Array.array (numplaces, (0, []))
       val schedmap = ref PredMap.empty
       exception Done

       (* Obtains all the currently-schedulable worlds *)
       fun pull worlds =
          case Heap.min heap of 
             NONE => worlds
           | SOME (0, world, hand) => 
             (Heap.delete heap hand; pull (world :: worlds))
           | SOME (_, world, hand) => worlds

       (* Decrements a world in the priority queue *)
       fun decr world = 
          let 
             val hand = valOf (PredMap.find (handles, world))
             val (priority, _) = Heap.get heap hand
          in
             Heap.adjust heap hand (priority - 1)
          end

       (* Handles the scheduling of worlds to places *)
       fun place n [] = n
         | place n (world :: worlds) = 
           let
              val (seq, placeSched) = Array.sub (sched, n)
              val worldSched = {place = n, seq = seq}
           in
              Array.update (sched, n, (seq+1, world :: placeSched))
              ; schedmap := PredMap.insert (!schedmap, world, worldSched)
              ; List.app decr (valOf (PredMap.find (depmap, world))) 
              ; place ((n + 1) mod numplaces) worlds
           end

       (* Pulls schedulable worlds and the schedules them *)
       fun loop n = 
          case pull [] of
             [] => Global.assert (fn () => not (isSome (Heap.min heap))) 
           | worlds => loop (place 0 worlds)

       val rawSchedule = (loop 0; Array.vector sched)

       fun printRawSchedule (place, (n, worlds: gworld list)) = 
          let
             fun printWorld (world, n) = 
                let 
                   (* val {place, seq} = 
                          valOf (PredMap.find (!schedmap, world)) *)
                in
                   print (Int.toString n ^ ": " ^ strWorld world)
                   (* ; print (" place:" ^ Int.toString place) *)
                   (* ; print (" seq:" ^ Int.toString seq) *)
                   ; print "\n"
                   ; n+1
                end
          in
             print ("Place " ^ Int.toString place ^ ", " ^ Int.toString n
                    ^ " world(s) scheduled\n")
             ; ignore (List.foldr printWorld 0 worlds)
             ; print "\n"
          end

    in
       Vector.appi printRawSchedule rawSchedule
    end
           
(*   let
      val sched = Array.array (numplaces, [])
                   
   (* 
      fun getZeroes () =
         PredMap.fold 
             numplaces
      *)       

      fun decrease_priority  *)
                      

fun check decl = 
   case decl of
      A.DeclConst (s, _, _) => 
      print ("=== Term constant " ^ Symbol.name s ^ " ===\n")
    | A.DeclDatabase (db, _, (w, terms)) => 
      let 
         val world = (w, map (Subst.apply Subst.empty) terms) 
         val () = print ("=== Database: " ^ Symbol.name db ^ "===\n")
         val sched = schedule (search world) 2
      in
         ()
      end
    | A.DeclDepends ((w, pats), worlds) => 
      let in
         print ("=== Dependency for " ^ Symbol.name w ^ " ===\n")
         ; SearchTab.bind (w, (pats, worlds))
         ; print (A.strWorld' false (w, pats))
         ; print " <-" 
         ; print (String.concat
                     (map (fn world => " " ^ A.strWorld' true world) worlds))
      end
    | A.DeclRelation (s, args, world) => 
      let in
         print ("=== Relation " ^ Symbol.name s ^ " ===\n")
         ; RelTab.bind (s, (args, world))
      end
    | A.DeclRule (prems, concs) => 
      let in
         print ("=== Rule ===\n")
      end
    | A.DeclType s => 
      print ("=== Type " ^ Symbol.name s ^ " ===\n")
    | A.DeclWorld (s, _) => 
      print ("=== World " ^ Symbol.name s ^ " ===\n")

end
