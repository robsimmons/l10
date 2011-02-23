structure TermMap :> sig

   type 'a map 
   val empty: 'a map
   val singleton: Term.term * 'a -> 'a map
   val insert: 'a map * Term.term * 'a -> 'a map   
   val find: 'a map * Term.term -> 'a option

end = 
struct

structure Map = 
RedBlackMapFn(struct type ord_key = Term.term val compare = Term.compare end)
open Map

end

