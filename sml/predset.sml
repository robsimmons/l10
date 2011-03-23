structure PredMap :> sig

   type 'a map
   type entry = Symbol.symbol * Term.term list
   val empty: 'a set
   val insert: 'a set * entry -> 'a set
   val find: 'a set * entry -> 'a option
   val list: 'a set -> entry list

end = 
struct

type 'a set = (Term.term list * 'a) list MapX.set
val empty: 'a set = MapX.empty

fun find (set, w) = 
   case MapX.find (set, w) of NONE => [] | SOME xs => xs

fun insert' (term, x, []) = [ term ]
  | insert' (term, x, (term', y) :: terms) = 
    if Term.eq (term, term') 
    then (term, x) :: terms
    else (term', y) :: insert' (term, x, terms)

fun insert (set, (w, newterms), x) =
   MapX.insert (set, w, insert' (term, x, find (set, w)))

fun member' (term, []) = NONE
  | member' (term, (term', _) :: terms) = 
    Term.eq (term, term') orelse member' (term, terms)

fun member (set, (w, terms)) = 
   alreadythere terms (find (set, w))

end
