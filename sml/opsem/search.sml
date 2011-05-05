(* Dependency search and static scheduling *)
(* Robert J. Simmons *)

structure Search :> sig

   type dependencies
   val search:   Term.world -> dependencies
   val schedule: dependencies -> int -> (int * Term.world list) vector

end = struct

exception MatchFail
exception Invariant
structure A = Ast
structure T = Term

type dependencies = Term.world list PredMap.map * int PredMap.map

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
        | SOME t1 => assert (T.eq (t1, term)) subst)
    | _ => raise MatchFail

and matchTerms [] [] subst = subst
  | matchTerms (pat :: pats) (term :: terms) subst =
    matchTerms pats terms (matchTerm pat term subst)
  | matchTerms _ _ _ = (print "matchTerms\n"; raise Invariant)



(* Gets all immediate world dependencies of a world based on SearchTab *)
fun immediateDependencies (world as (w, terms)) = 
   let 
      val filter: T.world list -> T.world list =
         List.filter (fn world' => not (T.eqWorld (world, world')))
      val apply: Subst.subst -> A.world -> T.world =
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

       fun printRawSchedule (place, (n, worlds: T.world list)) = 
          let
             fun printWorld (world, n) = 
                let 
                   val rules = Lookups.lookupRules world
                   val num = length rules
                   (* val {place, seq} = 
                          valOf (PredMap.find (!schedmap, world)) *)
                in
                   print (Int.toString n ^ ": " ^ T.strWorld world)
                   (* ; print (" place:" ^ Int.toString place) *)
                   (* ; print (" seq:" ^ Int.toString seq) *)
                   ; if num = 1
                     then print (" -- 1 rule applies")
                     else print (" -- " ^ Int.toString num ^ " rules apply")
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
       (* Vector.appi printRawSchedule rawSchedule
       ; *) rawSchedule
    end
           
end
