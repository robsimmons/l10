
fun eof() = Tokens.EOF ((), ())
type pos = unit
type svalue = Tokens.svalue
type ('a, 'b) token = ('a, 'b) Tokens.token
type lexresult = (svalue, pos) Tokens.token

  fun to_int yytext = Tokens.INTCONST (valOf (Int.fromString yytext), (), ())

fun to_string yytext = 
   Tokens.STRCONST 
      (String.translate (fn #"\"" => "" | c => str c) yytext, (), ())

%%

%header (functor L10LexFn(structure Tokens : L10_TOKENS));
%full
%s STRING COMMENT COMMENT_LINE PRAGMA;

lcid = [a-z][A-Za-z0-9_\']*;
ucid = [A-Z][A-Za-z0-9_\']*;
string = \"[A-Za-z0-9_ \'!@#$%^&*()]*\";
decnum = (0|[1-9][0-9]*);
ws = [\ \t\011\012\r];
eol = ("\013\010"|"\010"|"\013");

%%

<INITIAL> {ws}+       => (lex ());
<INITIAL> \n          => (lex());

<INITIAL> "{"         => (Tokens.LCURLY ((), ()));
<INITIAL> "}"         => (Tokens.RCURLY ((), ()));
<INITIAL> "("         => (Tokens.LPAREN ((), ()));
<INITIAL> ")"         => (Tokens.RPAREN ((), ()));
<INITIAL> "Ex"        => (Tokens.EXISTS ((), ()));

<INITIAL> "."         => (Tokens.PERIOD ((), ()));
<INITIAL> ","         => (Tokens.COMMA ((), ()));
<INITIAL> ":"         => (Tokens.COLON ((), ()));
<INITIAL> "="         => (Tokens.EQUALS ((), ()));
<INITIAL> "->"        => (Tokens.RARROW ((), ()));
<INITIAL> "<-"        => (Tokens.LARROW ((), ()));
<INITIAL> "@"         => (Tokens.AT ((), ()));

<INITIAL> "=="        => (Tokens.EQEQ ((), ()));
<INITIAL> "!="        => (Tokens.NEQ ((), ()));
<INITIAL> ">"         => (Tokens.GT ((), ()));
<INITIAL> "<"         => (Tokens.LT ((), ()));
<INITIAL> ">="        => (Tokens.GEQ ((), ()));
<INITIAL> "<="        => (Tokens.LEQ ((), ()));
<INITIAL> "+"         => (Tokens.PLUS ((), ()));

<INITIAL> "world"     => (Tokens.WORLD ((), ()));
<INITIAL> "type"      => (Tokens.TYPE ((), ()));
<INITIAL> "rel"       => (Tokens.REL ((), ()));
<INITIAL> "_"         => (Tokens.UNDERSCORE ((), ()));

<INITIAL> {ucid}      => (Tokens.UCID (yytext, (), ()));
<INITIAL> {lcid}      => (Tokens.LCID (yytext, (), ()));
<INITIAL> {decnum}    => (to_int yytext);
<INITIAL> {string}    => (to_string yytext);
<INITIAL> "//"        => (YYBEGIN COMMENT_LINE; continue ());

<COMMENT_LINE>{eol}   => (YYBEGIN INITIAL; continue ());
<COMMENT_LINE>. => (continue ());
