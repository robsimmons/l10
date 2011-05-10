CM.make "/tmp/cyk.sources.cm";

val lParen = Symbol.symbol "lParen"
val rParen = Symbol.symbol "rParen"
val s = Symbol.symbol "s"
val s' = Symbol.symbol "s'"

val () = 
   let in 
      CykTables.assertTerm ("(", lParen)
      ; CykTables.assertTerm (")", rParen)
      ; CykTables.assertNonterm (s, lParen, rParen)
      ; CykTables.assertNonterm (s, lParen, s')
      ; CykTables.assertNonterm (s, s, s)
      ; CykTables.assertNonterm (s', s, rParen)
   end

fun make_input n =
    let
	val R = Random.rand (67, n)
	val max = ref 0
	fun make_input' remaining opened = 
	    ((
	     if opened > (!max)
	     then max := opened
	     else ()
	    );
	    if remaining = 0 
	    then ""
	    else if opened >= remaining
	    then ")" ^ (make_input' (remaining - 1) (opened - 1))
	    else 
		let
		    val r = Random.randInt R
		in
		    if opened = 0 orelse r > 0
		    then "(" ^ (make_input' (remaining - 1) (opened + 1))
		    else ")" ^ (make_input' (remaining - 1) (opened - 1))
		end)
	val n' = if n mod 2 = 1 then n + 1 else n
	val out = make_input' n' 0
	(* val _ = TextIO.output(TextIO.stdErr, (Int.toString (!max))) *)
    in
	out
    end

fun mapi' n [] = []
  | mapi' n (x :: xs) = (n, x) :: mapi' (n+1) xs

fun mapi xs = mapi' 0 xs

fun assert_input n = 
    let 
       val strs = mapi (map str (explode (make_input n)))
    in
       app (fn (i, tok) => CykTables.assertTok (IntInf.fromInt i, tok)) strs
    end

fun legal n = 
   let val ninf = IntInf.fromInt n 
   in not (null (CykTables.parse_0_lookup (!CykTables.parse_0, (s, 0, ninf))))
   end 

(* Actually run the program *)

(* val SIZE = 200 *)

val () = assert_input SIZE

val _ = CykSearch.saturateW CykTerms.MapWorld.empty 

val () = 
   if legal SIZE 
   then print "Legal string\n" 
   else print "Not legal string\n"

