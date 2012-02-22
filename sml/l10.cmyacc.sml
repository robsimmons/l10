
functor L10Parse
   (structure Streamable : STREAMABLE
    structure Arg :
       sig
          type pos
          type pos_str
          type pos_int
          type decl
          type syn
          type sings
          type modes

          val mode_ignore : modes -> modes
          val mode_output : modes -> modes
          val mode_input : modes -> modes
          val mode_end : unit -> modes
          val sings_lcid : pos_str * sings -> sings
          val sings_cons : syn * sings -> sings
          val sings_end : unit -> sings
          val String : pos_str -> syn
          val Num : pos_int -> syn
          val Rel : pos -> syn
          val Extensible : pos -> syn
          val Type : pos -> syn
          val World : pos -> syn
          val Uscore : pos -> syn
          val var : pos_str -> syn
          val Paren : pos * syn * pos -> syn
          val Ex : pos * pos_str * syn -> syn
          val Pi : pos * syn * pos * syn -> syn
          val Not : pos * syn -> syn
          val App : pos_str * sings -> syn
          val id1 : syn -> syn
          val plus : syn * syn -> syn
          val leq : syn * syn -> syn
          val geq : syn * syn -> syn
          val lt : syn * syn -> syn
          val gt : syn * syn -> syn
          val neq : syn * syn -> syn
          val eqeq : syn * syn -> syn
          val At : syn * syn -> syn
          val Conj : syn * syn -> syn
          val Arrow : syn * syn -> syn
          val larrow : syn * syn -> syn
          val Assign : pos_str * syn -> syn
          val Ascribe : pos_str * syn -> syn
          val ascribe_ucid : pos_str * syn -> syn
          val Ucid : pos_str -> syn
          val PragmaType : pos * pos_str * pos_str * pos * decl -> decl
          val PragmaQuery : pos * pos_str * pos_str * modes * pos * decl -> decl
          val AnnoType : pos * pos_str * pos_str * pos * decl -> decl
          val AnnoQuery : pos * pos_str * pos_str * modes * pos * decl -> decl
          val Syn : syn * pos * decl -> decl
          val Done : unit -> decl

          datatype terminal =
             LCURLY of pos
           | RCURLY of pos
           | LPAREN of pos
           | RPAREN of pos
           | EX of pos
           | PERIOD of pos
           | COLON of pos
           | EQ of pos
           | LARROW of pos
           | RARROW of pos
           | COMMA of pos
           | AT of pos
           | EQEQ of pos
           | NEQ of pos
           | GT of pos
           | LT of pos
           | GEQ of pos
           | LEQ of pos
           | PLUS of pos
           | MINUS of pos
           | NOT of pos
           | WORLD of pos
           | TYPE of pos
           | EXTENSIBLE of pos
           | REL of pos
           | USCORE of pos
           | UCID of pos_str
           | LCID of pos_str
           | NUM of pos_int
           | STRING of pos_str
           | LANNO of pos
           | RANNO of pos
           | ANNO_QUERY of pos
           | ANNO_TYPE of pos
           | PRAGMA_QUERY of pos
           | PRAGMA_TYPE of pos

          val error : terminal Streamable.t -> exn
       end)
   :>
   sig
      val parse : Arg.terminal Streamable.t -> Arg.decl * Arg.terminal Streamable.t
   end
=

(*

AUTOMATON LISTING
=================

State 0:

start -> . Decl  / 0
0 : Decl -> .  / 0
1 : Decl -> . Syn PERIOD Decl  / 0
2 : Decl -> . LANNO ANNO_QUERY LCID LCID Modes RANNO Decl  / 0
3 : Decl -> . LANNO ANNO_TYPE LCID LCID RANNO Decl  / 0
4 : Decl -> . PRAGMA_QUERY LCID COLON LCID Modes PERIOD Decl  / 0
5 : Decl -> . PRAGMA_TYPE LCID LCID PERIOD Decl  / 0
8 : Syn -> . LCID COLON Syn  / 1
9 : Syn -> . LCID EQ Syn  / 1
10 : Syn -> . Syn LARROW Syn  / 1
11 : Syn -> . Syn RARROW Syn  / 1
12 : Syn -> . Syn COMMA Syn  / 1
13 : Syn -> . Syn AT Syn  / 1
14 : Syn -> . Syn EQEQ Syn  / 1
15 : Syn -> . Syn NEQ Syn  / 1
16 : Syn -> . Syn GT Syn  / 1
17 : Syn -> . Syn LT Syn  / 1
18 : Syn -> . Syn GEQ Syn  / 1
19 : Syn -> . Syn LEQ Syn  / 1
20 : Syn -> . Syn PLUS Syn  / 1
21 : Syn -> . Simp  / 1
22 : Syn -> . LCID Sings  / 1
23 : Syn -> . NOT Simp  / 1
24 : Syn -> . LCURLY Bind RCURLY Syn  / 1
25 : Syn -> . EX UCID PERIOD Syn  / 1
26 : Simp -> . LPAREN Syn RPAREN  / 1
27 : Simp -> . UCID  / 1
28 : Simp -> . USCORE  / 1
29 : Simp -> . WORLD  / 1
30 : Simp -> . TYPE  / 1
31 : Simp -> . EXTENSIBLE  / 1
32 : Simp -> . REL  / 1
33 : Simp -> . NUM  / 1
34 : Simp -> . STRING  / 1

$ => reduce 0
LCURLY => shift 10
LPAREN => shift 9
EX => shift 11
NOT => shift 8
WORLD => shift 7
TYPE => shift 6
EXTENSIBLE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 13
LCID => shift 12
NUM => shift 2
STRING => shift 1
LANNO => shift 14
PRAGMA_QUERY => shift 15
PRAGMA_TYPE => shift 19
Decl => goto 17
Syn => goto 16
Simp => goto 18

-----

State 1:

34 : Simp -> STRING .  / 2

RCURLY => reduce 34
LPAREN => reduce 34
RPAREN => reduce 34
PERIOD => reduce 34
LARROW => reduce 34
RARROW => reduce 34
COMMA => reduce 34
AT => reduce 34
EQEQ => reduce 34
NEQ => reduce 34
GT => reduce 34
LT => reduce 34
GEQ => reduce 34
LEQ => reduce 34
PLUS => reduce 34
WORLD => reduce 34
TYPE => reduce 34
EXTENSIBLE => reduce 34
REL => reduce 34
USCORE => reduce 34
UCID => reduce 34
LCID => reduce 34
NUM => reduce 34
STRING => reduce 34

-----

State 2:

33 : Simp -> NUM .  / 2

RCURLY => reduce 33
LPAREN => reduce 33
RPAREN => reduce 33
PERIOD => reduce 33
LARROW => reduce 33
RARROW => reduce 33
COMMA => reduce 33
AT => reduce 33
EQEQ => reduce 33
NEQ => reduce 33
GT => reduce 33
LT => reduce 33
GEQ => reduce 33
LEQ => reduce 33
PLUS => reduce 33
WORLD => reduce 33
TYPE => reduce 33
EXTENSIBLE => reduce 33
REL => reduce 33
USCORE => reduce 33
UCID => reduce 33
LCID => reduce 33
NUM => reduce 33
STRING => reduce 33

-----

State 3:

28 : Simp -> USCORE .  / 2

RCURLY => reduce 28
LPAREN => reduce 28
RPAREN => reduce 28
PERIOD => reduce 28
LARROW => reduce 28
RARROW => reduce 28
COMMA => reduce 28
AT => reduce 28
EQEQ => reduce 28
NEQ => reduce 28
GT => reduce 28
LT => reduce 28
GEQ => reduce 28
LEQ => reduce 28
PLUS => reduce 28
WORLD => reduce 28
TYPE => reduce 28
EXTENSIBLE => reduce 28
REL => reduce 28
USCORE => reduce 28
UCID => reduce 28
LCID => reduce 28
NUM => reduce 28
STRING => reduce 28

-----

State 4:

32 : Simp -> REL .  / 2

RCURLY => reduce 32
LPAREN => reduce 32
RPAREN => reduce 32
PERIOD => reduce 32
LARROW => reduce 32
RARROW => reduce 32
COMMA => reduce 32
AT => reduce 32
EQEQ => reduce 32
NEQ => reduce 32
GT => reduce 32
LT => reduce 32
GEQ => reduce 32
LEQ => reduce 32
PLUS => reduce 32
WORLD => reduce 32
TYPE => reduce 32
EXTENSIBLE => reduce 32
REL => reduce 32
USCORE => reduce 32
UCID => reduce 32
LCID => reduce 32
NUM => reduce 32
STRING => reduce 32

-----

State 5:

31 : Simp -> EXTENSIBLE .  / 2

RCURLY => reduce 31
LPAREN => reduce 31
RPAREN => reduce 31
PERIOD => reduce 31
LARROW => reduce 31
RARROW => reduce 31
COMMA => reduce 31
AT => reduce 31
EQEQ => reduce 31
NEQ => reduce 31
GT => reduce 31
LT => reduce 31
GEQ => reduce 31
LEQ => reduce 31
PLUS => reduce 31
WORLD => reduce 31
TYPE => reduce 31
EXTENSIBLE => reduce 31
REL => reduce 31
USCORE => reduce 31
UCID => reduce 31
LCID => reduce 31
NUM => reduce 31
STRING => reduce 31

-----

State 6:

30 : Simp -> TYPE .  / 2

RCURLY => reduce 30
LPAREN => reduce 30
RPAREN => reduce 30
PERIOD => reduce 30
LARROW => reduce 30
RARROW => reduce 30
COMMA => reduce 30
AT => reduce 30
EQEQ => reduce 30
NEQ => reduce 30
GT => reduce 30
LT => reduce 30
GEQ => reduce 30
LEQ => reduce 30
PLUS => reduce 30
WORLD => reduce 30
TYPE => reduce 30
EXTENSIBLE => reduce 30
REL => reduce 30
USCORE => reduce 30
UCID => reduce 30
LCID => reduce 30
NUM => reduce 30
STRING => reduce 30

-----

State 7:

29 : Simp -> WORLD .  / 2

RCURLY => reduce 29
LPAREN => reduce 29
RPAREN => reduce 29
PERIOD => reduce 29
LARROW => reduce 29
RARROW => reduce 29
COMMA => reduce 29
AT => reduce 29
EQEQ => reduce 29
NEQ => reduce 29
GT => reduce 29
LT => reduce 29
GEQ => reduce 29
LEQ => reduce 29
PLUS => reduce 29
WORLD => reduce 29
TYPE => reduce 29
EXTENSIBLE => reduce 29
REL => reduce 29
USCORE => reduce 29
UCID => reduce 29
LCID => reduce 29
NUM => reduce 29
STRING => reduce 29

-----

State 8:

23 : Syn -> NOT . Simp  / 3
26 : Simp -> . LPAREN Syn RPAREN  / 3
27 : Simp -> . UCID  / 3
28 : Simp -> . USCORE  / 3
29 : Simp -> . WORLD  / 3
30 : Simp -> . TYPE  / 3
31 : Simp -> . EXTENSIBLE  / 3
32 : Simp -> . REL  / 3
33 : Simp -> . NUM  / 3
34 : Simp -> . STRING  / 3

LPAREN => shift 9
WORLD => shift 7
TYPE => shift 6
EXTENSIBLE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 13
NUM => shift 2
STRING => shift 1
Simp => goto 20

-----

State 9:

8 : Syn -> . LCID COLON Syn  / 4
9 : Syn -> . LCID EQ Syn  / 4
10 : Syn -> . Syn LARROW Syn  / 4
11 : Syn -> . Syn RARROW Syn  / 4
12 : Syn -> . Syn COMMA Syn  / 4
13 : Syn -> . Syn AT Syn  / 4
14 : Syn -> . Syn EQEQ Syn  / 4
15 : Syn -> . Syn NEQ Syn  / 4
16 : Syn -> . Syn GT Syn  / 4
17 : Syn -> . Syn LT Syn  / 4
18 : Syn -> . Syn GEQ Syn  / 4
19 : Syn -> . Syn LEQ Syn  / 4
20 : Syn -> . Syn PLUS Syn  / 4
21 : Syn -> . Simp  / 4
22 : Syn -> . LCID Sings  / 4
23 : Syn -> . NOT Simp  / 4
24 : Syn -> . LCURLY Bind RCURLY Syn  / 4
25 : Syn -> . EX UCID PERIOD Syn  / 4
26 : Simp -> . LPAREN Syn RPAREN  / 4
26 : Simp -> LPAREN . Syn RPAREN  / 2
27 : Simp -> . UCID  / 4
28 : Simp -> . USCORE  / 4
29 : Simp -> . WORLD  / 4
30 : Simp -> . TYPE  / 4
31 : Simp -> . EXTENSIBLE  / 4
32 : Simp -> . REL  / 4
33 : Simp -> . NUM  / 4
34 : Simp -> . STRING  / 4

LCURLY => shift 10
LPAREN => shift 9
EX => shift 11
NOT => shift 8
WORLD => shift 7
TYPE => shift 6
EXTENSIBLE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 13
LCID => shift 12
NUM => shift 2
STRING => shift 1
Syn => goto 21
Simp => goto 18

-----

State 10:

6 : Bind -> . UCID  / 5
7 : Bind -> . UCID COLON Syn  / 5
24 : Syn -> LCURLY . Bind RCURLY Syn  / 3

UCID => shift 23
Bind => goto 22

-----

State 11:

25 : Syn -> EX . UCID PERIOD Syn  / 3

UCID => shift 24

-----

State 12:

8 : Syn -> LCID . COLON Syn  / 3
9 : Syn -> LCID . EQ Syn  / 3
22 : Syn -> LCID . Sings  / 3
26 : Simp -> . LPAREN Syn RPAREN  / 2
27 : Simp -> . UCID  / 2
28 : Simp -> . USCORE  / 2
29 : Simp -> . WORLD  / 2
30 : Simp -> . TYPE  / 2
31 : Simp -> . EXTENSIBLE  / 2
32 : Simp -> . REL  / 2
33 : Simp -> . NUM  / 2
34 : Simp -> . STRING  / 2
35 : Sings -> .  / 3
36 : Sings -> . Simp Sings  / 3
37 : Sings -> . LCID Sings  / 3

RCURLY => reduce 35
LPAREN => shift 9
RPAREN => reduce 35
PERIOD => reduce 35
COLON => shift 27
EQ => shift 26
LARROW => reduce 35
RARROW => reduce 35
COMMA => reduce 35
AT => reduce 35
EQEQ => reduce 35
NEQ => reduce 35
GT => reduce 35
LT => reduce 35
GEQ => reduce 35
LEQ => reduce 35
PLUS => reduce 35
WORLD => shift 7
TYPE => shift 6
EXTENSIBLE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 13
LCID => shift 25
NUM => shift 2
STRING => shift 1
Simp => goto 28
Sings => goto 29

-----

State 13:

27 : Simp -> UCID .  / 2

RCURLY => reduce 27
LPAREN => reduce 27
RPAREN => reduce 27
PERIOD => reduce 27
LARROW => reduce 27
RARROW => reduce 27
COMMA => reduce 27
AT => reduce 27
EQEQ => reduce 27
NEQ => reduce 27
GT => reduce 27
LT => reduce 27
GEQ => reduce 27
LEQ => reduce 27
PLUS => reduce 27
WORLD => reduce 27
TYPE => reduce 27
EXTENSIBLE => reduce 27
REL => reduce 27
USCORE => reduce 27
UCID => reduce 27
LCID => reduce 27
NUM => reduce 27
STRING => reduce 27

-----

State 14:

2 : Decl -> LANNO . ANNO_QUERY LCID LCID Modes RANNO Decl  / 0
3 : Decl -> LANNO . ANNO_TYPE LCID LCID RANNO Decl  / 0

ANNO_QUERY => shift 31
ANNO_TYPE => shift 30

-----

State 15:

4 : Decl -> PRAGMA_QUERY . LCID COLON LCID Modes PERIOD Decl  / 0

LCID => shift 32

-----

State 16:

1 : Decl -> Syn . PERIOD Decl  / 0
10 : Syn -> Syn . LARROW Syn  / 1
11 : Syn -> Syn . RARROW Syn  / 1
12 : Syn -> Syn . COMMA Syn  / 1
13 : Syn -> Syn . AT Syn  / 1
14 : Syn -> Syn . EQEQ Syn  / 1
15 : Syn -> Syn . NEQ Syn  / 1
16 : Syn -> Syn . GT Syn  / 1
17 : Syn -> Syn . LT Syn  / 1
18 : Syn -> Syn . GEQ Syn  / 1
19 : Syn -> Syn . LEQ Syn  / 1
20 : Syn -> Syn . PLUS Syn  / 1

PERIOD => shift 44
LARROW => shift 43
RARROW => shift 42
COMMA => shift 41
AT => shift 40
EQEQ => shift 39
NEQ => shift 38
GT => shift 37
LT => shift 36
GEQ => shift 35
LEQ => shift 34
PLUS => shift 33

-----

State 17:

start -> Decl .  / 0

$ => accept

-----

State 18:

21 : Syn -> Simp .  / 3

RCURLY => reduce 21
RPAREN => reduce 21
PERIOD => reduce 21
LARROW => reduce 21
RARROW => reduce 21
COMMA => reduce 21
AT => reduce 21
EQEQ => reduce 21
NEQ => reduce 21
GT => reduce 21
LT => reduce 21
GEQ => reduce 21
LEQ => reduce 21
PLUS => reduce 21

-----

State 19:

5 : Decl -> PRAGMA_TYPE . LCID LCID PERIOD Decl  / 0

LCID => shift 45

-----

State 20:

23 : Syn -> NOT Simp .  / 3

RCURLY => reduce 23
RPAREN => reduce 23
PERIOD => reduce 23
LARROW => reduce 23
RARROW => reduce 23
COMMA => reduce 23
AT => reduce 23
EQEQ => reduce 23
NEQ => reduce 23
GT => reduce 23
LT => reduce 23
GEQ => reduce 23
LEQ => reduce 23
PLUS => reduce 23

-----

State 21:

10 : Syn -> Syn . LARROW Syn  / 4
11 : Syn -> Syn . RARROW Syn  / 4
12 : Syn -> Syn . COMMA Syn  / 4
13 : Syn -> Syn . AT Syn  / 4
14 : Syn -> Syn . EQEQ Syn  / 4
15 : Syn -> Syn . NEQ Syn  / 4
16 : Syn -> Syn . GT Syn  / 4
17 : Syn -> Syn . LT Syn  / 4
18 : Syn -> Syn . GEQ Syn  / 4
19 : Syn -> Syn . LEQ Syn  / 4
20 : Syn -> Syn . PLUS Syn  / 4
26 : Simp -> LPAREN Syn . RPAREN  / 2

RPAREN => shift 46
LARROW => shift 43
RARROW => shift 42
COMMA => shift 41
AT => shift 40
EQEQ => shift 39
NEQ => shift 38
GT => shift 37
LT => shift 36
GEQ => shift 35
LEQ => shift 34
PLUS => shift 33

-----

State 22:

24 : Syn -> LCURLY Bind . RCURLY Syn  / 3

RCURLY => shift 47

-----

State 23:

6 : Bind -> UCID .  / 5
7 : Bind -> UCID . COLON Syn  / 5

RCURLY => reduce 6
COLON => shift 48

-----

State 24:

25 : Syn -> EX UCID . PERIOD Syn  / 3

PERIOD => shift 49

-----

State 25:

26 : Simp -> . LPAREN Syn RPAREN  / 2
27 : Simp -> . UCID  / 2
28 : Simp -> . USCORE  / 2
29 : Simp -> . WORLD  / 2
30 : Simp -> . TYPE  / 2
31 : Simp -> . EXTENSIBLE  / 2
32 : Simp -> . REL  / 2
33 : Simp -> . NUM  / 2
34 : Simp -> . STRING  / 2
35 : Sings -> .  / 3
36 : Sings -> . Simp Sings  / 3
37 : Sings -> . LCID Sings  / 3
37 : Sings -> LCID . Sings  / 3

RCURLY => reduce 35
LPAREN => shift 9
RPAREN => reduce 35
PERIOD => reduce 35
LARROW => reduce 35
RARROW => reduce 35
COMMA => reduce 35
AT => reduce 35
EQEQ => reduce 35
NEQ => reduce 35
GT => reduce 35
LT => reduce 35
GEQ => reduce 35
LEQ => reduce 35
PLUS => reduce 35
WORLD => shift 7
TYPE => shift 6
EXTENSIBLE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 13
LCID => shift 25
NUM => shift 2
STRING => shift 1
Simp => goto 28
Sings => goto 50

-----

State 26:

8 : Syn -> . LCID COLON Syn  / 3
9 : Syn -> . LCID EQ Syn  / 3
9 : Syn -> LCID EQ . Syn  / 3
10 : Syn -> . Syn LARROW Syn  / 3
11 : Syn -> . Syn RARROW Syn  / 3
12 : Syn -> . Syn COMMA Syn  / 3
13 : Syn -> . Syn AT Syn  / 3
14 : Syn -> . Syn EQEQ Syn  / 3
15 : Syn -> . Syn NEQ Syn  / 3
16 : Syn -> . Syn GT Syn  / 3
17 : Syn -> . Syn LT Syn  / 3
18 : Syn -> . Syn GEQ Syn  / 3
19 : Syn -> . Syn LEQ Syn  / 3
20 : Syn -> . Syn PLUS Syn  / 3
21 : Syn -> . Simp  / 3
22 : Syn -> . LCID Sings  / 3
23 : Syn -> . NOT Simp  / 3
24 : Syn -> . LCURLY Bind RCURLY Syn  / 3
25 : Syn -> . EX UCID PERIOD Syn  / 3
26 : Simp -> . LPAREN Syn RPAREN  / 3
27 : Simp -> . UCID  / 3
28 : Simp -> . USCORE  / 3
29 : Simp -> . WORLD  / 3
30 : Simp -> . TYPE  / 3
31 : Simp -> . EXTENSIBLE  / 3
32 : Simp -> . REL  / 3
33 : Simp -> . NUM  / 3
34 : Simp -> . STRING  / 3

LCURLY => shift 10
LPAREN => shift 9
EX => shift 11
NOT => shift 8
WORLD => shift 7
TYPE => shift 6
EXTENSIBLE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 13
LCID => shift 12
NUM => shift 2
STRING => shift 1
Syn => goto 51
Simp => goto 18

-----

State 27:

8 : Syn -> . LCID COLON Syn  / 3
8 : Syn -> LCID COLON . Syn  / 3
9 : Syn -> . LCID EQ Syn  / 3
10 : Syn -> . Syn LARROW Syn  / 3
11 : Syn -> . Syn RARROW Syn  / 3
12 : Syn -> . Syn COMMA Syn  / 3
13 : Syn -> . Syn AT Syn  / 3
14 : Syn -> . Syn EQEQ Syn  / 3
15 : Syn -> . Syn NEQ Syn  / 3
16 : Syn -> . Syn GT Syn  / 3
17 : Syn -> . Syn LT Syn  / 3
18 : Syn -> . Syn GEQ Syn  / 3
19 : Syn -> . Syn LEQ Syn  / 3
20 : Syn -> . Syn PLUS Syn  / 3
21 : Syn -> . Simp  / 3
22 : Syn -> . LCID Sings  / 3
23 : Syn -> . NOT Simp  / 3
24 : Syn -> . LCURLY Bind RCURLY Syn  / 3
25 : Syn -> . EX UCID PERIOD Syn  / 3
26 : Simp -> . LPAREN Syn RPAREN  / 3
27 : Simp -> . UCID  / 3
28 : Simp -> . USCORE  / 3
29 : Simp -> . WORLD  / 3
30 : Simp -> . TYPE  / 3
31 : Simp -> . EXTENSIBLE  / 3
32 : Simp -> . REL  / 3
33 : Simp -> . NUM  / 3
34 : Simp -> . STRING  / 3

LCURLY => shift 10
LPAREN => shift 9
EX => shift 11
NOT => shift 8
WORLD => shift 7
TYPE => shift 6
EXTENSIBLE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 13
LCID => shift 12
NUM => shift 2
STRING => shift 1
Syn => goto 52
Simp => goto 18

-----

State 28:

26 : Simp -> . LPAREN Syn RPAREN  / 2
27 : Simp -> . UCID  / 2
28 : Simp -> . USCORE  / 2
29 : Simp -> . WORLD  / 2
30 : Simp -> . TYPE  / 2
31 : Simp -> . EXTENSIBLE  / 2
32 : Simp -> . REL  / 2
33 : Simp -> . NUM  / 2
34 : Simp -> . STRING  / 2
35 : Sings -> .  / 3
36 : Sings -> . Simp Sings  / 3
36 : Sings -> Simp . Sings  / 3
37 : Sings -> . LCID Sings  / 3

RCURLY => reduce 35
LPAREN => shift 9
RPAREN => reduce 35
PERIOD => reduce 35
LARROW => reduce 35
RARROW => reduce 35
COMMA => reduce 35
AT => reduce 35
EQEQ => reduce 35
NEQ => reduce 35
GT => reduce 35
LT => reduce 35
GEQ => reduce 35
LEQ => reduce 35
PLUS => reduce 35
WORLD => shift 7
TYPE => shift 6
EXTENSIBLE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 13
LCID => shift 25
NUM => shift 2
STRING => shift 1
Simp => goto 28
Sings => goto 53

-----

State 29:

22 : Syn -> LCID Sings .  / 3

RCURLY => reduce 22
RPAREN => reduce 22
PERIOD => reduce 22
LARROW => reduce 22
RARROW => reduce 22
COMMA => reduce 22
AT => reduce 22
EQEQ => reduce 22
NEQ => reduce 22
GT => reduce 22
LT => reduce 22
GEQ => reduce 22
LEQ => reduce 22
PLUS => reduce 22

-----

State 30:

3 : Decl -> LANNO ANNO_TYPE . LCID LCID RANNO Decl  / 0

LCID => shift 54

-----

State 31:

2 : Decl -> LANNO ANNO_QUERY . LCID LCID Modes RANNO Decl  / 0

LCID => shift 55

-----

State 32:

4 : Decl -> PRAGMA_QUERY LCID . COLON LCID Modes PERIOD Decl  / 0

COLON => shift 56

-----

State 33:

8 : Syn -> . LCID COLON Syn  / 3
9 : Syn -> . LCID EQ Syn  / 3
10 : Syn -> . Syn LARROW Syn  / 3
11 : Syn -> . Syn RARROW Syn  / 3
12 : Syn -> . Syn COMMA Syn  / 3
13 : Syn -> . Syn AT Syn  / 3
14 : Syn -> . Syn EQEQ Syn  / 3
15 : Syn -> . Syn NEQ Syn  / 3
16 : Syn -> . Syn GT Syn  / 3
17 : Syn -> . Syn LT Syn  / 3
18 : Syn -> . Syn GEQ Syn  / 3
19 : Syn -> . Syn LEQ Syn  / 3
20 : Syn -> . Syn PLUS Syn  / 3
20 : Syn -> Syn PLUS . Syn  / 3
21 : Syn -> . Simp  / 3
22 : Syn -> . LCID Sings  / 3
23 : Syn -> . NOT Simp  / 3
24 : Syn -> . LCURLY Bind RCURLY Syn  / 3
25 : Syn -> . EX UCID PERIOD Syn  / 3
26 : Simp -> . LPAREN Syn RPAREN  / 3
27 : Simp -> . UCID  / 3
28 : Simp -> . USCORE  / 3
29 : Simp -> . WORLD  / 3
30 : Simp -> . TYPE  / 3
31 : Simp -> . EXTENSIBLE  / 3
32 : Simp -> . REL  / 3
33 : Simp -> . NUM  / 3
34 : Simp -> . STRING  / 3

LCURLY => shift 10
LPAREN => shift 9
EX => shift 11
NOT => shift 8
WORLD => shift 7
TYPE => shift 6
EXTENSIBLE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 13
LCID => shift 12
NUM => shift 2
STRING => shift 1
Syn => goto 57
Simp => goto 18

-----

State 34:

8 : Syn -> . LCID COLON Syn  / 3
9 : Syn -> . LCID EQ Syn  / 3
10 : Syn -> . Syn LARROW Syn  / 3
11 : Syn -> . Syn RARROW Syn  / 3
12 : Syn -> . Syn COMMA Syn  / 3
13 : Syn -> . Syn AT Syn  / 3
14 : Syn -> . Syn EQEQ Syn  / 3
15 : Syn -> . Syn NEQ Syn  / 3
16 : Syn -> . Syn GT Syn  / 3
17 : Syn -> . Syn LT Syn  / 3
18 : Syn -> . Syn GEQ Syn  / 3
19 : Syn -> . Syn LEQ Syn  / 3
19 : Syn -> Syn LEQ . Syn  / 3
20 : Syn -> . Syn PLUS Syn  / 3
21 : Syn -> . Simp  / 3
22 : Syn -> . LCID Sings  / 3
23 : Syn -> . NOT Simp  / 3
24 : Syn -> . LCURLY Bind RCURLY Syn  / 3
25 : Syn -> . EX UCID PERIOD Syn  / 3
26 : Simp -> . LPAREN Syn RPAREN  / 3
27 : Simp -> . UCID  / 3
28 : Simp -> . USCORE  / 3
29 : Simp -> . WORLD  / 3
30 : Simp -> . TYPE  / 3
31 : Simp -> . EXTENSIBLE  / 3
32 : Simp -> . REL  / 3
33 : Simp -> . NUM  / 3
34 : Simp -> . STRING  / 3

LCURLY => shift 10
LPAREN => shift 9
EX => shift 11
NOT => shift 8
WORLD => shift 7
TYPE => shift 6
EXTENSIBLE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 13
LCID => shift 12
NUM => shift 2
STRING => shift 1
Syn => goto 58
Simp => goto 18

-----

State 35:

8 : Syn -> . LCID COLON Syn  / 3
9 : Syn -> . LCID EQ Syn  / 3
10 : Syn -> . Syn LARROW Syn  / 3
11 : Syn -> . Syn RARROW Syn  / 3
12 : Syn -> . Syn COMMA Syn  / 3
13 : Syn -> . Syn AT Syn  / 3
14 : Syn -> . Syn EQEQ Syn  / 3
15 : Syn -> . Syn NEQ Syn  / 3
16 : Syn -> . Syn GT Syn  / 3
17 : Syn -> . Syn LT Syn  / 3
18 : Syn -> . Syn GEQ Syn  / 3
18 : Syn -> Syn GEQ . Syn  / 3
19 : Syn -> . Syn LEQ Syn  / 3
20 : Syn -> . Syn PLUS Syn  / 3
21 : Syn -> . Simp  / 3
22 : Syn -> . LCID Sings  / 3
23 : Syn -> . NOT Simp  / 3
24 : Syn -> . LCURLY Bind RCURLY Syn  / 3
25 : Syn -> . EX UCID PERIOD Syn  / 3
26 : Simp -> . LPAREN Syn RPAREN  / 3
27 : Simp -> . UCID  / 3
28 : Simp -> . USCORE  / 3
29 : Simp -> . WORLD  / 3
30 : Simp -> . TYPE  / 3
31 : Simp -> . EXTENSIBLE  / 3
32 : Simp -> . REL  / 3
33 : Simp -> . NUM  / 3
34 : Simp -> . STRING  / 3

LCURLY => shift 10
LPAREN => shift 9
EX => shift 11
NOT => shift 8
WORLD => shift 7
TYPE => shift 6
EXTENSIBLE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 13
LCID => shift 12
NUM => shift 2
STRING => shift 1
Syn => goto 59
Simp => goto 18

-----

State 36:

8 : Syn -> . LCID COLON Syn  / 3
9 : Syn -> . LCID EQ Syn  / 3
10 : Syn -> . Syn LARROW Syn  / 3
11 : Syn -> . Syn RARROW Syn  / 3
12 : Syn -> . Syn COMMA Syn  / 3
13 : Syn -> . Syn AT Syn  / 3
14 : Syn -> . Syn EQEQ Syn  / 3
15 : Syn -> . Syn NEQ Syn  / 3
16 : Syn -> . Syn GT Syn  / 3
17 : Syn -> . Syn LT Syn  / 3
17 : Syn -> Syn LT . Syn  / 3
18 : Syn -> . Syn GEQ Syn  / 3
19 : Syn -> . Syn LEQ Syn  / 3
20 : Syn -> . Syn PLUS Syn  / 3
21 : Syn -> . Simp  / 3
22 : Syn -> . LCID Sings  / 3
23 : Syn -> . NOT Simp  / 3
24 : Syn -> . LCURLY Bind RCURLY Syn  / 3
25 : Syn -> . EX UCID PERIOD Syn  / 3
26 : Simp -> . LPAREN Syn RPAREN  / 3
27 : Simp -> . UCID  / 3
28 : Simp -> . USCORE  / 3
29 : Simp -> . WORLD  / 3
30 : Simp -> . TYPE  / 3
31 : Simp -> . EXTENSIBLE  / 3
32 : Simp -> . REL  / 3
33 : Simp -> . NUM  / 3
34 : Simp -> . STRING  / 3

LCURLY => shift 10
LPAREN => shift 9
EX => shift 11
NOT => shift 8
WORLD => shift 7
TYPE => shift 6
EXTENSIBLE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 13
LCID => shift 12
NUM => shift 2
STRING => shift 1
Syn => goto 60
Simp => goto 18

-----

State 37:

8 : Syn -> . LCID COLON Syn  / 3
9 : Syn -> . LCID EQ Syn  / 3
10 : Syn -> . Syn LARROW Syn  / 3
11 : Syn -> . Syn RARROW Syn  / 3
12 : Syn -> . Syn COMMA Syn  / 3
13 : Syn -> . Syn AT Syn  / 3
14 : Syn -> . Syn EQEQ Syn  / 3
15 : Syn -> . Syn NEQ Syn  / 3
16 : Syn -> . Syn GT Syn  / 3
16 : Syn -> Syn GT . Syn  / 3
17 : Syn -> . Syn LT Syn  / 3
18 : Syn -> . Syn GEQ Syn  / 3
19 : Syn -> . Syn LEQ Syn  / 3
20 : Syn -> . Syn PLUS Syn  / 3
21 : Syn -> . Simp  / 3
22 : Syn -> . LCID Sings  / 3
23 : Syn -> . NOT Simp  / 3
24 : Syn -> . LCURLY Bind RCURLY Syn  / 3
25 : Syn -> . EX UCID PERIOD Syn  / 3
26 : Simp -> . LPAREN Syn RPAREN  / 3
27 : Simp -> . UCID  / 3
28 : Simp -> . USCORE  / 3
29 : Simp -> . WORLD  / 3
30 : Simp -> . TYPE  / 3
31 : Simp -> . EXTENSIBLE  / 3
32 : Simp -> . REL  / 3
33 : Simp -> . NUM  / 3
34 : Simp -> . STRING  / 3

LCURLY => shift 10
LPAREN => shift 9
EX => shift 11
NOT => shift 8
WORLD => shift 7
TYPE => shift 6
EXTENSIBLE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 13
LCID => shift 12
NUM => shift 2
STRING => shift 1
Syn => goto 61
Simp => goto 18

-----

State 38:

8 : Syn -> . LCID COLON Syn  / 3
9 : Syn -> . LCID EQ Syn  / 3
10 : Syn -> . Syn LARROW Syn  / 3
11 : Syn -> . Syn RARROW Syn  / 3
12 : Syn -> . Syn COMMA Syn  / 3
13 : Syn -> . Syn AT Syn  / 3
14 : Syn -> . Syn EQEQ Syn  / 3
15 : Syn -> . Syn NEQ Syn  / 3
15 : Syn -> Syn NEQ . Syn  / 3
16 : Syn -> . Syn GT Syn  / 3
17 : Syn -> . Syn LT Syn  / 3
18 : Syn -> . Syn GEQ Syn  / 3
19 : Syn -> . Syn LEQ Syn  / 3
20 : Syn -> . Syn PLUS Syn  / 3
21 : Syn -> . Simp  / 3
22 : Syn -> . LCID Sings  / 3
23 : Syn -> . NOT Simp  / 3
24 : Syn -> . LCURLY Bind RCURLY Syn  / 3
25 : Syn -> . EX UCID PERIOD Syn  / 3
26 : Simp -> . LPAREN Syn RPAREN  / 3
27 : Simp -> . UCID  / 3
28 : Simp -> . USCORE  / 3
29 : Simp -> . WORLD  / 3
30 : Simp -> . TYPE  / 3
31 : Simp -> . EXTENSIBLE  / 3
32 : Simp -> . REL  / 3
33 : Simp -> . NUM  / 3
34 : Simp -> . STRING  / 3

LCURLY => shift 10
LPAREN => shift 9
EX => shift 11
NOT => shift 8
WORLD => shift 7
TYPE => shift 6
EXTENSIBLE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 13
LCID => shift 12
NUM => shift 2
STRING => shift 1
Syn => goto 62
Simp => goto 18

-----

State 39:

8 : Syn -> . LCID COLON Syn  / 3
9 : Syn -> . LCID EQ Syn  / 3
10 : Syn -> . Syn LARROW Syn  / 3
11 : Syn -> . Syn RARROW Syn  / 3
12 : Syn -> . Syn COMMA Syn  / 3
13 : Syn -> . Syn AT Syn  / 3
14 : Syn -> . Syn EQEQ Syn  / 3
14 : Syn -> Syn EQEQ . Syn  / 3
15 : Syn -> . Syn NEQ Syn  / 3
16 : Syn -> . Syn GT Syn  / 3
17 : Syn -> . Syn LT Syn  / 3
18 : Syn -> . Syn GEQ Syn  / 3
19 : Syn -> . Syn LEQ Syn  / 3
20 : Syn -> . Syn PLUS Syn  / 3
21 : Syn -> . Simp  / 3
22 : Syn -> . LCID Sings  / 3
23 : Syn -> . NOT Simp  / 3
24 : Syn -> . LCURLY Bind RCURLY Syn  / 3
25 : Syn -> . EX UCID PERIOD Syn  / 3
26 : Simp -> . LPAREN Syn RPAREN  / 3
27 : Simp -> . UCID  / 3
28 : Simp -> . USCORE  / 3
29 : Simp -> . WORLD  / 3
30 : Simp -> . TYPE  / 3
31 : Simp -> . EXTENSIBLE  / 3
32 : Simp -> . REL  / 3
33 : Simp -> . NUM  / 3
34 : Simp -> . STRING  / 3

LCURLY => shift 10
LPAREN => shift 9
EX => shift 11
NOT => shift 8
WORLD => shift 7
TYPE => shift 6
EXTENSIBLE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 13
LCID => shift 12
NUM => shift 2
STRING => shift 1
Syn => goto 63
Simp => goto 18

-----

State 40:

8 : Syn -> . LCID COLON Syn  / 3
9 : Syn -> . LCID EQ Syn  / 3
10 : Syn -> . Syn LARROW Syn  / 3
11 : Syn -> . Syn RARROW Syn  / 3
12 : Syn -> . Syn COMMA Syn  / 3
13 : Syn -> . Syn AT Syn  / 3
13 : Syn -> Syn AT . Syn  / 3
14 : Syn -> . Syn EQEQ Syn  / 3
15 : Syn -> . Syn NEQ Syn  / 3
16 : Syn -> . Syn GT Syn  / 3
17 : Syn -> . Syn LT Syn  / 3
18 : Syn -> . Syn GEQ Syn  / 3
19 : Syn -> . Syn LEQ Syn  / 3
20 : Syn -> . Syn PLUS Syn  / 3
21 : Syn -> . Simp  / 3
22 : Syn -> . LCID Sings  / 3
23 : Syn -> . NOT Simp  / 3
24 : Syn -> . LCURLY Bind RCURLY Syn  / 3
25 : Syn -> . EX UCID PERIOD Syn  / 3
26 : Simp -> . LPAREN Syn RPAREN  / 3
27 : Simp -> . UCID  / 3
28 : Simp -> . USCORE  / 3
29 : Simp -> . WORLD  / 3
30 : Simp -> . TYPE  / 3
31 : Simp -> . EXTENSIBLE  / 3
32 : Simp -> . REL  / 3
33 : Simp -> . NUM  / 3
34 : Simp -> . STRING  / 3

LCURLY => shift 10
LPAREN => shift 9
EX => shift 11
NOT => shift 8
WORLD => shift 7
TYPE => shift 6
EXTENSIBLE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 13
LCID => shift 12
NUM => shift 2
STRING => shift 1
Syn => goto 64
Simp => goto 18

-----

State 41:

8 : Syn -> . LCID COLON Syn  / 3
9 : Syn -> . LCID EQ Syn  / 3
10 : Syn -> . Syn LARROW Syn  / 3
11 : Syn -> . Syn RARROW Syn  / 3
12 : Syn -> . Syn COMMA Syn  / 3
12 : Syn -> Syn COMMA . Syn  / 3
13 : Syn -> . Syn AT Syn  / 3
14 : Syn -> . Syn EQEQ Syn  / 3
15 : Syn -> . Syn NEQ Syn  / 3
16 : Syn -> . Syn GT Syn  / 3
17 : Syn -> . Syn LT Syn  / 3
18 : Syn -> . Syn GEQ Syn  / 3
19 : Syn -> . Syn LEQ Syn  / 3
20 : Syn -> . Syn PLUS Syn  / 3
21 : Syn -> . Simp  / 3
22 : Syn -> . LCID Sings  / 3
23 : Syn -> . NOT Simp  / 3
24 : Syn -> . LCURLY Bind RCURLY Syn  / 3
25 : Syn -> . EX UCID PERIOD Syn  / 3
26 : Simp -> . LPAREN Syn RPAREN  / 3
27 : Simp -> . UCID  / 3
28 : Simp -> . USCORE  / 3
29 : Simp -> . WORLD  / 3
30 : Simp -> . TYPE  / 3
31 : Simp -> . EXTENSIBLE  / 3
32 : Simp -> . REL  / 3
33 : Simp -> . NUM  / 3
34 : Simp -> . STRING  / 3

LCURLY => shift 10
LPAREN => shift 9
EX => shift 11
NOT => shift 8
WORLD => shift 7
TYPE => shift 6
EXTENSIBLE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 13
LCID => shift 12
NUM => shift 2
STRING => shift 1
Syn => goto 65
Simp => goto 18

-----

State 42:

8 : Syn -> . LCID COLON Syn  / 3
9 : Syn -> . LCID EQ Syn  / 3
10 : Syn -> . Syn LARROW Syn  / 3
11 : Syn -> . Syn RARROW Syn  / 3
11 : Syn -> Syn RARROW . Syn  / 3
12 : Syn -> . Syn COMMA Syn  / 3
13 : Syn -> . Syn AT Syn  / 3
14 : Syn -> . Syn EQEQ Syn  / 3
15 : Syn -> . Syn NEQ Syn  / 3
16 : Syn -> . Syn GT Syn  / 3
17 : Syn -> . Syn LT Syn  / 3
18 : Syn -> . Syn GEQ Syn  / 3
19 : Syn -> . Syn LEQ Syn  / 3
20 : Syn -> . Syn PLUS Syn  / 3
21 : Syn -> . Simp  / 3
22 : Syn -> . LCID Sings  / 3
23 : Syn -> . NOT Simp  / 3
24 : Syn -> . LCURLY Bind RCURLY Syn  / 3
25 : Syn -> . EX UCID PERIOD Syn  / 3
26 : Simp -> . LPAREN Syn RPAREN  / 3
27 : Simp -> . UCID  / 3
28 : Simp -> . USCORE  / 3
29 : Simp -> . WORLD  / 3
30 : Simp -> . TYPE  / 3
31 : Simp -> . EXTENSIBLE  / 3
32 : Simp -> . REL  / 3
33 : Simp -> . NUM  / 3
34 : Simp -> . STRING  / 3

LCURLY => shift 10
LPAREN => shift 9
EX => shift 11
NOT => shift 8
WORLD => shift 7
TYPE => shift 6
EXTENSIBLE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 13
LCID => shift 12
NUM => shift 2
STRING => shift 1
Syn => goto 66
Simp => goto 18

-----

State 43:

8 : Syn -> . LCID COLON Syn  / 3
9 : Syn -> . LCID EQ Syn  / 3
10 : Syn -> . Syn LARROW Syn  / 3
10 : Syn -> Syn LARROW . Syn  / 3
11 : Syn -> . Syn RARROW Syn  / 3
12 : Syn -> . Syn COMMA Syn  / 3
13 : Syn -> . Syn AT Syn  / 3
14 : Syn -> . Syn EQEQ Syn  / 3
15 : Syn -> . Syn NEQ Syn  / 3
16 : Syn -> . Syn GT Syn  / 3
17 : Syn -> . Syn LT Syn  / 3
18 : Syn -> . Syn GEQ Syn  / 3
19 : Syn -> . Syn LEQ Syn  / 3
20 : Syn -> . Syn PLUS Syn  / 3
21 : Syn -> . Simp  / 3
22 : Syn -> . LCID Sings  / 3
23 : Syn -> . NOT Simp  / 3
24 : Syn -> . LCURLY Bind RCURLY Syn  / 3
25 : Syn -> . EX UCID PERIOD Syn  / 3
26 : Simp -> . LPAREN Syn RPAREN  / 3
27 : Simp -> . UCID  / 3
28 : Simp -> . USCORE  / 3
29 : Simp -> . WORLD  / 3
30 : Simp -> . TYPE  / 3
31 : Simp -> . EXTENSIBLE  / 3
32 : Simp -> . REL  / 3
33 : Simp -> . NUM  / 3
34 : Simp -> . STRING  / 3

LCURLY => shift 10
LPAREN => shift 9
EX => shift 11
NOT => shift 8
WORLD => shift 7
TYPE => shift 6
EXTENSIBLE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 13
LCID => shift 12
NUM => shift 2
STRING => shift 1
Syn => goto 67
Simp => goto 18

-----

State 44:

0 : Decl -> .  / 0
1 : Decl -> . Syn PERIOD Decl  / 0
1 : Decl -> Syn PERIOD . Decl  / 0
2 : Decl -> . LANNO ANNO_QUERY LCID LCID Modes RANNO Decl  / 0
3 : Decl -> . LANNO ANNO_TYPE LCID LCID RANNO Decl  / 0
4 : Decl -> . PRAGMA_QUERY LCID COLON LCID Modes PERIOD Decl  / 0
5 : Decl -> . PRAGMA_TYPE LCID LCID PERIOD Decl  / 0
8 : Syn -> . LCID COLON Syn  / 1
9 : Syn -> . LCID EQ Syn  / 1
10 : Syn -> . Syn LARROW Syn  / 1
11 : Syn -> . Syn RARROW Syn  / 1
12 : Syn -> . Syn COMMA Syn  / 1
13 : Syn -> . Syn AT Syn  / 1
14 : Syn -> . Syn EQEQ Syn  / 1
15 : Syn -> . Syn NEQ Syn  / 1
16 : Syn -> . Syn GT Syn  / 1
17 : Syn -> . Syn LT Syn  / 1
18 : Syn -> . Syn GEQ Syn  / 1
19 : Syn -> . Syn LEQ Syn  / 1
20 : Syn -> . Syn PLUS Syn  / 1
21 : Syn -> . Simp  / 1
22 : Syn -> . LCID Sings  / 1
23 : Syn -> . NOT Simp  / 1
24 : Syn -> . LCURLY Bind RCURLY Syn  / 1
25 : Syn -> . EX UCID PERIOD Syn  / 1
26 : Simp -> . LPAREN Syn RPAREN  / 1
27 : Simp -> . UCID  / 1
28 : Simp -> . USCORE  / 1
29 : Simp -> . WORLD  / 1
30 : Simp -> . TYPE  / 1
31 : Simp -> . EXTENSIBLE  / 1
32 : Simp -> . REL  / 1
33 : Simp -> . NUM  / 1
34 : Simp -> . STRING  / 1

$ => reduce 0
LCURLY => shift 10
LPAREN => shift 9
EX => shift 11
NOT => shift 8
WORLD => shift 7
TYPE => shift 6
EXTENSIBLE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 13
LCID => shift 12
NUM => shift 2
STRING => shift 1
LANNO => shift 14
PRAGMA_QUERY => shift 15
PRAGMA_TYPE => shift 19
Decl => goto 68
Syn => goto 16
Simp => goto 18

-----

State 45:

5 : Decl -> PRAGMA_TYPE LCID . LCID PERIOD Decl  / 0

LCID => shift 69

-----

State 46:

26 : Simp -> LPAREN Syn RPAREN .  / 2

RCURLY => reduce 26
LPAREN => reduce 26
RPAREN => reduce 26
PERIOD => reduce 26
LARROW => reduce 26
RARROW => reduce 26
COMMA => reduce 26
AT => reduce 26
EQEQ => reduce 26
NEQ => reduce 26
GT => reduce 26
LT => reduce 26
GEQ => reduce 26
LEQ => reduce 26
PLUS => reduce 26
WORLD => reduce 26
TYPE => reduce 26
EXTENSIBLE => reduce 26
REL => reduce 26
USCORE => reduce 26
UCID => reduce 26
LCID => reduce 26
NUM => reduce 26
STRING => reduce 26

-----

State 47:

8 : Syn -> . LCID COLON Syn  / 3
9 : Syn -> . LCID EQ Syn  / 3
10 : Syn -> . Syn LARROW Syn  / 3
11 : Syn -> . Syn RARROW Syn  / 3
12 : Syn -> . Syn COMMA Syn  / 3
13 : Syn -> . Syn AT Syn  / 3
14 : Syn -> . Syn EQEQ Syn  / 3
15 : Syn -> . Syn NEQ Syn  / 3
16 : Syn -> . Syn GT Syn  / 3
17 : Syn -> . Syn LT Syn  / 3
18 : Syn -> . Syn GEQ Syn  / 3
19 : Syn -> . Syn LEQ Syn  / 3
20 : Syn -> . Syn PLUS Syn  / 3
21 : Syn -> . Simp  / 3
22 : Syn -> . LCID Sings  / 3
23 : Syn -> . NOT Simp  / 3
24 : Syn -> . LCURLY Bind RCURLY Syn  / 3
24 : Syn -> LCURLY Bind RCURLY . Syn  / 3
25 : Syn -> . EX UCID PERIOD Syn  / 3
26 : Simp -> . LPAREN Syn RPAREN  / 3
27 : Simp -> . UCID  / 3
28 : Simp -> . USCORE  / 3
29 : Simp -> . WORLD  / 3
30 : Simp -> . TYPE  / 3
31 : Simp -> . EXTENSIBLE  / 3
32 : Simp -> . REL  / 3
33 : Simp -> . NUM  / 3
34 : Simp -> . STRING  / 3

LCURLY => shift 10
LPAREN => shift 9
EX => shift 11
NOT => shift 8
WORLD => shift 7
TYPE => shift 6
EXTENSIBLE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 13
LCID => shift 12
NUM => shift 2
STRING => shift 1
Syn => goto 70
Simp => goto 18

-----

State 48:

7 : Bind -> UCID COLON . Syn  / 5
8 : Syn -> . LCID COLON Syn  / 6
9 : Syn -> . LCID EQ Syn  / 6
10 : Syn -> . Syn LARROW Syn  / 6
11 : Syn -> . Syn RARROW Syn  / 6
12 : Syn -> . Syn COMMA Syn  / 6
13 : Syn -> . Syn AT Syn  / 6
14 : Syn -> . Syn EQEQ Syn  / 6
15 : Syn -> . Syn NEQ Syn  / 6
16 : Syn -> . Syn GT Syn  / 6
17 : Syn -> . Syn LT Syn  / 6
18 : Syn -> . Syn GEQ Syn  / 6
19 : Syn -> . Syn LEQ Syn  / 6
20 : Syn -> . Syn PLUS Syn  / 6
21 : Syn -> . Simp  / 6
22 : Syn -> . LCID Sings  / 6
23 : Syn -> . NOT Simp  / 6
24 : Syn -> . LCURLY Bind RCURLY Syn  / 6
25 : Syn -> . EX UCID PERIOD Syn  / 6
26 : Simp -> . LPAREN Syn RPAREN  / 6
27 : Simp -> . UCID  / 6
28 : Simp -> . USCORE  / 6
29 : Simp -> . WORLD  / 6
30 : Simp -> . TYPE  / 6
31 : Simp -> . EXTENSIBLE  / 6
32 : Simp -> . REL  / 6
33 : Simp -> . NUM  / 6
34 : Simp -> . STRING  / 6

LCURLY => shift 10
LPAREN => shift 9
EX => shift 11
NOT => shift 8
WORLD => shift 7
TYPE => shift 6
EXTENSIBLE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 13
LCID => shift 12
NUM => shift 2
STRING => shift 1
Syn => goto 71
Simp => goto 18

-----

State 49:

8 : Syn -> . LCID COLON Syn  / 3
9 : Syn -> . LCID EQ Syn  / 3
10 : Syn -> . Syn LARROW Syn  / 3
11 : Syn -> . Syn RARROW Syn  / 3
12 : Syn -> . Syn COMMA Syn  / 3
13 : Syn -> . Syn AT Syn  / 3
14 : Syn -> . Syn EQEQ Syn  / 3
15 : Syn -> . Syn NEQ Syn  / 3
16 : Syn -> . Syn GT Syn  / 3
17 : Syn -> . Syn LT Syn  / 3
18 : Syn -> . Syn GEQ Syn  / 3
19 : Syn -> . Syn LEQ Syn  / 3
20 : Syn -> . Syn PLUS Syn  / 3
21 : Syn -> . Simp  / 3
22 : Syn -> . LCID Sings  / 3
23 : Syn -> . NOT Simp  / 3
24 : Syn -> . LCURLY Bind RCURLY Syn  / 3
25 : Syn -> . EX UCID PERIOD Syn  / 3
25 : Syn -> EX UCID PERIOD . Syn  / 3
26 : Simp -> . LPAREN Syn RPAREN  / 3
27 : Simp -> . UCID  / 3
28 : Simp -> . USCORE  / 3
29 : Simp -> . WORLD  / 3
30 : Simp -> . TYPE  / 3
31 : Simp -> . EXTENSIBLE  / 3
32 : Simp -> . REL  / 3
33 : Simp -> . NUM  / 3
34 : Simp -> . STRING  / 3

LCURLY => shift 10
LPAREN => shift 9
EX => shift 11
NOT => shift 8
WORLD => shift 7
TYPE => shift 6
EXTENSIBLE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 13
LCID => shift 12
NUM => shift 2
STRING => shift 1
Syn => goto 72
Simp => goto 18

-----

State 50:

37 : Sings -> LCID Sings .  / 3

RCURLY => reduce 37
RPAREN => reduce 37
PERIOD => reduce 37
LARROW => reduce 37
RARROW => reduce 37
COMMA => reduce 37
AT => reduce 37
EQEQ => reduce 37
NEQ => reduce 37
GT => reduce 37
LT => reduce 37
GEQ => reduce 37
LEQ => reduce 37
PLUS => reduce 37

-----

State 51:

9 : Syn -> LCID EQ Syn .  / 3
10 : Syn -> Syn . LARROW Syn  / 3
11 : Syn -> Syn . RARROW Syn  / 3
12 : Syn -> Syn . COMMA Syn  / 3
13 : Syn -> Syn . AT Syn  / 3
14 : Syn -> Syn . EQEQ Syn  / 3
15 : Syn -> Syn . NEQ Syn  / 3
16 : Syn -> Syn . GT Syn  / 3
17 : Syn -> Syn . LT Syn  / 3
18 : Syn -> Syn . GEQ Syn  / 3
19 : Syn -> Syn . LEQ Syn  / 3
20 : Syn -> Syn . PLUS Syn  / 3

RCURLY => reduce 9
RPAREN => reduce 9
PERIOD => reduce 9
LARROW => shift 43, reduce 9  PRECEDENCE
RARROW => shift 42, reduce 9  PRECEDENCE
COMMA => shift 41, reduce 9  PRECEDENCE
AT => shift 40, reduce 9  PRECEDENCE
EQEQ => shift 39, reduce 9  PRECEDENCE
NEQ => shift 38, reduce 9  PRECEDENCE
GT => shift 37, reduce 9  PRECEDENCE
LT => shift 36, reduce 9  PRECEDENCE
GEQ => shift 35, reduce 9  PRECEDENCE
LEQ => shift 34, reduce 9  PRECEDENCE
PLUS => shift 33, reduce 9  PRECEDENCE

-----

State 52:

8 : Syn -> LCID COLON Syn .  / 3
10 : Syn -> Syn . LARROW Syn  / 3
11 : Syn -> Syn . RARROW Syn  / 3
12 : Syn -> Syn . COMMA Syn  / 3
13 : Syn -> Syn . AT Syn  / 3
14 : Syn -> Syn . EQEQ Syn  / 3
15 : Syn -> Syn . NEQ Syn  / 3
16 : Syn -> Syn . GT Syn  / 3
17 : Syn -> Syn . LT Syn  / 3
18 : Syn -> Syn . GEQ Syn  / 3
19 : Syn -> Syn . LEQ Syn  / 3
20 : Syn -> Syn . PLUS Syn  / 3

RCURLY => reduce 8
RPAREN => reduce 8
PERIOD => reduce 8
LARROW => shift 43, reduce 8  PRECEDENCE
RARROW => shift 42, reduce 8  PRECEDENCE
COMMA => shift 41, reduce 8  PRECEDENCE
AT => shift 40, reduce 8  PRECEDENCE
EQEQ => shift 39, reduce 8  PRECEDENCE
NEQ => shift 38, reduce 8  PRECEDENCE
GT => shift 37, reduce 8  PRECEDENCE
LT => shift 36, reduce 8  PRECEDENCE
GEQ => shift 35, reduce 8  PRECEDENCE
LEQ => shift 34, reduce 8  PRECEDENCE
PLUS => shift 33, reduce 8  PRECEDENCE

-----

State 53:

36 : Sings -> Simp Sings .  / 3

RCURLY => reduce 36
RPAREN => reduce 36
PERIOD => reduce 36
LARROW => reduce 36
RARROW => reduce 36
COMMA => reduce 36
AT => reduce 36
EQEQ => reduce 36
NEQ => reduce 36
GT => reduce 36
LT => reduce 36
GEQ => reduce 36
LEQ => reduce 36
PLUS => reduce 36

-----

State 54:

3 : Decl -> LANNO ANNO_TYPE LCID . LCID RANNO Decl  / 0

LCID => shift 73

-----

State 55:

2 : Decl -> LANNO ANNO_QUERY LCID . LCID Modes RANNO Decl  / 0

LCID => shift 74

-----

State 56:

4 : Decl -> PRAGMA_QUERY LCID COLON . LCID Modes PERIOD Decl  / 0

LCID => shift 75

-----

State 57:

10 : Syn -> Syn . LARROW Syn  / 3
11 : Syn -> Syn . RARROW Syn  / 3
12 : Syn -> Syn . COMMA Syn  / 3
13 : Syn -> Syn . AT Syn  / 3
14 : Syn -> Syn . EQEQ Syn  / 3
15 : Syn -> Syn . NEQ Syn  / 3
16 : Syn -> Syn . GT Syn  / 3
17 : Syn -> Syn . LT Syn  / 3
18 : Syn -> Syn . GEQ Syn  / 3
19 : Syn -> Syn . LEQ Syn  / 3
20 : Syn -> Syn . PLUS Syn  / 3
20 : Syn -> Syn PLUS Syn .  / 3

RCURLY => reduce 20
RPAREN => reduce 20
PERIOD => reduce 20
LARROW => reduce 20, shift 43  PRECEDENCE
RARROW => reduce 20, shift 42  PRECEDENCE
COMMA => reduce 20, shift 41  PRECEDENCE
AT => reduce 20, shift 40  PRECEDENCE
EQEQ => reduce 20, shift 39  PRECEDENCE
NEQ => reduce 20, shift 38  PRECEDENCE
GT => reduce 20, shift 37  PRECEDENCE
LT => reduce 20, shift 36  PRECEDENCE
GEQ => reduce 20, shift 35  PRECEDENCE
LEQ => reduce 20, shift 34  PRECEDENCE
PLUS => reduce 20, shift 33  PRECEDENCE

-----

State 58:

10 : Syn -> Syn . LARROW Syn  / 3
11 : Syn -> Syn . RARROW Syn  / 3
12 : Syn -> Syn . COMMA Syn  / 3
13 : Syn -> Syn . AT Syn  / 3
14 : Syn -> Syn . EQEQ Syn  / 3
15 : Syn -> Syn . NEQ Syn  / 3
16 : Syn -> Syn . GT Syn  / 3
17 : Syn -> Syn . LT Syn  / 3
18 : Syn -> Syn . GEQ Syn  / 3
19 : Syn -> Syn . LEQ Syn  / 3
19 : Syn -> Syn LEQ Syn .  / 3
20 : Syn -> Syn . PLUS Syn  / 3

RCURLY => reduce 19
RPAREN => reduce 19
PERIOD => reduce 19
LARROW => reduce 19, shift 43  PRECEDENCE
RARROW => reduce 19, shift 42  PRECEDENCE
COMMA => reduce 19, shift 41  PRECEDENCE
AT => reduce 19, shift 40  PRECEDENCE
EQEQ => reduce 19, shift 39  PRECEDENCE
NEQ => reduce 19, shift 38  PRECEDENCE
GT => reduce 19, shift 37  PRECEDENCE
LT => reduce 19, shift 36  PRECEDENCE
GEQ => reduce 19, shift 35  PRECEDENCE
LEQ => reduce 19, shift 34  PRECEDENCE
PLUS => shift 33, reduce 19  PRECEDENCE

-----

State 59:

10 : Syn -> Syn . LARROW Syn  / 3
11 : Syn -> Syn . RARROW Syn  / 3
12 : Syn -> Syn . COMMA Syn  / 3
13 : Syn -> Syn . AT Syn  / 3
14 : Syn -> Syn . EQEQ Syn  / 3
15 : Syn -> Syn . NEQ Syn  / 3
16 : Syn -> Syn . GT Syn  / 3
17 : Syn -> Syn . LT Syn  / 3
18 : Syn -> Syn . GEQ Syn  / 3
18 : Syn -> Syn GEQ Syn .  / 3
19 : Syn -> Syn . LEQ Syn  / 3
20 : Syn -> Syn . PLUS Syn  / 3

RCURLY => reduce 18
RPAREN => reduce 18
PERIOD => reduce 18
LARROW => reduce 18, shift 43  PRECEDENCE
RARROW => reduce 18, shift 42  PRECEDENCE
COMMA => reduce 18, shift 41  PRECEDENCE
AT => reduce 18, shift 40  PRECEDENCE
EQEQ => reduce 18, shift 39  PRECEDENCE
NEQ => reduce 18, shift 38  PRECEDENCE
GT => reduce 18, shift 37  PRECEDENCE
LT => reduce 18, shift 36  PRECEDENCE
GEQ => reduce 18, shift 35  PRECEDENCE
LEQ => reduce 18, shift 34  PRECEDENCE
PLUS => shift 33, reduce 18  PRECEDENCE

-----

State 60:

10 : Syn -> Syn . LARROW Syn  / 3
11 : Syn -> Syn . RARROW Syn  / 3
12 : Syn -> Syn . COMMA Syn  / 3
13 : Syn -> Syn . AT Syn  / 3
14 : Syn -> Syn . EQEQ Syn  / 3
15 : Syn -> Syn . NEQ Syn  / 3
16 : Syn -> Syn . GT Syn  / 3
17 : Syn -> Syn . LT Syn  / 3
17 : Syn -> Syn LT Syn .  / 3
18 : Syn -> Syn . GEQ Syn  / 3
19 : Syn -> Syn . LEQ Syn  / 3
20 : Syn -> Syn . PLUS Syn  / 3

RCURLY => reduce 17
RPAREN => reduce 17
PERIOD => reduce 17
LARROW => reduce 17, shift 43  PRECEDENCE
RARROW => reduce 17, shift 42  PRECEDENCE
COMMA => reduce 17, shift 41  PRECEDENCE
AT => reduce 17, shift 40  PRECEDENCE
EQEQ => reduce 17, shift 39  PRECEDENCE
NEQ => reduce 17, shift 38  PRECEDENCE
GT => reduce 17, shift 37  PRECEDENCE
LT => reduce 17, shift 36  PRECEDENCE
GEQ => reduce 17, shift 35  PRECEDENCE
LEQ => reduce 17, shift 34  PRECEDENCE
PLUS => shift 33, reduce 17  PRECEDENCE

-----

State 61:

10 : Syn -> Syn . LARROW Syn  / 3
11 : Syn -> Syn . RARROW Syn  / 3
12 : Syn -> Syn . COMMA Syn  / 3
13 : Syn -> Syn . AT Syn  / 3
14 : Syn -> Syn . EQEQ Syn  / 3
15 : Syn -> Syn . NEQ Syn  / 3
16 : Syn -> Syn . GT Syn  / 3
16 : Syn -> Syn GT Syn .  / 3
17 : Syn -> Syn . LT Syn  / 3
18 : Syn -> Syn . GEQ Syn  / 3
19 : Syn -> Syn . LEQ Syn  / 3
20 : Syn -> Syn . PLUS Syn  / 3

RCURLY => reduce 16
RPAREN => reduce 16
PERIOD => reduce 16
LARROW => reduce 16, shift 43  PRECEDENCE
RARROW => reduce 16, shift 42  PRECEDENCE
COMMA => reduce 16, shift 41  PRECEDENCE
AT => reduce 16, shift 40  PRECEDENCE
EQEQ => reduce 16, shift 39  PRECEDENCE
NEQ => reduce 16, shift 38  PRECEDENCE
GT => reduce 16, shift 37  PRECEDENCE
LT => reduce 16, shift 36  PRECEDENCE
GEQ => reduce 16, shift 35  PRECEDENCE
LEQ => reduce 16, shift 34  PRECEDENCE
PLUS => shift 33, reduce 16  PRECEDENCE

-----

State 62:

10 : Syn -> Syn . LARROW Syn  / 3
11 : Syn -> Syn . RARROW Syn  / 3
12 : Syn -> Syn . COMMA Syn  / 3
13 : Syn -> Syn . AT Syn  / 3
14 : Syn -> Syn . EQEQ Syn  / 3
15 : Syn -> Syn . NEQ Syn  / 3
15 : Syn -> Syn NEQ Syn .  / 3
16 : Syn -> Syn . GT Syn  / 3
17 : Syn -> Syn . LT Syn  / 3
18 : Syn -> Syn . GEQ Syn  / 3
19 : Syn -> Syn . LEQ Syn  / 3
20 : Syn -> Syn . PLUS Syn  / 3

RCURLY => reduce 15
RPAREN => reduce 15
PERIOD => reduce 15
LARROW => reduce 15, shift 43  PRECEDENCE
RARROW => reduce 15, shift 42  PRECEDENCE
COMMA => reduce 15, shift 41  PRECEDENCE
AT => reduce 15, shift 40  PRECEDENCE
EQEQ => reduce 15, shift 39  PRECEDENCE
NEQ => reduce 15, shift 38  PRECEDENCE
GT => reduce 15, shift 37  PRECEDENCE
LT => reduce 15, shift 36  PRECEDENCE
GEQ => reduce 15, shift 35  PRECEDENCE
LEQ => reduce 15, shift 34  PRECEDENCE
PLUS => shift 33, reduce 15  PRECEDENCE

-----

State 63:

10 : Syn -> Syn . LARROW Syn  / 3
11 : Syn -> Syn . RARROW Syn  / 3
12 : Syn -> Syn . COMMA Syn  / 3
13 : Syn -> Syn . AT Syn  / 3
14 : Syn -> Syn . EQEQ Syn  / 3
14 : Syn -> Syn EQEQ Syn .  / 3
15 : Syn -> Syn . NEQ Syn  / 3
16 : Syn -> Syn . GT Syn  / 3
17 : Syn -> Syn . LT Syn  / 3
18 : Syn -> Syn . GEQ Syn  / 3
19 : Syn -> Syn . LEQ Syn  / 3
20 : Syn -> Syn . PLUS Syn  / 3

RCURLY => reduce 14
RPAREN => reduce 14
PERIOD => reduce 14
LARROW => reduce 14, shift 43  PRECEDENCE
RARROW => reduce 14, shift 42  PRECEDENCE
COMMA => reduce 14, shift 41  PRECEDENCE
AT => reduce 14, shift 40  PRECEDENCE
EQEQ => reduce 14, shift 39  PRECEDENCE
NEQ => reduce 14, shift 38  PRECEDENCE
GT => reduce 14, shift 37  PRECEDENCE
LT => reduce 14, shift 36  PRECEDENCE
GEQ => reduce 14, shift 35  PRECEDENCE
LEQ => reduce 14, shift 34  PRECEDENCE
PLUS => shift 33, reduce 14  PRECEDENCE

-----

State 64:

10 : Syn -> Syn . LARROW Syn  / 3
11 : Syn -> Syn . RARROW Syn  / 3
12 : Syn -> Syn . COMMA Syn  / 3
13 : Syn -> Syn . AT Syn  / 3
13 : Syn -> Syn AT Syn .  / 3
14 : Syn -> Syn . EQEQ Syn  / 3
15 : Syn -> Syn . NEQ Syn  / 3
16 : Syn -> Syn . GT Syn  / 3
17 : Syn -> Syn . LT Syn  / 3
18 : Syn -> Syn . GEQ Syn  / 3
19 : Syn -> Syn . LEQ Syn  / 3
20 : Syn -> Syn . PLUS Syn  / 3

RCURLY => reduce 13
RPAREN => reduce 13
PERIOD => reduce 13
LARROW => reduce 13, shift 43  PRECEDENCE
RARROW => reduce 13, shift 42  PRECEDENCE
COMMA => reduce 13, shift 41  PRECEDENCE
AT => reduce 13, shift 40  PRECEDENCE
EQEQ => shift 39, reduce 13  PRECEDENCE
NEQ => shift 38, reduce 13  PRECEDENCE
GT => shift 37, reduce 13  PRECEDENCE
LT => shift 36, reduce 13  PRECEDENCE
GEQ => shift 35, reduce 13  PRECEDENCE
LEQ => shift 34, reduce 13  PRECEDENCE
PLUS => shift 33, reduce 13  PRECEDENCE

-----

State 65:

10 : Syn -> Syn . LARROW Syn  / 3
11 : Syn -> Syn . RARROW Syn  / 3
12 : Syn -> Syn . COMMA Syn  / 3
12 : Syn -> Syn COMMA Syn .  / 3
13 : Syn -> Syn . AT Syn  / 3
14 : Syn -> Syn . EQEQ Syn  / 3
15 : Syn -> Syn . NEQ Syn  / 3
16 : Syn -> Syn . GT Syn  / 3
17 : Syn -> Syn . LT Syn  / 3
18 : Syn -> Syn . GEQ Syn  / 3
19 : Syn -> Syn . LEQ Syn  / 3
20 : Syn -> Syn . PLUS Syn  / 3

RCURLY => reduce 12
RPAREN => reduce 12
PERIOD => reduce 12
LARROW => reduce 12, shift 43  PRECEDENCE
RARROW => reduce 12, shift 42  PRECEDENCE
COMMA => reduce 12, shift 41  PRECEDENCE
AT => shift 40, reduce 12  PRECEDENCE
EQEQ => shift 39, reduce 12  PRECEDENCE
NEQ => shift 38, reduce 12  PRECEDENCE
GT => shift 37, reduce 12  PRECEDENCE
LT => shift 36, reduce 12  PRECEDENCE
GEQ => shift 35, reduce 12  PRECEDENCE
LEQ => shift 34, reduce 12  PRECEDENCE
PLUS => shift 33, reduce 12  PRECEDENCE

-----

State 66:

10 : Syn -> Syn . LARROW Syn  / 3
11 : Syn -> Syn . RARROW Syn  / 3
11 : Syn -> Syn RARROW Syn .  / 3
12 : Syn -> Syn . COMMA Syn  / 3
13 : Syn -> Syn . AT Syn  / 3
14 : Syn -> Syn . EQEQ Syn  / 3
15 : Syn -> Syn . NEQ Syn  / 3
16 : Syn -> Syn . GT Syn  / 3
17 : Syn -> Syn . LT Syn  / 3
18 : Syn -> Syn . GEQ Syn  / 3
19 : Syn -> Syn . LEQ Syn  / 3
20 : Syn -> Syn . PLUS Syn  / 3

RCURLY => reduce 11
RPAREN => reduce 11
PERIOD => reduce 11
LARROW => reduce 11, shift 43  PRECEDENCE
RARROW => shift 42, reduce 11  PRECEDENCE
COMMA => shift 41, reduce 11  PRECEDENCE
AT => shift 40, reduce 11  PRECEDENCE
EQEQ => shift 39, reduce 11  PRECEDENCE
NEQ => shift 38, reduce 11  PRECEDENCE
GT => shift 37, reduce 11  PRECEDENCE
LT => shift 36, reduce 11  PRECEDENCE
GEQ => shift 35, reduce 11  PRECEDENCE
LEQ => shift 34, reduce 11  PRECEDENCE
PLUS => shift 33, reduce 11  PRECEDENCE

-----

State 67:

10 : Syn -> Syn . LARROW Syn  / 3
10 : Syn -> Syn LARROW Syn .  / 3
11 : Syn -> Syn . RARROW Syn  / 3
12 : Syn -> Syn . COMMA Syn  / 3
13 : Syn -> Syn . AT Syn  / 3
14 : Syn -> Syn . EQEQ Syn  / 3
15 : Syn -> Syn . NEQ Syn  / 3
16 : Syn -> Syn . GT Syn  / 3
17 : Syn -> Syn . LT Syn  / 3
18 : Syn -> Syn . GEQ Syn  / 3
19 : Syn -> Syn . LEQ Syn  / 3
20 : Syn -> Syn . PLUS Syn  / 3

RCURLY => reduce 10
RPAREN => reduce 10
PERIOD => reduce 10
LARROW => reduce 10, shift 43  PRECEDENCE
RARROW => shift 42, reduce 10  PRECEDENCE
COMMA => shift 41, reduce 10  PRECEDENCE
AT => shift 40, reduce 10  PRECEDENCE
EQEQ => shift 39, reduce 10  PRECEDENCE
NEQ => shift 38, reduce 10  PRECEDENCE
GT => shift 37, reduce 10  PRECEDENCE
LT => shift 36, reduce 10  PRECEDENCE
GEQ => shift 35, reduce 10  PRECEDENCE
LEQ => shift 34, reduce 10  PRECEDENCE
PLUS => shift 33, reduce 10  PRECEDENCE

-----

State 68:

1 : Decl -> Syn PERIOD Decl .  / 0

$ => reduce 1

-----

State 69:

5 : Decl -> PRAGMA_TYPE LCID LCID . PERIOD Decl  / 0

PERIOD => shift 76

-----

State 70:

10 : Syn -> Syn . LARROW Syn  / 3
11 : Syn -> Syn . RARROW Syn  / 3
12 : Syn -> Syn . COMMA Syn  / 3
13 : Syn -> Syn . AT Syn  / 3
14 : Syn -> Syn . EQEQ Syn  / 3
15 : Syn -> Syn . NEQ Syn  / 3
16 : Syn -> Syn . GT Syn  / 3
17 : Syn -> Syn . LT Syn  / 3
18 : Syn -> Syn . GEQ Syn  / 3
19 : Syn -> Syn . LEQ Syn  / 3
20 : Syn -> Syn . PLUS Syn  / 3
24 : Syn -> LCURLY Bind RCURLY Syn .  / 3

RCURLY => reduce 24
RPAREN => reduce 24
PERIOD => reduce 24
LARROW => shift 43, reduce 24  PRECEDENCE
RARROW => shift 42, reduce 24  PRECEDENCE
COMMA => shift 41, reduce 24  PRECEDENCE
AT => shift 40, reduce 24  PRECEDENCE
EQEQ => shift 39, reduce 24  PRECEDENCE
NEQ => shift 38, reduce 24  PRECEDENCE
GT => shift 37, reduce 24  PRECEDENCE
LT => shift 36, reduce 24  PRECEDENCE
GEQ => shift 35, reduce 24  PRECEDENCE
LEQ => shift 34, reduce 24  PRECEDENCE
PLUS => shift 33, reduce 24  PRECEDENCE

-----

State 71:

7 : Bind -> UCID COLON Syn .  / 5
10 : Syn -> Syn . LARROW Syn  / 6
11 : Syn -> Syn . RARROW Syn  / 6
12 : Syn -> Syn . COMMA Syn  / 6
13 : Syn -> Syn . AT Syn  / 6
14 : Syn -> Syn . EQEQ Syn  / 6
15 : Syn -> Syn . NEQ Syn  / 6
16 : Syn -> Syn . GT Syn  / 6
17 : Syn -> Syn . LT Syn  / 6
18 : Syn -> Syn . GEQ Syn  / 6
19 : Syn -> Syn . LEQ Syn  / 6
20 : Syn -> Syn . PLUS Syn  / 6

RCURLY => reduce 7
LARROW => shift 43
RARROW => shift 42
COMMA => shift 41
AT => shift 40
EQEQ => shift 39
NEQ => shift 38
GT => shift 37
LT => shift 36
GEQ => shift 35
LEQ => shift 34
PLUS => shift 33

-----

State 72:

10 : Syn -> Syn . LARROW Syn  / 3
11 : Syn -> Syn . RARROW Syn  / 3
12 : Syn -> Syn . COMMA Syn  / 3
13 : Syn -> Syn . AT Syn  / 3
14 : Syn -> Syn . EQEQ Syn  / 3
15 : Syn -> Syn . NEQ Syn  / 3
16 : Syn -> Syn . GT Syn  / 3
17 : Syn -> Syn . LT Syn  / 3
18 : Syn -> Syn . GEQ Syn  / 3
19 : Syn -> Syn . LEQ Syn  / 3
20 : Syn -> Syn . PLUS Syn  / 3
25 : Syn -> EX UCID PERIOD Syn .  / 3

RCURLY => reduce 25
RPAREN => reduce 25
PERIOD => reduce 25
LARROW => shift 43, reduce 25  PRECEDENCE
RARROW => shift 42, reduce 25  PRECEDENCE
COMMA => shift 41, reduce 25  PRECEDENCE
AT => shift 40, reduce 25  PRECEDENCE
EQEQ => shift 39, reduce 25  PRECEDENCE
NEQ => shift 38, reduce 25  PRECEDENCE
GT => shift 37, reduce 25  PRECEDENCE
LT => shift 36, reduce 25  PRECEDENCE
GEQ => shift 35, reduce 25  PRECEDENCE
LEQ => shift 34, reduce 25  PRECEDENCE
PLUS => shift 33, reduce 25  PRECEDENCE

-----

State 73:

3 : Decl -> LANNO ANNO_TYPE LCID LCID . RANNO Decl  / 0

RANNO => shift 77

-----

State 74:

2 : Decl -> LANNO ANNO_QUERY LCID LCID . Modes RANNO Decl  / 0
38 : Modes -> .  / 7
39 : Modes -> . PLUS Modes  / 7
40 : Modes -> . MINUS Modes  / 7
41 : Modes -> . USCORE Modes  / 7

PLUS => shift 80
MINUS => shift 79
USCORE => shift 78
RANNO => reduce 38
Modes => goto 81

-----

State 75:

4 : Decl -> PRAGMA_QUERY LCID COLON LCID . Modes PERIOD Decl  / 0
38 : Modes -> .  / 8
39 : Modes -> . PLUS Modes  / 8
40 : Modes -> . MINUS Modes  / 8
41 : Modes -> . USCORE Modes  / 8

PERIOD => reduce 38
PLUS => shift 80
MINUS => shift 79
USCORE => shift 78
Modes => goto 82

-----

State 76:

0 : Decl -> .  / 0
1 : Decl -> . Syn PERIOD Decl  / 0
2 : Decl -> . LANNO ANNO_QUERY LCID LCID Modes RANNO Decl  / 0
3 : Decl -> . LANNO ANNO_TYPE LCID LCID RANNO Decl  / 0
4 : Decl -> . PRAGMA_QUERY LCID COLON LCID Modes PERIOD Decl  / 0
5 : Decl -> . PRAGMA_TYPE LCID LCID PERIOD Decl  / 0
5 : Decl -> PRAGMA_TYPE LCID LCID PERIOD . Decl  / 0
8 : Syn -> . LCID COLON Syn  / 1
9 : Syn -> . LCID EQ Syn  / 1
10 : Syn -> . Syn LARROW Syn  / 1
11 : Syn -> . Syn RARROW Syn  / 1
12 : Syn -> . Syn COMMA Syn  / 1
13 : Syn -> . Syn AT Syn  / 1
14 : Syn -> . Syn EQEQ Syn  / 1
15 : Syn -> . Syn NEQ Syn  / 1
16 : Syn -> . Syn GT Syn  / 1
17 : Syn -> . Syn LT Syn  / 1
18 : Syn -> . Syn GEQ Syn  / 1
19 : Syn -> . Syn LEQ Syn  / 1
20 : Syn -> . Syn PLUS Syn  / 1
21 : Syn -> . Simp  / 1
22 : Syn -> . LCID Sings  / 1
23 : Syn -> . NOT Simp  / 1
24 : Syn -> . LCURLY Bind RCURLY Syn  / 1
25 : Syn -> . EX UCID PERIOD Syn  / 1
26 : Simp -> . LPAREN Syn RPAREN  / 1
27 : Simp -> . UCID  / 1
28 : Simp -> . USCORE  / 1
29 : Simp -> . WORLD  / 1
30 : Simp -> . TYPE  / 1
31 : Simp -> . EXTENSIBLE  / 1
32 : Simp -> . REL  / 1
33 : Simp -> . NUM  / 1
34 : Simp -> . STRING  / 1

$ => reduce 0
LCURLY => shift 10
LPAREN => shift 9
EX => shift 11
NOT => shift 8
WORLD => shift 7
TYPE => shift 6
EXTENSIBLE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 13
LCID => shift 12
NUM => shift 2
STRING => shift 1
LANNO => shift 14
PRAGMA_QUERY => shift 15
PRAGMA_TYPE => shift 19
Decl => goto 83
Syn => goto 16
Simp => goto 18

-----

State 77:

0 : Decl -> .  / 0
1 : Decl -> . Syn PERIOD Decl  / 0
2 : Decl -> . LANNO ANNO_QUERY LCID LCID Modes RANNO Decl  / 0
3 : Decl -> . LANNO ANNO_TYPE LCID LCID RANNO Decl  / 0
3 : Decl -> LANNO ANNO_TYPE LCID LCID RANNO . Decl  / 0
4 : Decl -> . PRAGMA_QUERY LCID COLON LCID Modes PERIOD Decl  / 0
5 : Decl -> . PRAGMA_TYPE LCID LCID PERIOD Decl  / 0
8 : Syn -> . LCID COLON Syn  / 1
9 : Syn -> . LCID EQ Syn  / 1
10 : Syn -> . Syn LARROW Syn  / 1
11 : Syn -> . Syn RARROW Syn  / 1
12 : Syn -> . Syn COMMA Syn  / 1
13 : Syn -> . Syn AT Syn  / 1
14 : Syn -> . Syn EQEQ Syn  / 1
15 : Syn -> . Syn NEQ Syn  / 1
16 : Syn -> . Syn GT Syn  / 1
17 : Syn -> . Syn LT Syn  / 1
18 : Syn -> . Syn GEQ Syn  / 1
19 : Syn -> . Syn LEQ Syn  / 1
20 : Syn -> . Syn PLUS Syn  / 1
21 : Syn -> . Simp  / 1
22 : Syn -> . LCID Sings  / 1
23 : Syn -> . NOT Simp  / 1
24 : Syn -> . LCURLY Bind RCURLY Syn  / 1
25 : Syn -> . EX UCID PERIOD Syn  / 1
26 : Simp -> . LPAREN Syn RPAREN  / 1
27 : Simp -> . UCID  / 1
28 : Simp -> . USCORE  / 1
29 : Simp -> . WORLD  / 1
30 : Simp -> . TYPE  / 1
31 : Simp -> . EXTENSIBLE  / 1
32 : Simp -> . REL  / 1
33 : Simp -> . NUM  / 1
34 : Simp -> . STRING  / 1

$ => reduce 0
LCURLY => shift 10
LPAREN => shift 9
EX => shift 11
NOT => shift 8
WORLD => shift 7
TYPE => shift 6
EXTENSIBLE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 13
LCID => shift 12
NUM => shift 2
STRING => shift 1
LANNO => shift 14
PRAGMA_QUERY => shift 15
PRAGMA_TYPE => shift 19
Decl => goto 84
Syn => goto 16
Simp => goto 18

-----

State 78:

38 : Modes -> .  / 9
39 : Modes -> . PLUS Modes  / 9
40 : Modes -> . MINUS Modes  / 9
41 : Modes -> . USCORE Modes  / 9
41 : Modes -> USCORE . Modes  / 9

PERIOD => reduce 38
PLUS => shift 80
MINUS => shift 79
USCORE => shift 78
RANNO => reduce 38
Modes => goto 85

-----

State 79:

38 : Modes -> .  / 9
39 : Modes -> . PLUS Modes  / 9
40 : Modes -> . MINUS Modes  / 9
40 : Modes -> MINUS . Modes  / 9
41 : Modes -> . USCORE Modes  / 9

PERIOD => reduce 38
PLUS => shift 80
MINUS => shift 79
USCORE => shift 78
RANNO => reduce 38
Modes => goto 86

-----

State 80:

38 : Modes -> .  / 9
39 : Modes -> . PLUS Modes  / 9
39 : Modes -> PLUS . Modes  / 9
40 : Modes -> . MINUS Modes  / 9
41 : Modes -> . USCORE Modes  / 9

PERIOD => reduce 38
PLUS => shift 80
MINUS => shift 79
USCORE => shift 78
RANNO => reduce 38
Modes => goto 87

-----

State 81:

2 : Decl -> LANNO ANNO_QUERY LCID LCID Modes . RANNO Decl  / 0

RANNO => shift 88

-----

State 82:

4 : Decl -> PRAGMA_QUERY LCID COLON LCID Modes . PERIOD Decl  / 0

PERIOD => shift 89

-----

State 83:

5 : Decl -> PRAGMA_TYPE LCID LCID PERIOD Decl .  / 0

$ => reduce 5

-----

State 84:

3 : Decl -> LANNO ANNO_TYPE LCID LCID RANNO Decl .  / 0

$ => reduce 3

-----

State 85:

41 : Modes -> USCORE Modes .  / 9

PERIOD => reduce 41
RANNO => reduce 41

-----

State 86:

40 : Modes -> MINUS Modes .  / 9

PERIOD => reduce 40
RANNO => reduce 40

-----

State 87:

39 : Modes -> PLUS Modes .  / 9

PERIOD => reduce 39
RANNO => reduce 39

-----

State 88:

0 : Decl -> .  / 0
1 : Decl -> . Syn PERIOD Decl  / 0
2 : Decl -> . LANNO ANNO_QUERY LCID LCID Modes RANNO Decl  / 0
2 : Decl -> LANNO ANNO_QUERY LCID LCID Modes RANNO . Decl  / 0
3 : Decl -> . LANNO ANNO_TYPE LCID LCID RANNO Decl  / 0
4 : Decl -> . PRAGMA_QUERY LCID COLON LCID Modes PERIOD Decl  / 0
5 : Decl -> . PRAGMA_TYPE LCID LCID PERIOD Decl  / 0
8 : Syn -> . LCID COLON Syn  / 1
9 : Syn -> . LCID EQ Syn  / 1
10 : Syn -> . Syn LARROW Syn  / 1
11 : Syn -> . Syn RARROW Syn  / 1
12 : Syn -> . Syn COMMA Syn  / 1
13 : Syn -> . Syn AT Syn  / 1
14 : Syn -> . Syn EQEQ Syn  / 1
15 : Syn -> . Syn NEQ Syn  / 1
16 : Syn -> . Syn GT Syn  / 1
17 : Syn -> . Syn LT Syn  / 1
18 : Syn -> . Syn GEQ Syn  / 1
19 : Syn -> . Syn LEQ Syn  / 1
20 : Syn -> . Syn PLUS Syn  / 1
21 : Syn -> . Simp  / 1
22 : Syn -> . LCID Sings  / 1
23 : Syn -> . NOT Simp  / 1
24 : Syn -> . LCURLY Bind RCURLY Syn  / 1
25 : Syn -> . EX UCID PERIOD Syn  / 1
26 : Simp -> . LPAREN Syn RPAREN  / 1
27 : Simp -> . UCID  / 1
28 : Simp -> . USCORE  / 1
29 : Simp -> . WORLD  / 1
30 : Simp -> . TYPE  / 1
31 : Simp -> . EXTENSIBLE  / 1
32 : Simp -> . REL  / 1
33 : Simp -> . NUM  / 1
34 : Simp -> . STRING  / 1

$ => reduce 0
LCURLY => shift 10
LPAREN => shift 9
EX => shift 11
NOT => shift 8
WORLD => shift 7
TYPE => shift 6
EXTENSIBLE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 13
LCID => shift 12
NUM => shift 2
STRING => shift 1
LANNO => shift 14
PRAGMA_QUERY => shift 15
PRAGMA_TYPE => shift 19
Decl => goto 90
Syn => goto 16
Simp => goto 18

-----

State 89:

0 : Decl -> .  / 0
1 : Decl -> . Syn PERIOD Decl  / 0
2 : Decl -> . LANNO ANNO_QUERY LCID LCID Modes RANNO Decl  / 0
3 : Decl -> . LANNO ANNO_TYPE LCID LCID RANNO Decl  / 0
4 : Decl -> . PRAGMA_QUERY LCID COLON LCID Modes PERIOD Decl  / 0
4 : Decl -> PRAGMA_QUERY LCID COLON LCID Modes PERIOD . Decl  / 0
5 : Decl -> . PRAGMA_TYPE LCID LCID PERIOD Decl  / 0
8 : Syn -> . LCID COLON Syn  / 1
9 : Syn -> . LCID EQ Syn  / 1
10 : Syn -> . Syn LARROW Syn  / 1
11 : Syn -> . Syn RARROW Syn  / 1
12 : Syn -> . Syn COMMA Syn  / 1
13 : Syn -> . Syn AT Syn  / 1
14 : Syn -> . Syn EQEQ Syn  / 1
15 : Syn -> . Syn NEQ Syn  / 1
16 : Syn -> . Syn GT Syn  / 1
17 : Syn -> . Syn LT Syn  / 1
18 : Syn -> . Syn GEQ Syn  / 1
19 : Syn -> . Syn LEQ Syn  / 1
20 : Syn -> . Syn PLUS Syn  / 1
21 : Syn -> . Simp  / 1
22 : Syn -> . LCID Sings  / 1
23 : Syn -> . NOT Simp  / 1
24 : Syn -> . LCURLY Bind RCURLY Syn  / 1
25 : Syn -> . EX UCID PERIOD Syn  / 1
26 : Simp -> . LPAREN Syn RPAREN  / 1
27 : Simp -> . UCID  / 1
28 : Simp -> . USCORE  / 1
29 : Simp -> . WORLD  / 1
30 : Simp -> . TYPE  / 1
31 : Simp -> . EXTENSIBLE  / 1
32 : Simp -> . REL  / 1
33 : Simp -> . NUM  / 1
34 : Simp -> . STRING  / 1

$ => reduce 0
LCURLY => shift 10
LPAREN => shift 9
EX => shift 11
NOT => shift 8
WORLD => shift 7
TYPE => shift 6
EXTENSIBLE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 13
LCID => shift 12
NUM => shift 2
STRING => shift 1
LANNO => shift 14
PRAGMA_QUERY => shift 15
PRAGMA_TYPE => shift 19
Decl => goto 91
Syn => goto 16
Simp => goto 18

-----

State 90:

2 : Decl -> LANNO ANNO_QUERY LCID LCID Modes RANNO Decl .  / 0

$ => reduce 2

-----

State 91:

4 : Decl -> PRAGMA_QUERY LCID COLON LCID Modes PERIOD Decl .  / 0

$ => reduce 4

-----

lookahead 0 = $ 
lookahead 1 = PERIOD LARROW RARROW COMMA AT EQEQ NEQ GT LT GEQ LEQ PLUS 
lookahead 2 = RCURLY LPAREN RPAREN PERIOD LARROW RARROW COMMA AT EQEQ NEQ GT LT GEQ LEQ PLUS WORLD TYPE EXTENSIBLE REL USCORE UCID LCID NUM STRING 
lookahead 3 = RCURLY RPAREN PERIOD LARROW RARROW COMMA AT EQEQ NEQ GT LT GEQ LEQ PLUS 
lookahead 4 = RPAREN LARROW RARROW COMMA AT EQEQ NEQ GT LT GEQ LEQ PLUS 
lookahead 5 = RCURLY 
lookahead 6 = RCURLY LARROW RARROW COMMA AT EQEQ NEQ GT LT GEQ LEQ PLUS 
lookahead 7 = RANNO 
lookahead 8 = PERIOD 
lookahead 9 = PERIOD RANNO 

*)

struct
local
structure Value = struct
datatype nonterminal =
nonterminal
| pos of Arg.pos
| pos_str of Arg.pos_str
| pos_int of Arg.pos_int
| decl of Arg.decl
| syn of Arg.syn
| sings of Arg.sings
| modes of Arg.modes
end
structure ParseEngine = ParseEngineFun (structure Streamable = Streamable
type terminal = Arg.terminal
type value = Value.nonterminal
val dummy = Value.nonterminal
fun read terminal =
(case terminal of
Arg.LCURLY x => (1, Value.pos x)
| Arg.RCURLY x => (2, Value.pos x)
| Arg.LPAREN x => (3, Value.pos x)
| Arg.RPAREN x => (4, Value.pos x)
| Arg.EX x => (5, Value.pos x)
| Arg.PERIOD x => (6, Value.pos x)
| Arg.COLON x => (7, Value.pos x)
| Arg.EQ x => (8, Value.pos x)
| Arg.LARROW x => (9, Value.pos x)
| Arg.RARROW x => (10, Value.pos x)
| Arg.COMMA x => (11, Value.pos x)
| Arg.AT x => (12, Value.pos x)
| Arg.EQEQ x => (13, Value.pos x)
| Arg.NEQ x => (14, Value.pos x)
| Arg.GT x => (15, Value.pos x)
| Arg.LT x => (16, Value.pos x)
| Arg.GEQ x => (17, Value.pos x)
| Arg.LEQ x => (18, Value.pos x)
| Arg.PLUS x => (19, Value.pos x)
| Arg.MINUS x => (20, Value.pos x)
| Arg.NOT x => (21, Value.pos x)
| Arg.WORLD x => (22, Value.pos x)
| Arg.TYPE x => (23, Value.pos x)
| Arg.EXTENSIBLE x => (24, Value.pos x)
| Arg.REL x => (25, Value.pos x)
| Arg.USCORE x => (26, Value.pos x)
| Arg.UCID x => (27, Value.pos_str x)
| Arg.LCID x => (28, Value.pos_str x)
| Arg.NUM x => (29, Value.pos_int x)
| Arg.STRING x => (30, Value.pos_str x)
| Arg.LANNO x => (31, Value.pos x)
| Arg.RANNO x => (32, Value.pos x)
| Arg.ANNO_QUERY x => (33, Value.pos x)
| Arg.ANNO_TYPE x => (34, Value.pos x)
| Arg.PRAGMA_QUERY x => (35, Value.pos x)
| Arg.PRAGMA_TYPE x => (36, Value.pos x)
)
)
in
val parse = ParseEngine.parse (
ParseEngine.next6x1 "~\139\128\138\128\140\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\137\136\135\134\133\132\142\141\131\130\143\128\128\128\144\148\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\\\\\\\128\\\128\128\\\\\\\\\\\\\\\\\\\\\\\128\128\\\\\\\\\\\\\\\\\\\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128]]]\128]\128\128]]]]]]]]]]]\128\128]]]]]]]]]\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128bbb\128b\128\128bbbbbbbbbbb\128\128bbbbbbbbb\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128^^^\128^\128\128^^^^^^^^^^^\128\128^^^^^^^^^\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128___\128_\128\128___________\128\128_________\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128```\128`\128\128```````````\128\128`````````\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128aaa\128a\128\128aaaaaaaaaaa\128\128aaaaaaaaa\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\138\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\136\135\134\133\132\142\128\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\139\128\138\128\140\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\137\136\135\134\133\132\142\141\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\152\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\153\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128[\138[\128[\156\155[[[[[[[[[[[\128\128\136\135\134\133\132\142\154\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128ccc\128c\128\128ccccccccccc\128\128ccccccccc\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\160\159\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\161\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\173\128\128\172\171\170\169\168\167\166\165\164\163\162\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\127\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128i\128i\128i\128\128iiiiiiiiiii\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\174\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128g\128g\128g\128\128ggggggggggg\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\175\128\128\128\128\172\171\170\169\168\167\166\165\164\163\162\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\176\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128x\128\128\128\128\177\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\178\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128[\138[\128[\128\128[[[[[[[[[[[\128\128\136\135\134\133\132\142\154\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\139\128\138\128\140\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\137\136\135\134\133\132\142\141\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\139\128\138\128\140\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\137\136\135\134\133\132\142\141\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128[\138[\128[\128\128[[[[[[[[[[[\128\128\136\135\134\133\132\142\154\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128h\128h\128h\128\128hhhhhhhhhhh\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\183\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\184\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\185\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\139\128\138\128\140\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\137\136\135\134\133\132\142\141\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\139\128\138\128\140\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\137\136\135\134\133\132\142\141\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\139\128\138\128\140\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\137\136\135\134\133\132\142\141\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\139\128\138\128\140\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\137\136\135\134\133\132\142\141\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\139\128\138\128\140\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\137\136\135\134\133\132\142\141\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\139\128\138\128\140\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\137\136\135\134\133\132\142\141\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\139\128\138\128\140\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\137\136\135\134\133\132\142\141\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\139\128\138\128\140\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\137\136\135\134\133\132\142\141\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\139\128\138\128\140\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\137\136\135\134\133\132\142\141\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\139\128\138\128\140\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\137\136\135\134\133\132\142\141\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\139\128\138\128\140\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\137\136\135\134\133\132\142\141\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128~\139\128\138\128\140\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\137\136\135\134\133\132\142\141\131\130\143\128\128\128\144\148\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\198\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128ddd\128d\128\128ddddddddddd\128\128ddddddddd\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\139\128\138\128\140\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\137\136\135\134\133\132\142\141\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\139\128\138\128\140\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\137\136\135\134\133\132\142\141\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\139\128\138\128\140\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\137\136\135\134\133\132\142\141\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128Y\128Y\128Y\128\128YYYYYYYYYYY\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128u\128u\128u\128\128\172\171\170\169\168\167\166\165\164\163\162\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128v\128v\128v\128\128\172\171\170\169\168\167\166\165\164\163\162\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128Z\128Z\128Z\128\128ZZZZZZZZZZZ\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\202\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\203\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\204\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128j\128j\128j\128\128jjjjjjjjjjj\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128k\128k\128k\128\128kkkkkkkkkk\162\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128l\128l\128l\128\128llllllllll\162\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128m\128m\128m\128\128mmmmmmmmmm\162\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128n\128n\128n\128\128nnnnnnnnnn\162\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128o\128o\128o\128\128oooooooooo\162\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128p\128p\128p\128\128pppppppppp\162\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128q\128q\128q\128\128qqqq\168\167\166\165\164\163\162\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128r\128r\128r\128\128rrr\169\168\167\166\165\164\163\162\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128s\128s\128s\128\128s\171\170\169\168\167\166\165\164\163\162\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128t\128t\128t\128\128t\171\170\169\168\167\166\165\164\163\162\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128}\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\205\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128f\128f\128f\128\128\172\171\170\169\168\167\166\165\164\163\162\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128w\128\128\128\128\128\128\172\171\170\169\168\167\166\165\164\163\162\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128e\128e\128e\128\128\172\171\170\169\168\167\166\165\164\163\162\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\206\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\209\208\128\128\128\128\128\207\128\128\128\128\128X\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128X\128\128\128\128\128\128\128\128\128\128\128\128\209\208\128\128\128\128\128\207\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128~\139\128\138\128\140\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\137\136\135\134\133\132\142\141\131\130\143\128\128\128\144\148\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128~\139\128\138\128\140\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\137\136\135\134\133\132\142\141\131\130\143\128\128\128\144\148\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128X\128\128\128\128\128\128\128\128\128\128\128\128\209\208\128\128\128\128\128\207\128\128\128\128\128X\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128X\128\128\128\128\128\128\128\128\128\128\128\128\209\208\128\128\128\128\128\207\128\128\128\128\128X\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128X\128\128\128\128\128\128\128\128\128\128\128\128\209\208\128\128\128\128\128\207\128\128\128\128\128X\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\217\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\218\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128y\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128{\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128U\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128U\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128V\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128V\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128W\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128W\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128~\139\128\138\128\140\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\137\136\135\134\133\132\142\141\131\130\143\128\128\128\144\148\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128~\139\128\138\128\140\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\137\136\135\134\133\132\142\141\131\130\143\128\128\128\144\148\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128|\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128z\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128",
ParseEngine.next6x1 "\145\144\128\128\146\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\148\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\149\128\128\146\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\150\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\156\157\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\156\178\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\179\128\128\146\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\180\128\128\146\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\156\181\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\185\128\128\146\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\186\128\128\146\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\187\128\128\146\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\188\128\128\146\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\189\128\128\146\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\190\128\128\146\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\191\128\128\146\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\192\128\128\146\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\193\128\128\146\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\194\128\128\146\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\195\128\128\146\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\196\144\128\128\146\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\198\128\128\146\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\199\128\128\146\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\200\128\128\146\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\209\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\210\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\211\144\128\128\146\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\212\144\128\128\146\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\213\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\214\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\215\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\218\144\128\128\146\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\219\144\128\128\146\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128",
Vector.fromList [(0,0,(fn rest => Value.decl(Arg.Done {})::rest)),
(0,3,(fn Value.decl(arg0)::Value.pos(arg1)::Value.syn(arg2)::rest => Value.decl(Arg.Syn {3=arg0,2=arg1,1=arg2})::rest|_=>raise (Fail "bad parser"))),
(0,7,(fn Value.decl(arg0)::Value.pos(arg1)::Value.modes(arg2)::Value.pos_str(arg3)::Value.pos_str(arg4)::_::Value.pos(arg5)::rest => Value.decl(Arg.AnnoQuery {6=arg0,5=arg1,4=arg2,3=arg3,2=arg4,1=arg5})::rest|_=>raise (Fail "bad parser"))),
(0,6,(fn Value.decl(arg0)::Value.pos(arg1)::Value.pos_str(arg2)::Value.pos_str(arg3)::_::Value.pos(arg4)::rest => Value.decl(Arg.AnnoType {5=arg0,4=arg1,3=arg2,2=arg3,1=arg4})::rest|_=>raise (Fail "bad parser"))),
(0,7,(fn Value.decl(arg0)::Value.pos(arg1)::Value.modes(arg2)::Value.pos_str(arg3)::_::Value.pos_str(arg4)::Value.pos(arg5)::rest => Value.decl(Arg.PragmaQuery {6=arg0,5=arg1,4=arg2,3=arg3,2=arg4,1=arg5})::rest|_=>raise (Fail "bad parser"))),
(0,5,(fn Value.decl(arg0)::Value.pos(arg1)::Value.pos_str(arg2)::Value.pos_str(arg3)::Value.pos(arg4)::rest => Value.decl(Arg.PragmaType {5=arg0,4=arg1,3=arg2,2=arg3,1=arg4})::rest|_=>raise (Fail "bad parser"))),
(3,1,(fn Value.pos_str(arg0)::rest => Value.syn(Arg.Ucid arg0)::rest|_=>raise (Fail "bad parser"))),
(3,3,(fn Value.syn(arg0)::_::Value.pos_str(arg1)::rest => Value.syn(Arg.ascribe_ucid {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(1,3,(fn Value.syn(arg0)::_::Value.pos_str(arg1)::rest => Value.syn(Arg.Ascribe {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(1,3,(fn Value.syn(arg0)::_::Value.pos_str(arg1)::rest => Value.syn(Arg.Assign {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(1,3,(fn Value.syn(arg0)::_::Value.syn(arg1)::rest => Value.syn(Arg.larrow {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(1,3,(fn Value.syn(arg0)::_::Value.syn(arg1)::rest => Value.syn(Arg.Arrow {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(1,3,(fn Value.syn(arg0)::_::Value.syn(arg1)::rest => Value.syn(Arg.Conj {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(1,3,(fn Value.syn(arg0)::_::Value.syn(arg1)::rest => Value.syn(Arg.At {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(1,3,(fn Value.syn(arg0)::_::Value.syn(arg1)::rest => Value.syn(Arg.eqeq {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(1,3,(fn Value.syn(arg0)::_::Value.syn(arg1)::rest => Value.syn(Arg.neq {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(1,3,(fn Value.syn(arg0)::_::Value.syn(arg1)::rest => Value.syn(Arg.gt {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(1,3,(fn Value.syn(arg0)::_::Value.syn(arg1)::rest => Value.syn(Arg.lt {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(1,3,(fn Value.syn(arg0)::_::Value.syn(arg1)::rest => Value.syn(Arg.geq {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(1,3,(fn Value.syn(arg0)::_::Value.syn(arg1)::rest => Value.syn(Arg.leq {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(1,3,(fn Value.syn(arg0)::_::Value.syn(arg1)::rest => Value.syn(Arg.plus {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(1,1,(fn Value.syn(arg0)::rest => Value.syn(Arg.id1 arg0)::rest|_=>raise (Fail "bad parser"))),
(1,2,(fn Value.sings(arg0)::Value.pos_str(arg1)::rest => Value.syn(Arg.App {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(1,2,(fn Value.syn(arg0)::Value.pos(arg1)::rest => Value.syn(Arg.Not {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(1,4,(fn Value.syn(arg0)::Value.pos(arg1)::Value.syn(arg2)::Value.pos(arg3)::rest => Value.syn(Arg.Pi {4=arg0,3=arg1,2=arg2,1=arg3})::rest|_=>raise (Fail "bad parser"))),
(1,4,(fn Value.syn(arg0)::_::Value.pos_str(arg1)::Value.pos(arg2)::rest => Value.syn(Arg.Ex {3=arg0,2=arg1,1=arg2})::rest|_=>raise (Fail "bad parser"))),
(4,3,(fn Value.pos(arg0)::Value.syn(arg1)::Value.pos(arg2)::rest => Value.syn(Arg.Paren {3=arg0,2=arg1,1=arg2})::rest|_=>raise (Fail "bad parser"))),
(4,1,(fn Value.pos_str(arg0)::rest => Value.syn(Arg.var arg0)::rest|_=>raise (Fail "bad parser"))),
(4,1,(fn Value.pos(arg0)::rest => Value.syn(Arg.Uscore arg0)::rest|_=>raise (Fail "bad parser"))),
(4,1,(fn Value.pos(arg0)::rest => Value.syn(Arg.World arg0)::rest|_=>raise (Fail "bad parser"))),
(4,1,(fn Value.pos(arg0)::rest => Value.syn(Arg.Type arg0)::rest|_=>raise (Fail "bad parser"))),
(4,1,(fn Value.pos(arg0)::rest => Value.syn(Arg.Extensible arg0)::rest|_=>raise (Fail "bad parser"))),
(4,1,(fn Value.pos(arg0)::rest => Value.syn(Arg.Rel arg0)::rest|_=>raise (Fail "bad parser"))),
(4,1,(fn Value.pos_int(arg0)::rest => Value.syn(Arg.Num arg0)::rest|_=>raise (Fail "bad parser"))),
(4,1,(fn Value.pos_str(arg0)::rest => Value.syn(Arg.String arg0)::rest|_=>raise (Fail "bad parser"))),
(5,0,(fn rest => Value.sings(Arg.sings_end {})::rest)),
(5,2,(fn Value.sings(arg0)::Value.syn(arg1)::rest => Value.sings(Arg.sings_cons {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(5,2,(fn Value.sings(arg0)::Value.pos_str(arg1)::rest => Value.sings(Arg.sings_lcid {2=arg0,1=arg1})::rest|_=>raise (Fail "bad parser"))),
(2,0,(fn rest => Value.modes(Arg.mode_end {})::rest)),
(2,2,(fn Value.modes(arg0)::_::rest => Value.modes(Arg.mode_input arg0)::rest|_=>raise (Fail "bad parser"))),
(2,2,(fn Value.modes(arg0)::_::rest => Value.modes(Arg.mode_output arg0)::rest|_=>raise (Fail "bad parser"))),
(2,2,(fn Value.modes(arg0)::_::rest => Value.modes(Arg.mode_ignore arg0)::rest|_=>raise (Fail "bad parser")))],
(fn Value.decl x => x | _ => raise (Fail "bad parser")), Arg.error)
end
end
