signature TOKEN = 
sig

datatype tok = 
   EOF | LPAREN | RPAREN | PERIOD
 | COMMA | COLON | EQUALS | LARROW | RARROW | AT
 | LCURLY | RCURLY | EXISTS 
 | UCID of string | LCID of string
 | INTCONST of int | STRCONST of string
 | WORLD | TYPE | REL

end
