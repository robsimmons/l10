structure Lookups:> sig

   val lookupRules: Term.world -> (int * Subst.subst * Ast.rule) list

end = struct

fun filter world' (n, world, rule) = 
   case Match.matchWorld Subst.empty world world' of
      NONE => NONE
    | SOME subst => SOME (n, subst, rule)

fun lookupRules world = 
   List.mapPartial (filter world) (RuleTab.list ())

end
