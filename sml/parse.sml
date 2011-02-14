structure Parse = struct

  structure L10LrVals = L10LrValsFn (structure Token = LrParser.Token)
  structure L10Lex = L10LexFn (structure Tokens = L10LrVals.Tokens)
  structure L10Parse = Join (structure ParserData = L10LrVals.ParserData
                            structure Lex = L10Lex
                            structure LrParser = LrParser)

  open L10LrVals.ParserData.Header

  fun parse filename = 
     let
        val instream = TextIO.openIn filename
        val lexer = LrParser.Stream.streamify
           (L10Lex.makeLexer (fn _ => TextIO.input instream))
        val dummyEOF = L10LrVals.Tokens.EOF ((), ())
        val dummyPERIOD = L10LrVals.Tokens.PERIOD ((), ())

        fun error (s, (), ()) = (print (s ^ "\n"); raise Fail "")

        fun loop (lexer, decls) = 
           let
              val ((decl, (), ()), lexer) =
                 L10Parse.parse (15, lexer, error, ())
              val (next, lexer) = L10Parse.Stream.get lexer
              val next = 
                 if L10Parse.sameToken (dummyPERIOD, next)
                 then #1 (L10Parse.Stream.get lexer)
                 else (print "Wha?\n"; raise Fail "Wha?")
           in
              case decl of 
                 Ast.DeclConst (s, _, _) => print ("Term constant " ^ s ^ "\n")
               | Ast.DeclDatabase (s, _, _) => print ("Database " ^ s ^ "\n")
               | Ast.DeclDepends (w1, w2) => print (w1 ^ " after " ^ w2 ^ "\n")
               | Ast.DeclRelation (s, _, _) => print ("Relation " ^ s ^ "\n")
               | Ast.DeclRule (ls, s) => print ("Rule\n")
               | Ast.DeclType s => print ("Type " ^ s ^ "\n")
               | Ast.DeclWorld (s, _) => print ("World " ^ s ^ "\n")
            ; if L10Parse.sameToken (dummyEOF, next)
              then (rev decls) 
              else (loop (lexer, decl :: decls))
           end handle SyntaxError s => 
                      (print ("Error: " ^ s ^ "\n"); rev decls)
     in
        loop (lexer, [])
     end

end
