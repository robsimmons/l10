(* Forward chaining *)
(* Robert J. Simmons *)

(* Database table *)
structure DbTab = Symtab(type entrytp = Term.atomic list * Term.world)


structure Deduce = 
struct

structure A = Ast
structure T = Term

(* XXX really shouldn't be using the list monad, lots of concat - RJS 4/22/11 *)
infix 5 `
fun (f ` x) = map f x

infix 5 >>=
fun (x >>= f) = List.concat (map f x)

(* runrule takes a predicate set an initial state for premises;
 * returns a list of matching substitutions *)
fun runPrems predset (prems: Ast.prem list, subst: Subst.subst) = 
   let
      fun runPat pat subst =
         case pat of 
            A.Atomic atomic => PredSet.match (predset, subst, atomic)
          | A.Exists (x, pat1) => 
            let 
               val pre_subst = Subst.push x subst
            in
               Subst.pop ` (runPat pat1 (Subst.push x subst))
            end
          | A.Conj (pat1, pat2) =>
            runPat pat1 subst >>= runPat pat2
          | A.One => [ subst ]

      fun runPrem prem subst =
         case prem of 
            A.Normal pat => runPat pat subst
          | A.Negated pat =>
            (case runPat pat subst of 
                [] => [ subst ]
              | _ => [])
          | A.Count _ => raise Fail "Count not supported yet"
          | A.Binrel (A.Eq, term1, term2) =>
            (case Match.matchTerm subst term2 (Match.pullTerm subst term1) of
                NONE => []
              | SOME subst => [ subst ])
          | A.Binrel (A.Neq, term1, term2) =>
            if T.eq (Match.pullTerm subst term1, Match.pullTerm subst term2)
            then [] else [ subst ]
          | A.Binrel (A.Gt, term1, term2) =>
            (case (T.prj (Match.pullTerm subst term1),
                   T.prj (Match.pullTerm subst term2)) of
                (T.NatConst i, T.NatConst j) =>
                if i > j then [ subst ] else []
              | _ => raise Fail "Invariant")
          | A.Binrel (A.Geq, term1, term2) =>
            (case (T.prj (Match.pullTerm subst term1),
                   T.prj (Match.pullTerm subst term2)) of
                (T.NatConst i, T.NatConst j) =>
                if i >= j then [ subst ] else []
              | _ => raise Fail "Invariant")   
 
      fun runPrems' [] subst = [ subst ]
        | runPrems' (prem :: prems) subst =
          runPrem prem subst >>= runPrems' prems
          
   in 
      runPrems' prems subst
   end

fun runConcs concs (subst, predset) = 
   List.foldl PredSet.add predset (map (Match.pullAtomic subst) concs)

fun runRule ((_, subst, (prems, concs)), predset) = 
   List.foldl (runConcs concs) predset (runPrems predset (prems, subst))

fun runWorld (world, predset) = 
   let
      val rules = RuleTab.lookup world
      val num = length rules

      fun loop old_predset n = 
         let
            val () = print ("   Iteration " ^ Int.toString n)
            val old_size = PredSet.size old_predset
            val new_predset = List.foldl runRule old_predset rules
            val added = PredSet.size new_predset - old_size
            val () = print (" -- " ^ Int.toString added ^ " new fact(s)\n")
         in
            if added = 0 then new_predset else loop new_predset (n+1)
         end

   in
      print ("Running at world " ^ T.strWorld world)
      ; if num = 1
                     then print (" -- 1 rule applies")
                     else print (" -- " ^ Int.toString num ^ " rules apply")
      ; print "\n"
      ; loop predset 1
   end

fun deduce facts world = 
   let
      val () = print "== Begin deduction ==\n"
      val () = print "Scheduling... "
      val sched = Search.schedule (Search.search world) 1
      val (n, newWorldOrder) = Vector.sub (sched, 0)
      val () = print (Int.toString n ^ " stages scheduled.\n")
      val predset = List.foldl PredSet.add PredSet.empty facts
   in
      List.foldl runWorld predset newWorldOrder
      before print "== End deduction ==\n"
   end

fun deduceStored name = 
   case DbTab.lookup (Symbol.symbol name) of
      NONE => raise Fail ("No stored database " ^ name)
    | SOME (facts, world) => deduce facts world

end
