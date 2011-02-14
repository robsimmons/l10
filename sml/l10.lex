
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

lcid = [a-z_][A-Za-z0-9_]*;
ucid = [A-Z?][A-Za-z0-9_]*;
string = \".*\";
decnum = (0|[1-9][0-9]*);
ws = [\ \t\011\012\r];

%%

<INITIAL> {ws}+       => (lex ());
<INITIAL> \n          => (lex());

<INITIAL> "{"         => (Tokens.LCURLY ((), ()));
<INITIAL> "}"         => (Tokens.RCURLY ((), ()));
<INITIAL> "("         => (Tokens.LPAREN ((), ()));
<INITIAL> ")"         => (Tokens.RPAREN ((), ()));

<INITIAL> "."         => (Tokens.PERIOD ((), ()));
<INITIAL> ","         => (Tokens.COMMA ((), ()));
<INITIAL> ":"         => (Tokens.COLON ((), ()));
<INITIAL> "="         => (Tokens.EQUALS ((), ()));
<INITIAL> "->"        => (Tokens.RARROW ((), ()));
<INITIAL> "@"         => (Tokens.AT ((), ()));

<INITIAL> "world"     => (Tokens.WORLD ((), ()));
<INITIAL> "type"      => (Tokens.TYPE ((), ()));
<INITIAL> "rel"       => (Tokens.REL ((), ()));

<INITIAL> {ucid}      => (Tokens.UCID (yytext, (), ()));
<INITIAL> {lcid}      => (Tokens.LCID (yytext, (), ()));
<INITIAL> {decnum}    => (to_int yytext);
<INITIAL> {string}    => (to_string yytext);
