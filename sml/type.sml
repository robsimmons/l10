(* Base types (just symbols) *)

structure Type = 
struct
   type t = Symbol.symbol

   val nat = Symbol.fromValue "nat"
   val word = Symbol.fromValue "word"
   val string = Symbol.fromValue "string"
   val world = Symbol.fromValue "world" (* Pseudo-type for world names *)
   val rel = Symbol.fromValue "rel" (* Pseudo-type for predicates *)

   type env = t DictX.dict

   datatype representation = Transparent | HashConsed | External | Sealed
   
   fun repToString Transparent = "transparent"
     | repToString HashConsed = "hashconsed"
     | repToString External = "external"
     | repToString Sealed = "sealed"
end
