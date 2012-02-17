structure S = 
struct

fun assert b = if b then () else 
   (print "ASSERTION FAILED\n"; OS.Process.exit OS.Process.failure)

open Plus

fun toN n = 
   if n < 0 then raise Domain
   else if n = 0 then N.Z' 
   else N.S' (toN (n-1))

fun fromN n = 
   case N.prj n of 
      N.Z => 0
    | N.S n => 1 + fromN n

fun runN query x = 
   case query (op ::) [] empty x of 
      [ n ] => fromN n
    | _ => raise Match

val () = assert (runN Query.fibonacci (toN 11) = 144)

end
