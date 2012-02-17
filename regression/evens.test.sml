structure S = 
struct

open Evens

fun assert b = if b then () else 
   (print "ASSERTION FAILED\n"; OS.Process.exit OS.Process.failure)

fun f db = (Query.justeven db, Query.justodd db, Query.empty db, Query.both db)
val () = assert ((true, false, false, false) = f someevens)
val () = assert ((false, true, false, false) = f someodds)
val () = assert ((false, false, true, false) = f empty)
val () = assert ((false, false, false, true) = f someofboth)
val () = OS.Process.exit OS.Process.success

end
