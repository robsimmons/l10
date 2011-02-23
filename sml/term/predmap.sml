structure PredMap :> sig

   type 'a map
   type entry = Symbol.symbol * Term.term list

   (* Expected map functions *)
   val empty: 'a map
   val insert: 'a map * entry * 'a -> 'a map
   val find: 'a map * entry -> 'a option
   val mapi: (entry * 'a -> 'b) -> 'a map -> 'b map

   (* Treats map like a worklist; tries to remove first element *)
   val remove: 'a map -> ('a map * entry * 'a) option

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

fun fold f y = 
   MapX.foldli 
      (fn (w, termss, y) => 
          List.foldl (fn ((terms, x), y) => f ((w, terms), x, y)) termss)

(* fun list map = 
   List.concat 
      (List.map 
         (fn (w, termss) => List.map (fn (terms, _) => (w, terms)) termss)
         (MapX.listItemsi map)) *)

exception Invariant
fun remove map = 
   case MapX.firsti map of 
      NONE => NONE
    | SOME (w, _) => SOME
      (case MapX.remove (map, w) of 
          (map, []) => raise Invariant
        | (map, [ (terms, x) ]) => 
          (map, (w, terms), x)
        | (map, (terms, x) :: termss) => 
          (MapX.insert (map, w, termss), (w, terms), x))

fun mapi f = 
   MapX.mapi 
      (fn (w, termss) => 
          List.map (fn (terms, x) => (terms, f ((w, terms), x))) termss)

end
