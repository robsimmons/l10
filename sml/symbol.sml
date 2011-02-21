structure Symbol :> sig
 
   eqtype symbol

   (* Generates a symbol for a given name *)
   val symbol: string -> symbol
  
   (* Returns the name associated with a symbol *)
   val name: symbol -> string  

   (* Comparison *)
   val compare: symbol * symbol -> order

   structure Set: ORD_SET where type Key.ord_key = symbol
   structure Map: ORD_MAP where type Key.ord_key = symbol

   (* Returns a symbol that is unique from a set of symbols *)
   val unique: Set.set -> string -> symbol

end = struct

type symbol = int
  
exception Symbol

val ht: (string, int) HashTable.hash_table = 
   HashTable.mkTable (HashString.hashString, (op =)) (128, Symbol)
val nxt: int ref = ref 0
val max: int ref = ref 1

(* XXX GEN this should be a growarray for simplicity *)
val arr: string array ref = ref (Array.array (128, "##invalid##"))

fun upd s = 
   if !nxt < !max
   then !nxt before (Array.update (!arr, !nxt, s); nxt := !nxt + 1) 
   else 
   let 
      val oldMax = !max
      val newMax = oldMax * 2  (* XXX OVERFLOW *)
      val oldNxt = !nxt
      val newNxt = oldNxt + 1
      fun tab x = 
         if x < oldMax then Array.sub (!arr, x) else "##invalid##"
   in
      arr := Array.tabulate (newMax, tab)
      ; Array.update (!arr, oldNxt, s)
      ; max := newMax
      ; nxt := newNxt
      ; oldNxt  
   end

fun symbol s = 
   case HashTable.find ht s of
      NONE => upd s
    | SOME x => x

fun name x = 
   Array.sub (!arr, x)

val compare = Int.compare

structure Set = 
RedBlackSetFn(struct type ord_key = symbol val compare = Int.compare end)

structure Map = 
RedBlackMapFn(struct type ord_key = symbol val compare = Int.compare end)

fun unique set s = 
   let 
      fun loop n = 
         let val x = symbol (s ^ Int.toString n) in
            if Set.member (set, x) then loop (n+1) else x
         end
   in loop 1 end

end

structure SetX = Symbol.Set

structure MapX = Symbol.Map
