structure PredSet :> sig

   type set
   val empty: set
   val add: Term.atomic * set -> set
   val size: set -> int
   val match: set * Subst.subst * Ast.atomic -> Subst.subst list
   val printSet: set -> unit
 
end = 
struct

type set = (int * Term.term list list MapX.map)

val empty = (0, MapX.empty)

fun add ((a, terms) : Term.atomic, (n, set) : set) = 
   case MapX.find (set, a) of
      NONE => (n+1, MapX.insert (set, a, [ terms ]))
    | SOME termss => 
      if List.exists (fn terms' => Term.eqs (terms, terms')) termss 
      then (n, set) else (n+1, MapX.insert (set, a, terms :: termss))

fun size (n, _) = n

fun match ((n, set) : set, subst : Subst.subst, (a, terms) : Ast.atomic) =
   case MapX.find (set, a) of 
      NONE => []
    | SOME termss => List.mapPartial (Match.matchTerms subst terms) termss

fun printSet (_, set) = 
   MapX.appi
      (fn (a, termss) => 
          List.app 
              (fn terms => 
                  (print (Symbol.name a ^ " ")
                   ; print (String.concatWith " " (map Term.strTerm terms))
                   ; print "\n"))
          termss)
      set

end
