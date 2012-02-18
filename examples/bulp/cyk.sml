structure Test = 
struct

val () = MLton.Random.srand 0wx8C
fun choice () = 
let
   val r = MLton.Random.rand ()
   (* val () = print ("0x"^Word.toString r^"\n") *)
   fun b n = Word.andb (0wx1, Word.>>(r,n))
in
   (* 60% chance balances things nicely *)
   b 0wx1 + b 0wx2 + b 0wx3 + b 0wx4 + b 0wx5 < 0wx3
end

fun make_input n =
let
   fun make_input' remaining opened = 
      if remaining = 0 
      then []
      else if opened >= remaining
      then ")" :: make_input' (remaining-1) (opened-1)
      else if opened = 0 orelse choice () 
      then "(" :: make_input' (remaining-1) (opened+1)
      else ")" :: make_input' (remaining-1) (opened-1)

   val n' = if n mod 2 = 1 then n + 1 else n
in
   make_input' n' 0
end

fun mapi' (n: IntInf.int) [] tail = (n, rev tail)
  | mapi' (n: IntInf.int) (x :: xs) tail = mapi' (n+1) xs ((n, x) :: tail)
fun mapi xs = mapi' 0 xs []

fun make_db n = 
let 
   val (size, toks) = mapi (make_input n)
   (* val () = print (String.concat (map #2 toks)^"\n") *)
in
   List.foldr Cyk.Assert.tok 
       (Cyk.Assert.expected ((size, Symbol.fromValue "s"), Cyk.parensParsing))
       toks
end

val db = make_db (valOf (IntInf.fromString (hd (CommandLine.arguments ()))))

(*
val () =
   Cyk.Query.valid   
      (fn ((a, b), ()) => print (IntInf.toString a ^"-"^IntInf.toString b^"\n"))
      () db (Symbol.fromValue "s")
*)

val () = 
   if Cyk.Query.success db
   then print "Legal string\n" 
   else print "Not legal string\n"

end
