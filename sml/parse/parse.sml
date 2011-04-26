(* Parser interface for generated L10 parser *)
(* Robert J. Simmons *)

structure Parse :> sig

   type stream
   exception Parse of string
   val parse : string -> stream option * (stream -> Ast.decl * stream option)

end = 
struct

structure L10LrVals = L10LrValsFn (structure Token = LrParser.Token)
structure L10Lex = L10LexFn (structure Tokens = L10LrVals.Tokens)
structure L10Parse = Join (structure ParserData = L10LrVals.ParserData
                           structure Lex = L10Lex
                           structure LrParser = LrParser)

type stream =
   (L10Parse.svalue, L10Parse.pos) LrParser.Token.token L10Parse.Stream.stream

open L10LrVals.ParserData.Header

exception Parse of string

fun parse filename = 
   let
      val instream = TextIO.openIn filename
      val lexer = LrParser.Stream.streamify
         (L10Lex.makeLexer (fn _ => TextIO.input instream))
      val dummyEOF = L10LrVals.Tokens.EOF ((), ())
      val dummyPERIOD = L10LrVals.Tokens.PERIOD ((), ())

      fun error (s, (), ()) = (print (s ^ "\n"); raise Fail "")

      fun loop (lexer: stream) = 
         let
            val ((decl, (), ()), lexer) =
               L10Parse.parse (15, lexer, error, ())
            val (next, lexer) = L10Parse.Stream.get lexer
            val next = 
               if L10Parse.sameToken (dummyPERIOD, next)
               then #1 (L10Parse.Stream.get lexer)
               else (print "Wha?\n"; raise Fail "Wha?")
         in
            if L10Parse.sameToken (dummyEOF, next)
            then (decl, NONE) 
            else (decl, SOME lexer) 
         end handle SyntaxError s => raise Parse s
   in
      (SOME lexer, loop)
      (* XXX won't parse the empty file correctly *)
   end

end
