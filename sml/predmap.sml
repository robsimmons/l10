structure PredMap :> sig

   type 'a map
   type entry = Symbol.symbol * Term.term list
   val empty: 'a map
   val insert: 'a map * entry * 'a -> 'a map
   val find: 'a map * entry -> 'a option
   val list: 'a map -> entry list

end = 
struct

type 'a map = (Term.term list * 'a) list MapX.map
type entry = Symbol.symbol * Term.term list
val empty: 'a map = MapX.empty

fun lookup (map, w) = 
   case MapX.find (map, w) of NONE => [] | SOME xs => xs

fun insert' (terms, x, []) = [ (terms, x) ]
  | insert' (terms, x, (terms', y) :: termss) = 
    if ListPair.all Term.eq (terms, terms') 
    then (terms, x) :: termss
    else (terms', y) :: insert' (terms, x, termss)

fun insert (map, (w, terms), x) =
   MapX.insert (map, w, insert' (terms, x, lookup (map, w)))

fun find' (terms, []) = NONE
  | find' (terms, (terms', x) :: termss) = 
    if ListPair.all Term.eq (terms, terms') 
    then SOME x 
    else find' (terms, termss)

fun find (map, (w, terms)) = find' (terms, lookup (map, w)) 

fun list map = 
   List.concat 
      (List.map 
         (fn (w, termss) => List.map (fn (terms, _) => (w, terms)) termss)
         (MapX.listItemsi map))

end
