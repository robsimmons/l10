structure S = 
struct

open Edgepath

fun assert b = if b then () else 
   (print "ASSERTION FAILED\n"; OS.Process.exit OS.Process.failure)

val () = assert (    (Query.edge example ("a","b")))
val () = assert (    (Query.path example ("a","b")))
val () = assert (not (Query.edge example ("a","c")))
val () = assert (    (Query.path example ("a","c")))
val () = assert (not (Query.edge example ("a","a")))
val () = assert (not (Query.path example ("a","a")))
val () = assert (not (Query.edge example ("a","f")))
val () = assert (    (Query.path example ("a","f")))
val () = assert (    (Query.edge example ("a","e")))
val () = assert (    (Query.path example ("a","e")))
val () = assert (not (Query.edge example ("b","f")))
val () = assert (    (Query.path example ("b","f")))

val () = OS.Process.exit OS.Process.success

end
