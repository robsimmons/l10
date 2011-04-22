structure Deduce = 
struct

fun runworld (world, ()) = 
   let
      val rules = RuleTab.lookup world
      val num = length rules
   in
      print ("Running at world " ^ Term.strWorld world)
      ; if num = 1
                     then print (" -- 1 rule applies")
                     else print (" -- " ^ Int.toString num ^ " rules apply")
      ; print "\n"
   end

fun deduce facts world = 
   let
      val () = print "== Begin deduction ==\n"
      val () = print "Scheduling... "
      val sched = Search.schedule (Search.search world) 1
      val (n, newWorldOrder) = Vector.sub (sched, 0)
      val () = print (Int.toString n ^ " stages scheduled.\n")
   in
      List.foldl runworld () newWorldOrder
   end

fun deduceStored name = 
   case DbTab.lookup (Symbol.symbol name) of
      NONE => raise Fail ("No stored database " ^ name)
    | SOME (facts, world) => deduce facts world

end
