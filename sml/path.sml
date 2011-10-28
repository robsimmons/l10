(* A path uniquely identifies a position in a term *)

structure Path =
struct

type t = int list

fun toString path = String.concatWith "_" (map Int.toString path)

fun toVar path = "x_" ^ toString path

structure Set =
   SplaySetFun (structure Elem = ListOrdered (IntOrdered))
structure Dict = 
   SplayDictFun (structure Key = ListOrdered (IntOrdered))

end
