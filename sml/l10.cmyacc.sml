(*

State 0:

start -> . Decl  / 0
0 : Decl -> .  / 0
1 : Decl -> . Syn PERIOD Decl  / 0
2 : Decl -> . LANNO ANNO_QUERY LCID LCID Modes RANNO Decl  / 0
5 : Syn -> . LCID COLON Syn  / 1
6 : Syn -> . LCID EQ Syn  / 1
7 : Syn -> . Syn LARROW Syn  / 1
8 : Syn -> . Syn RARROW Syn  / 1
9 : Syn -> . Syn COMMA Syn  / 1
10 : Syn -> . Syn AT Syn  / 1
11 : Syn -> . Syn EQEQ Syn  / 1
12 : Syn -> . Syn NEQ Syn  / 1
13 : Syn -> . Syn GT Syn  / 1
14 : Syn -> . Syn LT Syn  / 1
15 : Syn -> . Syn GEQ Syn  / 1
16 : Syn -> . Syn LEQ Syn  / 1
17 : Syn -> . Syn PLUS Syn  / 1
18 : Syn -> . Simp  / 1
19 : Syn -> . LCID Sings  / 1
20 : Syn -> . NOT Simp  / 1
21 : Syn -> . LCURLY Bind RCURLY Syn  / 1
22 : Syn -> . EX UCID PERIOD Syn  / 1
23 : Simp -> . LPAREN Syn RPAREN  / 1
24 : Simp -> . UCID  / 1
25 : Simp -> . USCORE  / 1
26 : Simp -> . WORLD  / 1
27 : Simp -> . TYPE  / 1
28 : Simp -> . REL  / 1
29 : Simp -> . NUM  / 1
30 : Simp -> . STRING  / 1

$ => reduce 0
LCURLY => shift 9
LPAREN => shift 8
EX => shift 10
NOT => shift 7
WORLD => shift 6
TYPE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 12
LCID => shift 11
NUM => shift 2
STRING => shift 1
LANNO => shift 13
Decl => goto 14
Syn => goto 15
Simp => goto 16

-----

State 1:

30 : Simp -> STRING .  / 2

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
REL => reduce 30
USCORE => reduce 30
UCID => reduce 30
LCID => reduce 30
NUM => reduce 30
STRING => reduce 30

-----

State 2:

29 : Simp -> NUM .  / 2

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
REL => reduce 29
USCORE => reduce 29
UCID => reduce 29
LCID => reduce 29
NUM => reduce 29
STRING => reduce 29

-----

State 3:

25 : Simp -> USCORE .  / 2

RCURLY => reduce 25
LPAREN => reduce 25
RPAREN => reduce 25
PERIOD => reduce 25
LARROW => reduce 25
RARROW => reduce 25
COMMA => reduce 25
AT => reduce 25
EQEQ => reduce 25
NEQ => reduce 25
GT => reduce 25
LT => reduce 25
GEQ => reduce 25
LEQ => reduce 25
PLUS => reduce 25
WORLD => reduce 25
TYPE => reduce 25
REL => reduce 25
USCORE => reduce 25
UCID => reduce 25
LCID => reduce 25
NUM => reduce 25
STRING => reduce 25

-----

State 4:

28 : Simp -> REL .  / 2

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
REL => reduce 28
USCORE => reduce 28
UCID => reduce 28
LCID => reduce 28
NUM => reduce 28
STRING => reduce 28

-----

State 5:

27 : Simp -> TYPE .  / 2

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
REL => reduce 27
USCORE => reduce 27
UCID => reduce 27
LCID => reduce 27
NUM => reduce 27
STRING => reduce 27

-----

State 6:

26 : Simp -> WORLD .  / 2

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
REL => reduce 26
USCORE => reduce 26
UCID => reduce 26
LCID => reduce 26
NUM => reduce 26
STRING => reduce 26

-----

State 7:

20 : Syn -> NOT . Simp  / 3
23 : Simp -> . LPAREN Syn RPAREN  / 3
24 : Simp -> . UCID  / 3
25 : Simp -> . USCORE  / 3
26 : Simp -> . WORLD  / 3
27 : Simp -> . TYPE  / 3
28 : Simp -> . REL  / 3
29 : Simp -> . NUM  / 3
30 : Simp -> . STRING  / 3

LPAREN => shift 8
WORLD => shift 6
TYPE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 12
NUM => shift 2
STRING => shift 1
Simp => goto 17

-----

State 8:

5 : Syn -> . LCID COLON Syn  / 4
6 : Syn -> . LCID EQ Syn  / 4
7 : Syn -> . Syn LARROW Syn  / 4
8 : Syn -> . Syn RARROW Syn  / 4
9 : Syn -> . Syn COMMA Syn  / 4
10 : Syn -> . Syn AT Syn  / 4
11 : Syn -> . Syn EQEQ Syn  / 4
12 : Syn -> . Syn NEQ Syn  / 4
13 : Syn -> . Syn GT Syn  / 4
14 : Syn -> . Syn LT Syn  / 4
15 : Syn -> . Syn GEQ Syn  / 4
16 : Syn -> . Syn LEQ Syn  / 4
17 : Syn -> . Syn PLUS Syn  / 4
18 : Syn -> . Simp  / 4
19 : Syn -> . LCID Sings  / 4
20 : Syn -> . NOT Simp  / 4
21 : Syn -> . LCURLY Bind RCURLY Syn  / 4
22 : Syn -> . EX UCID PERIOD Syn  / 4
23 : Simp -> . LPAREN Syn RPAREN  / 4
23 : Simp -> LPAREN . Syn RPAREN  / 2
24 : Simp -> . UCID  / 4
25 : Simp -> . USCORE  / 4
26 : Simp -> . WORLD  / 4
27 : Simp -> . TYPE  / 4
28 : Simp -> . REL  / 4
29 : Simp -> . NUM  / 4
30 : Simp -> . STRING  / 4

LCURLY => shift 9
LPAREN => shift 8
EX => shift 10
NOT => shift 7
WORLD => shift 6
TYPE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 12
LCID => shift 11
NUM => shift 2
STRING => shift 1
Syn => goto 18
Simp => goto 16

-----

State 9:

3 : Bind -> . UCID  / 5
4 : Bind -> . UCID COLON Syn  / 5
21 : Syn -> LCURLY . Bind RCURLY Syn  / 3

UCID => shift 20
Bind => goto 19

-----

State 10:

22 : Syn -> EX . UCID PERIOD Syn  / 3

UCID => shift 21

-----

State 11:

5 : Syn -> LCID . COLON Syn  / 3
6 : Syn -> LCID . EQ Syn  / 3
19 : Syn -> LCID . Sings  / 3
23 : Simp -> . LPAREN Syn RPAREN  / 2
24 : Simp -> . UCID  / 2
25 : Simp -> . USCORE  / 2
26 : Simp -> . WORLD  / 2
27 : Simp -> . TYPE  / 2
28 : Simp -> . REL  / 2
29 : Simp -> . NUM  / 2
30 : Simp -> . STRING  / 2
31 : Sings -> .  / 3
32 : Sings -> . Simp Sings  / 3
33 : Sings -> . LCID Sings  / 3

RCURLY => reduce 31
LPAREN => shift 8
RPAREN => reduce 31
PERIOD => reduce 31
COLON => shift 24
EQ => shift 23
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
WORLD => shift 6
TYPE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 12
LCID => shift 22
NUM => shift 2
STRING => shift 1
Simp => goto 25
Sings => goto 26

-----

State 12:

24 : Simp -> UCID .  / 2

RCURLY => reduce 24
LPAREN => reduce 24
RPAREN => reduce 24
PERIOD => reduce 24
LARROW => reduce 24
RARROW => reduce 24
COMMA => reduce 24
AT => reduce 24
EQEQ => reduce 24
NEQ => reduce 24
GT => reduce 24
LT => reduce 24
GEQ => reduce 24
LEQ => reduce 24
PLUS => reduce 24
WORLD => reduce 24
TYPE => reduce 24
REL => reduce 24
USCORE => reduce 24
UCID => reduce 24
LCID => reduce 24
NUM => reduce 24
STRING => reduce 24

-----

State 13:

2 : Decl -> LANNO . ANNO_QUERY LCID LCID Modes RANNO Decl  / 0

ANNO_QUERY => shift 27

-----

State 14:

start -> Decl .  / 0

$ => accept

-----

State 15:

1 : Decl -> Syn . PERIOD Decl  / 0
7 : Syn -> Syn . LARROW Syn  / 1
8 : Syn -> Syn . RARROW Syn  / 1
9 : Syn -> Syn . COMMA Syn  / 1
10 : Syn -> Syn . AT Syn  / 1
11 : Syn -> Syn . EQEQ Syn  / 1
12 : Syn -> Syn . NEQ Syn  / 1
13 : Syn -> Syn . GT Syn  / 1
14 : Syn -> Syn . LT Syn  / 1
15 : Syn -> Syn . GEQ Syn  / 1
16 : Syn -> Syn . LEQ Syn  / 1
17 : Syn -> Syn . PLUS Syn  / 1

PERIOD => shift 39
LARROW => shift 38
RARROW => shift 37
COMMA => shift 36
AT => shift 35
EQEQ => shift 34
NEQ => shift 33
GT => shift 32
LT => shift 31
GEQ => shift 30
LEQ => shift 29
PLUS => shift 28

-----

State 16:

18 : Syn -> Simp .  / 3

RCURLY => reduce 18
RPAREN => reduce 18
PERIOD => reduce 18
LARROW => reduce 18
RARROW => reduce 18
COMMA => reduce 18
AT => reduce 18
EQEQ => reduce 18
NEQ => reduce 18
GT => reduce 18
LT => reduce 18
GEQ => reduce 18
LEQ => reduce 18
PLUS => reduce 18

-----

State 17:

20 : Syn -> NOT Simp .  / 3

RCURLY => reduce 20
RPAREN => reduce 20
PERIOD => reduce 20
LARROW => reduce 20
RARROW => reduce 20
COMMA => reduce 20
AT => reduce 20
EQEQ => reduce 20
NEQ => reduce 20
GT => reduce 20
LT => reduce 20
GEQ => reduce 20
LEQ => reduce 20
PLUS => reduce 20

-----

State 18:

7 : Syn -> Syn . LARROW Syn  / 4
8 : Syn -> Syn . RARROW Syn  / 4
9 : Syn -> Syn . COMMA Syn  / 4
10 : Syn -> Syn . AT Syn  / 4
11 : Syn -> Syn . EQEQ Syn  / 4
12 : Syn -> Syn . NEQ Syn  / 4
13 : Syn -> Syn . GT Syn  / 4
14 : Syn -> Syn . LT Syn  / 4
15 : Syn -> Syn . GEQ Syn  / 4
16 : Syn -> Syn . LEQ Syn  / 4
17 : Syn -> Syn . PLUS Syn  / 4
23 : Simp -> LPAREN Syn . RPAREN  / 2

RPAREN => shift 40
LARROW => shift 38
RARROW => shift 37
COMMA => shift 36
AT => shift 35
EQEQ => shift 34
NEQ => shift 33
GT => shift 32
LT => shift 31
GEQ => shift 30
LEQ => shift 29
PLUS => shift 28

-----

State 19:

21 : Syn -> LCURLY Bind . RCURLY Syn  / 3

RCURLY => shift 41

-----

State 20:

3 : Bind -> UCID .  / 5
4 : Bind -> UCID . COLON Syn  / 5

RCURLY => reduce 3
COLON => shift 42

-----

State 21:

22 : Syn -> EX UCID . PERIOD Syn  / 3

PERIOD => shift 43

-----

State 22:

23 : Simp -> . LPAREN Syn RPAREN  / 2
24 : Simp -> . UCID  / 2
25 : Simp -> . USCORE  / 2
26 : Simp -> . WORLD  / 2
27 : Simp -> . TYPE  / 2
28 : Simp -> . REL  / 2
29 : Simp -> . NUM  / 2
30 : Simp -> . STRING  / 2
31 : Sings -> .  / 3
32 : Sings -> . Simp Sings  / 3
33 : Sings -> . LCID Sings  / 3
33 : Sings -> LCID . Sings  / 3

RCURLY => reduce 31
LPAREN => shift 8
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
WORLD => shift 6
TYPE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 12
LCID => shift 22
NUM => shift 2
STRING => shift 1
Simp => goto 25
Sings => goto 44

-----

State 23:

5 : Syn -> . LCID COLON Syn  / 3
6 : Syn -> . LCID EQ Syn  / 3
6 : Syn -> LCID EQ . Syn  / 3
7 : Syn -> . Syn LARROW Syn  / 3
8 : Syn -> . Syn RARROW Syn  / 3
9 : Syn -> . Syn COMMA Syn  / 3
10 : Syn -> . Syn AT Syn  / 3
11 : Syn -> . Syn EQEQ Syn  / 3
12 : Syn -> . Syn NEQ Syn  / 3
13 : Syn -> . Syn GT Syn  / 3
14 : Syn -> . Syn LT Syn  / 3
15 : Syn -> . Syn GEQ Syn  / 3
16 : Syn -> . Syn LEQ Syn  / 3
17 : Syn -> . Syn PLUS Syn  / 3
18 : Syn -> . Simp  / 3
19 : Syn -> . LCID Sings  / 3
20 : Syn -> . NOT Simp  / 3
21 : Syn -> . LCURLY Bind RCURLY Syn  / 3
22 : Syn -> . EX UCID PERIOD Syn  / 3
23 : Simp -> . LPAREN Syn RPAREN  / 3
24 : Simp -> . UCID  / 3
25 : Simp -> . USCORE  / 3
26 : Simp -> . WORLD  / 3
27 : Simp -> . TYPE  / 3
28 : Simp -> . REL  / 3
29 : Simp -> . NUM  / 3
30 : Simp -> . STRING  / 3

LCURLY => shift 9
LPAREN => shift 8
EX => shift 10
NOT => shift 7
WORLD => shift 6
TYPE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 12
LCID => shift 11
NUM => shift 2
STRING => shift 1
Syn => goto 45
Simp => goto 16

-----

State 24:

5 : Syn -> . LCID COLON Syn  / 3
5 : Syn -> LCID COLON . Syn  / 3
6 : Syn -> . LCID EQ Syn  / 3
7 : Syn -> . Syn LARROW Syn  / 3
8 : Syn -> . Syn RARROW Syn  / 3
9 : Syn -> . Syn COMMA Syn  / 3
10 : Syn -> . Syn AT Syn  / 3
11 : Syn -> . Syn EQEQ Syn  / 3
12 : Syn -> . Syn NEQ Syn  / 3
13 : Syn -> . Syn GT Syn  / 3
14 : Syn -> . Syn LT Syn  / 3
15 : Syn -> . Syn GEQ Syn  / 3
16 : Syn -> . Syn LEQ Syn  / 3
17 : Syn -> . Syn PLUS Syn  / 3
18 : Syn -> . Simp  / 3
19 : Syn -> . LCID Sings  / 3
20 : Syn -> . NOT Simp  / 3
21 : Syn -> . LCURLY Bind RCURLY Syn  / 3
22 : Syn -> . EX UCID PERIOD Syn  / 3
23 : Simp -> . LPAREN Syn RPAREN  / 3
24 : Simp -> . UCID  / 3
25 : Simp -> . USCORE  / 3
26 : Simp -> . WORLD  / 3
27 : Simp -> . TYPE  / 3
28 : Simp -> . REL  / 3
29 : Simp -> . NUM  / 3
30 : Simp -> . STRING  / 3

LCURLY => shift 9
LPAREN => shift 8
EX => shift 10
NOT => shift 7
WORLD => shift 6
TYPE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 12
LCID => shift 11
NUM => shift 2
STRING => shift 1
Syn => goto 46
Simp => goto 16

-----

State 25:

23 : Simp -> . LPAREN Syn RPAREN  / 2
24 : Simp -> . UCID  / 2
25 : Simp -> . USCORE  / 2
26 : Simp -> . WORLD  / 2
27 : Simp -> . TYPE  / 2
28 : Simp -> . REL  / 2
29 : Simp -> . NUM  / 2
30 : Simp -> . STRING  / 2
31 : Sings -> .  / 3
32 : Sings -> . Simp Sings  / 3
32 : Sings -> Simp . Sings  / 3
33 : Sings -> . LCID Sings  / 3

RCURLY => reduce 31
LPAREN => shift 8
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
WORLD => shift 6
TYPE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 12
LCID => shift 22
NUM => shift 2
STRING => shift 1
Simp => goto 25
Sings => goto 47

-----

State 26:

19 : Syn -> LCID Sings .  / 3

RCURLY => reduce 19
RPAREN => reduce 19
PERIOD => reduce 19
LARROW => reduce 19
RARROW => reduce 19
COMMA => reduce 19
AT => reduce 19
EQEQ => reduce 19
NEQ => reduce 19
GT => reduce 19
LT => reduce 19
GEQ => reduce 19
LEQ => reduce 19
PLUS => reduce 19

-----

State 27:

2 : Decl -> LANNO ANNO_QUERY . LCID LCID Modes RANNO Decl  / 0

LCID => shift 48

-----

State 28:

5 : Syn -> . LCID COLON Syn  / 3
6 : Syn -> . LCID EQ Syn  / 3
7 : Syn -> . Syn LARROW Syn  / 3
8 : Syn -> . Syn RARROW Syn  / 3
9 : Syn -> . Syn COMMA Syn  / 3
10 : Syn -> . Syn AT Syn  / 3
11 : Syn -> . Syn EQEQ Syn  / 3
12 : Syn -> . Syn NEQ Syn  / 3
13 : Syn -> . Syn GT Syn  / 3
14 : Syn -> . Syn LT Syn  / 3
15 : Syn -> . Syn GEQ Syn  / 3
16 : Syn -> . Syn LEQ Syn  / 3
17 : Syn -> . Syn PLUS Syn  / 3
17 : Syn -> Syn PLUS . Syn  / 3
18 : Syn -> . Simp  / 3
19 : Syn -> . LCID Sings  / 3
20 : Syn -> . NOT Simp  / 3
21 : Syn -> . LCURLY Bind RCURLY Syn  / 3
22 : Syn -> . EX UCID PERIOD Syn  / 3
23 : Simp -> . LPAREN Syn RPAREN  / 3
24 : Simp -> . UCID  / 3
25 : Simp -> . USCORE  / 3
26 : Simp -> . WORLD  / 3
27 : Simp -> . TYPE  / 3
28 : Simp -> . REL  / 3
29 : Simp -> . NUM  / 3
30 : Simp -> . STRING  / 3

LCURLY => shift 9
LPAREN => shift 8
EX => shift 10
NOT => shift 7
WORLD => shift 6
TYPE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 12
LCID => shift 11
NUM => shift 2
STRING => shift 1
Syn => goto 49
Simp => goto 16

-----

State 29:

5 : Syn -> . LCID COLON Syn  / 3
6 : Syn -> . LCID EQ Syn  / 3
7 : Syn -> . Syn LARROW Syn  / 3
8 : Syn -> . Syn RARROW Syn  / 3
9 : Syn -> . Syn COMMA Syn  / 3
10 : Syn -> . Syn AT Syn  / 3
11 : Syn -> . Syn EQEQ Syn  / 3
12 : Syn -> . Syn NEQ Syn  / 3
13 : Syn -> . Syn GT Syn  / 3
14 : Syn -> . Syn LT Syn  / 3
15 : Syn -> . Syn GEQ Syn  / 3
16 : Syn -> . Syn LEQ Syn  / 3
16 : Syn -> Syn LEQ . Syn  / 3
17 : Syn -> . Syn PLUS Syn  / 3
18 : Syn -> . Simp  / 3
19 : Syn -> . LCID Sings  / 3
20 : Syn -> . NOT Simp  / 3
21 : Syn -> . LCURLY Bind RCURLY Syn  / 3
22 : Syn -> . EX UCID PERIOD Syn  / 3
23 : Simp -> . LPAREN Syn RPAREN  / 3
24 : Simp -> . UCID  / 3
25 : Simp -> . USCORE  / 3
26 : Simp -> . WORLD  / 3
27 : Simp -> . TYPE  / 3
28 : Simp -> . REL  / 3
29 : Simp -> . NUM  / 3
30 : Simp -> . STRING  / 3

LCURLY => shift 9
LPAREN => shift 8
EX => shift 10
NOT => shift 7
WORLD => shift 6
TYPE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 12
LCID => shift 11
NUM => shift 2
STRING => shift 1
Syn => goto 50
Simp => goto 16

-----

State 30:

5 : Syn -> . LCID COLON Syn  / 3
6 : Syn -> . LCID EQ Syn  / 3
7 : Syn -> . Syn LARROW Syn  / 3
8 : Syn -> . Syn RARROW Syn  / 3
9 : Syn -> . Syn COMMA Syn  / 3
10 : Syn -> . Syn AT Syn  / 3
11 : Syn -> . Syn EQEQ Syn  / 3
12 : Syn -> . Syn NEQ Syn  / 3
13 : Syn -> . Syn GT Syn  / 3
14 : Syn -> . Syn LT Syn  / 3
15 : Syn -> . Syn GEQ Syn  / 3
15 : Syn -> Syn GEQ . Syn  / 3
16 : Syn -> . Syn LEQ Syn  / 3
17 : Syn -> . Syn PLUS Syn  / 3
18 : Syn -> . Simp  / 3
19 : Syn -> . LCID Sings  / 3
20 : Syn -> . NOT Simp  / 3
21 : Syn -> . LCURLY Bind RCURLY Syn  / 3
22 : Syn -> . EX UCID PERIOD Syn  / 3
23 : Simp -> . LPAREN Syn RPAREN  / 3
24 : Simp -> . UCID  / 3
25 : Simp -> . USCORE  / 3
26 : Simp -> . WORLD  / 3
27 : Simp -> . TYPE  / 3
28 : Simp -> . REL  / 3
29 : Simp -> . NUM  / 3
30 : Simp -> . STRING  / 3

LCURLY => shift 9
LPAREN => shift 8
EX => shift 10
NOT => shift 7
WORLD => shift 6
TYPE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 12
LCID => shift 11
NUM => shift 2
STRING => shift 1
Syn => goto 51
Simp => goto 16

-----

State 31:

5 : Syn -> . LCID COLON Syn  / 3
6 : Syn -> . LCID EQ Syn  / 3
7 : Syn -> . Syn LARROW Syn  / 3
8 : Syn -> . Syn RARROW Syn  / 3
9 : Syn -> . Syn COMMA Syn  / 3
10 : Syn -> . Syn AT Syn  / 3
11 : Syn -> . Syn EQEQ Syn  / 3
12 : Syn -> . Syn NEQ Syn  / 3
13 : Syn -> . Syn GT Syn  / 3
14 : Syn -> . Syn LT Syn  / 3
14 : Syn -> Syn LT . Syn  / 3
15 : Syn -> . Syn GEQ Syn  / 3
16 : Syn -> . Syn LEQ Syn  / 3
17 : Syn -> . Syn PLUS Syn  / 3
18 : Syn -> . Simp  / 3
19 : Syn -> . LCID Sings  / 3
20 : Syn -> . NOT Simp  / 3
21 : Syn -> . LCURLY Bind RCURLY Syn  / 3
22 : Syn -> . EX UCID PERIOD Syn  / 3
23 : Simp -> . LPAREN Syn RPAREN  / 3
24 : Simp -> . UCID  / 3
25 : Simp -> . USCORE  / 3
26 : Simp -> . WORLD  / 3
27 : Simp -> . TYPE  / 3
28 : Simp -> . REL  / 3
29 : Simp -> . NUM  / 3
30 : Simp -> . STRING  / 3

LCURLY => shift 9
LPAREN => shift 8
EX => shift 10
NOT => shift 7
WORLD => shift 6
TYPE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 12
LCID => shift 11
NUM => shift 2
STRING => shift 1
Syn => goto 52
Simp => goto 16

-----

State 32:

5 : Syn -> . LCID COLON Syn  / 3
6 : Syn -> . LCID EQ Syn  / 3
7 : Syn -> . Syn LARROW Syn  / 3
8 : Syn -> . Syn RARROW Syn  / 3
9 : Syn -> . Syn COMMA Syn  / 3
10 : Syn -> . Syn AT Syn  / 3
11 : Syn -> . Syn EQEQ Syn  / 3
12 : Syn -> . Syn NEQ Syn  / 3
13 : Syn -> . Syn GT Syn  / 3
13 : Syn -> Syn GT . Syn  / 3
14 : Syn -> . Syn LT Syn  / 3
15 : Syn -> . Syn GEQ Syn  / 3
16 : Syn -> . Syn LEQ Syn  / 3
17 : Syn -> . Syn PLUS Syn  / 3
18 : Syn -> . Simp  / 3
19 : Syn -> . LCID Sings  / 3
20 : Syn -> . NOT Simp  / 3
21 : Syn -> . LCURLY Bind RCURLY Syn  / 3
22 : Syn -> . EX UCID PERIOD Syn  / 3
23 : Simp -> . LPAREN Syn RPAREN  / 3
24 : Simp -> . UCID  / 3
25 : Simp -> . USCORE  / 3
26 : Simp -> . WORLD  / 3
27 : Simp -> . TYPE  / 3
28 : Simp -> . REL  / 3
29 : Simp -> . NUM  / 3
30 : Simp -> . STRING  / 3

LCURLY => shift 9
LPAREN => shift 8
EX => shift 10
NOT => shift 7
WORLD => shift 6
TYPE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 12
LCID => shift 11
NUM => shift 2
STRING => shift 1
Syn => goto 53
Simp => goto 16

-----

State 33:

5 : Syn -> . LCID COLON Syn  / 3
6 : Syn -> . LCID EQ Syn  / 3
7 : Syn -> . Syn LARROW Syn  / 3
8 : Syn -> . Syn RARROW Syn  / 3
9 : Syn -> . Syn COMMA Syn  / 3
10 : Syn -> . Syn AT Syn  / 3
11 : Syn -> . Syn EQEQ Syn  / 3
12 : Syn -> . Syn NEQ Syn  / 3
12 : Syn -> Syn NEQ . Syn  / 3
13 : Syn -> . Syn GT Syn  / 3
14 : Syn -> . Syn LT Syn  / 3
15 : Syn -> . Syn GEQ Syn  / 3
16 : Syn -> . Syn LEQ Syn  / 3
17 : Syn -> . Syn PLUS Syn  / 3
18 : Syn -> . Simp  / 3
19 : Syn -> . LCID Sings  / 3
20 : Syn -> . NOT Simp  / 3
21 : Syn -> . LCURLY Bind RCURLY Syn  / 3
22 : Syn -> . EX UCID PERIOD Syn  / 3
23 : Simp -> . LPAREN Syn RPAREN  / 3
24 : Simp -> . UCID  / 3
25 : Simp -> . USCORE  / 3
26 : Simp -> . WORLD  / 3
27 : Simp -> . TYPE  / 3
28 : Simp -> . REL  / 3
29 : Simp -> . NUM  / 3
30 : Simp -> . STRING  / 3

LCURLY => shift 9
LPAREN => shift 8
EX => shift 10
NOT => shift 7
WORLD => shift 6
TYPE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 12
LCID => shift 11
NUM => shift 2
STRING => shift 1
Syn => goto 54
Simp => goto 16

-----

State 34:

5 : Syn -> . LCID COLON Syn  / 3
6 : Syn -> . LCID EQ Syn  / 3
7 : Syn -> . Syn LARROW Syn  / 3
8 : Syn -> . Syn RARROW Syn  / 3
9 : Syn -> . Syn COMMA Syn  / 3
10 : Syn -> . Syn AT Syn  / 3
11 : Syn -> . Syn EQEQ Syn  / 3
11 : Syn -> Syn EQEQ . Syn  / 3
12 : Syn -> . Syn NEQ Syn  / 3
13 : Syn -> . Syn GT Syn  / 3
14 : Syn -> . Syn LT Syn  / 3
15 : Syn -> . Syn GEQ Syn  / 3
16 : Syn -> . Syn LEQ Syn  / 3
17 : Syn -> . Syn PLUS Syn  / 3
18 : Syn -> . Simp  / 3
19 : Syn -> . LCID Sings  / 3
20 : Syn -> . NOT Simp  / 3
21 : Syn -> . LCURLY Bind RCURLY Syn  / 3
22 : Syn -> . EX UCID PERIOD Syn  / 3
23 : Simp -> . LPAREN Syn RPAREN  / 3
24 : Simp -> . UCID  / 3
25 : Simp -> . USCORE  / 3
26 : Simp -> . WORLD  / 3
27 : Simp -> . TYPE  / 3
28 : Simp -> . REL  / 3
29 : Simp -> . NUM  / 3
30 : Simp -> . STRING  / 3

LCURLY => shift 9
LPAREN => shift 8
EX => shift 10
NOT => shift 7
WORLD => shift 6
TYPE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 12
LCID => shift 11
NUM => shift 2
STRING => shift 1
Syn => goto 55
Simp => goto 16

-----

State 35:

5 : Syn -> . LCID COLON Syn  / 3
6 : Syn -> . LCID EQ Syn  / 3
7 : Syn -> . Syn LARROW Syn  / 3
8 : Syn -> . Syn RARROW Syn  / 3
9 : Syn -> . Syn COMMA Syn  / 3
10 : Syn -> . Syn AT Syn  / 3
10 : Syn -> Syn AT . Syn  / 3
11 : Syn -> . Syn EQEQ Syn  / 3
12 : Syn -> . Syn NEQ Syn  / 3
13 : Syn -> . Syn GT Syn  / 3
14 : Syn -> . Syn LT Syn  / 3
15 : Syn -> . Syn GEQ Syn  / 3
16 : Syn -> . Syn LEQ Syn  / 3
17 : Syn -> . Syn PLUS Syn  / 3
18 : Syn -> . Simp  / 3
19 : Syn -> . LCID Sings  / 3
20 : Syn -> . NOT Simp  / 3
21 : Syn -> . LCURLY Bind RCURLY Syn  / 3
22 : Syn -> . EX UCID PERIOD Syn  / 3
23 : Simp -> . LPAREN Syn RPAREN  / 3
24 : Simp -> . UCID  / 3
25 : Simp -> . USCORE  / 3
26 : Simp -> . WORLD  / 3
27 : Simp -> . TYPE  / 3
28 : Simp -> . REL  / 3
29 : Simp -> . NUM  / 3
30 : Simp -> . STRING  / 3

LCURLY => shift 9
LPAREN => shift 8
EX => shift 10
NOT => shift 7
WORLD => shift 6
TYPE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 12
LCID => shift 11
NUM => shift 2
STRING => shift 1
Syn => goto 56
Simp => goto 16

-----

State 36:

5 : Syn -> . LCID COLON Syn  / 3
6 : Syn -> . LCID EQ Syn  / 3
7 : Syn -> . Syn LARROW Syn  / 3
8 : Syn -> . Syn RARROW Syn  / 3
9 : Syn -> . Syn COMMA Syn  / 3
9 : Syn -> Syn COMMA . Syn  / 3
10 : Syn -> . Syn AT Syn  / 3
11 : Syn -> . Syn EQEQ Syn  / 3
12 : Syn -> . Syn NEQ Syn  / 3
13 : Syn -> . Syn GT Syn  / 3
14 : Syn -> . Syn LT Syn  / 3
15 : Syn -> . Syn GEQ Syn  / 3
16 : Syn -> . Syn LEQ Syn  / 3
17 : Syn -> . Syn PLUS Syn  / 3
18 : Syn -> . Simp  / 3
19 : Syn -> . LCID Sings  / 3
20 : Syn -> . NOT Simp  / 3
21 : Syn -> . LCURLY Bind RCURLY Syn  / 3
22 : Syn -> . EX UCID PERIOD Syn  / 3
23 : Simp -> . LPAREN Syn RPAREN  / 3
24 : Simp -> . UCID  / 3
25 : Simp -> . USCORE  / 3
26 : Simp -> . WORLD  / 3
27 : Simp -> . TYPE  / 3
28 : Simp -> . REL  / 3
29 : Simp -> . NUM  / 3
30 : Simp -> . STRING  / 3

LCURLY => shift 9
LPAREN => shift 8
EX => shift 10
NOT => shift 7
WORLD => shift 6
TYPE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 12
LCID => shift 11
NUM => shift 2
STRING => shift 1
Syn => goto 57
Simp => goto 16

-----

State 37:

5 : Syn -> . LCID COLON Syn  / 3
6 : Syn -> . LCID EQ Syn  / 3
7 : Syn -> . Syn LARROW Syn  / 3
8 : Syn -> . Syn RARROW Syn  / 3
8 : Syn -> Syn RARROW . Syn  / 3
9 : Syn -> . Syn COMMA Syn  / 3
10 : Syn -> . Syn AT Syn  / 3
11 : Syn -> . Syn EQEQ Syn  / 3
12 : Syn -> . Syn NEQ Syn  / 3
13 : Syn -> . Syn GT Syn  / 3
14 : Syn -> . Syn LT Syn  / 3
15 : Syn -> . Syn GEQ Syn  / 3
16 : Syn -> . Syn LEQ Syn  / 3
17 : Syn -> . Syn PLUS Syn  / 3
18 : Syn -> . Simp  / 3
19 : Syn -> . LCID Sings  / 3
20 : Syn -> . NOT Simp  / 3
21 : Syn -> . LCURLY Bind RCURLY Syn  / 3
22 : Syn -> . EX UCID PERIOD Syn  / 3
23 : Simp -> . LPAREN Syn RPAREN  / 3
24 : Simp -> . UCID  / 3
25 : Simp -> . USCORE  / 3
26 : Simp -> . WORLD  / 3
27 : Simp -> . TYPE  / 3
28 : Simp -> . REL  / 3
29 : Simp -> . NUM  / 3
30 : Simp -> . STRING  / 3

LCURLY => shift 9
LPAREN => shift 8
EX => shift 10
NOT => shift 7
WORLD => shift 6
TYPE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 12
LCID => shift 11
NUM => shift 2
STRING => shift 1
Syn => goto 58
Simp => goto 16

-----

State 38:

5 : Syn -> . LCID COLON Syn  / 3
6 : Syn -> . LCID EQ Syn  / 3
7 : Syn -> . Syn LARROW Syn  / 3
7 : Syn -> Syn LARROW . Syn  / 3
8 : Syn -> . Syn RARROW Syn  / 3
9 : Syn -> . Syn COMMA Syn  / 3
10 : Syn -> . Syn AT Syn  / 3
11 : Syn -> . Syn EQEQ Syn  / 3
12 : Syn -> . Syn NEQ Syn  / 3
13 : Syn -> . Syn GT Syn  / 3
14 : Syn -> . Syn LT Syn  / 3
15 : Syn -> . Syn GEQ Syn  / 3
16 : Syn -> . Syn LEQ Syn  / 3
17 : Syn -> . Syn PLUS Syn  / 3
18 : Syn -> . Simp  / 3
19 : Syn -> . LCID Sings  / 3
20 : Syn -> . NOT Simp  / 3
21 : Syn -> . LCURLY Bind RCURLY Syn  / 3
22 : Syn -> . EX UCID PERIOD Syn  / 3
23 : Simp -> . LPAREN Syn RPAREN  / 3
24 : Simp -> . UCID  / 3
25 : Simp -> . USCORE  / 3
26 : Simp -> . WORLD  / 3
27 : Simp -> . TYPE  / 3
28 : Simp -> . REL  / 3
29 : Simp -> . NUM  / 3
30 : Simp -> . STRING  / 3

LCURLY => shift 9
LPAREN => shift 8
EX => shift 10
NOT => shift 7
WORLD => shift 6
TYPE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 12
LCID => shift 11
NUM => shift 2
STRING => shift 1
Syn => goto 59
Simp => goto 16

-----

State 39:

0 : Decl -> .  / 0
1 : Decl -> . Syn PERIOD Decl  / 0
1 : Decl -> Syn PERIOD . Decl  / 0
2 : Decl -> . LANNO ANNO_QUERY LCID LCID Modes RANNO Decl  / 0
5 : Syn -> . LCID COLON Syn  / 1
6 : Syn -> . LCID EQ Syn  / 1
7 : Syn -> . Syn LARROW Syn  / 1
8 : Syn -> . Syn RARROW Syn  / 1
9 : Syn -> . Syn COMMA Syn  / 1
10 : Syn -> . Syn AT Syn  / 1
11 : Syn -> . Syn EQEQ Syn  / 1
12 : Syn -> . Syn NEQ Syn  / 1
13 : Syn -> . Syn GT Syn  / 1
14 : Syn -> . Syn LT Syn  / 1
15 : Syn -> . Syn GEQ Syn  / 1
16 : Syn -> . Syn LEQ Syn  / 1
17 : Syn -> . Syn PLUS Syn  / 1
18 : Syn -> . Simp  / 1
19 : Syn -> . LCID Sings  / 1
20 : Syn -> . NOT Simp  / 1
21 : Syn -> . LCURLY Bind RCURLY Syn  / 1
22 : Syn -> . EX UCID PERIOD Syn  / 1
23 : Simp -> . LPAREN Syn RPAREN  / 1
24 : Simp -> . UCID  / 1
25 : Simp -> . USCORE  / 1
26 : Simp -> . WORLD  / 1
27 : Simp -> . TYPE  / 1
28 : Simp -> . REL  / 1
29 : Simp -> . NUM  / 1
30 : Simp -> . STRING  / 1

$ => reduce 0
LCURLY => shift 9
LPAREN => shift 8
EX => shift 10
NOT => shift 7
WORLD => shift 6
TYPE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 12
LCID => shift 11
NUM => shift 2
STRING => shift 1
LANNO => shift 13
Decl => goto 60
Syn => goto 15
Simp => goto 16

-----

State 40:

23 : Simp -> LPAREN Syn RPAREN .  / 2

RCURLY => reduce 23
LPAREN => reduce 23
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
WORLD => reduce 23
TYPE => reduce 23
REL => reduce 23
USCORE => reduce 23
UCID => reduce 23
LCID => reduce 23
NUM => reduce 23
STRING => reduce 23

-----

State 41:

5 : Syn -> . LCID COLON Syn  / 3
6 : Syn -> . LCID EQ Syn  / 3
7 : Syn -> . Syn LARROW Syn  / 3
8 : Syn -> . Syn RARROW Syn  / 3
9 : Syn -> . Syn COMMA Syn  / 3
10 : Syn -> . Syn AT Syn  / 3
11 : Syn -> . Syn EQEQ Syn  / 3
12 : Syn -> . Syn NEQ Syn  / 3
13 : Syn -> . Syn GT Syn  / 3
14 : Syn -> . Syn LT Syn  / 3
15 : Syn -> . Syn GEQ Syn  / 3
16 : Syn -> . Syn LEQ Syn  / 3
17 : Syn -> . Syn PLUS Syn  / 3
18 : Syn -> . Simp  / 3
19 : Syn -> . LCID Sings  / 3
20 : Syn -> . NOT Simp  / 3
21 : Syn -> . LCURLY Bind RCURLY Syn  / 3
21 : Syn -> LCURLY Bind RCURLY . Syn  / 3
22 : Syn -> . EX UCID PERIOD Syn  / 3
23 : Simp -> . LPAREN Syn RPAREN  / 3
24 : Simp -> . UCID  / 3
25 : Simp -> . USCORE  / 3
26 : Simp -> . WORLD  / 3
27 : Simp -> . TYPE  / 3
28 : Simp -> . REL  / 3
29 : Simp -> . NUM  / 3
30 : Simp -> . STRING  / 3

LCURLY => shift 9
LPAREN => shift 8
EX => shift 10
NOT => shift 7
WORLD => shift 6
TYPE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 12
LCID => shift 11
NUM => shift 2
STRING => shift 1
Syn => goto 61
Simp => goto 16

-----

State 42:

4 : Bind -> UCID COLON . Syn  / 5
5 : Syn -> . LCID COLON Syn  / 6
6 : Syn -> . LCID EQ Syn  / 6
7 : Syn -> . Syn LARROW Syn  / 6
8 : Syn -> . Syn RARROW Syn  / 6
9 : Syn -> . Syn COMMA Syn  / 6
10 : Syn -> . Syn AT Syn  / 6
11 : Syn -> . Syn EQEQ Syn  / 6
12 : Syn -> . Syn NEQ Syn  / 6
13 : Syn -> . Syn GT Syn  / 6
14 : Syn -> . Syn LT Syn  / 6
15 : Syn -> . Syn GEQ Syn  / 6
16 : Syn -> . Syn LEQ Syn  / 6
17 : Syn -> . Syn PLUS Syn  / 6
18 : Syn -> . Simp  / 6
19 : Syn -> . LCID Sings  / 6
20 : Syn -> . NOT Simp  / 6
21 : Syn -> . LCURLY Bind RCURLY Syn  / 6
22 : Syn -> . EX UCID PERIOD Syn  / 6
23 : Simp -> . LPAREN Syn RPAREN  / 6
24 : Simp -> . UCID  / 6
25 : Simp -> . USCORE  / 6
26 : Simp -> . WORLD  / 6
27 : Simp -> . TYPE  / 6
28 : Simp -> . REL  / 6
29 : Simp -> . NUM  / 6
30 : Simp -> . STRING  / 6

LCURLY => shift 9
LPAREN => shift 8
EX => shift 10
NOT => shift 7
WORLD => shift 6
TYPE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 12
LCID => shift 11
NUM => shift 2
STRING => shift 1
Syn => goto 62
Simp => goto 16

-----

State 43:

5 : Syn -> . LCID COLON Syn  / 3
6 : Syn -> . LCID EQ Syn  / 3
7 : Syn -> . Syn LARROW Syn  / 3
8 : Syn -> . Syn RARROW Syn  / 3
9 : Syn -> . Syn COMMA Syn  / 3
10 : Syn -> . Syn AT Syn  / 3
11 : Syn -> . Syn EQEQ Syn  / 3
12 : Syn -> . Syn NEQ Syn  / 3
13 : Syn -> . Syn GT Syn  / 3
14 : Syn -> . Syn LT Syn  / 3
15 : Syn -> . Syn GEQ Syn  / 3
16 : Syn -> . Syn LEQ Syn  / 3
17 : Syn -> . Syn PLUS Syn  / 3
18 : Syn -> . Simp  / 3
19 : Syn -> . LCID Sings  / 3
20 : Syn -> . NOT Simp  / 3
21 : Syn -> . LCURLY Bind RCURLY Syn  / 3
22 : Syn -> . EX UCID PERIOD Syn  / 3
22 : Syn -> EX UCID PERIOD . Syn  / 3
23 : Simp -> . LPAREN Syn RPAREN  / 3
24 : Simp -> . UCID  / 3
25 : Simp -> . USCORE  / 3
26 : Simp -> . WORLD  / 3
27 : Simp -> . TYPE  / 3
28 : Simp -> . REL  / 3
29 : Simp -> . NUM  / 3
30 : Simp -> . STRING  / 3

LCURLY => shift 9
LPAREN => shift 8
EX => shift 10
NOT => shift 7
WORLD => shift 6
TYPE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 12
LCID => shift 11
NUM => shift 2
STRING => shift 1
Syn => goto 63
Simp => goto 16

-----

State 44:

33 : Sings -> LCID Sings .  / 3

RCURLY => reduce 33
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

-----

State 45:

6 : Syn -> LCID EQ Syn .  / 3
7 : Syn -> Syn . LARROW Syn  / 3
8 : Syn -> Syn . RARROW Syn  / 3
9 : Syn -> Syn . COMMA Syn  / 3
10 : Syn -> Syn . AT Syn  / 3
11 : Syn -> Syn . EQEQ Syn  / 3
12 : Syn -> Syn . NEQ Syn  / 3
13 : Syn -> Syn . GT Syn  / 3
14 : Syn -> Syn . LT Syn  / 3
15 : Syn -> Syn . GEQ Syn  / 3
16 : Syn -> Syn . LEQ Syn  / 3
17 : Syn -> Syn . PLUS Syn  / 3

RCURLY => reduce 6
RPAREN => reduce 6
PERIOD => reduce 6
LARROW => shift 38, reduce 6  PRECEDENCE
RARROW => shift 37, reduce 6  PRECEDENCE
COMMA => shift 36, reduce 6  PRECEDENCE
AT => shift 35, reduce 6  PRECEDENCE
EQEQ => shift 34, reduce 6  PRECEDENCE
NEQ => shift 33, reduce 6  PRECEDENCE
GT => shift 32, reduce 6  PRECEDENCE
LT => shift 31, reduce 6  PRECEDENCE
GEQ => shift 30, reduce 6  PRECEDENCE
LEQ => shift 29, reduce 6  PRECEDENCE
PLUS => shift 28, reduce 6  PRECEDENCE

-----

State 46:

5 : Syn -> LCID COLON Syn .  / 3
7 : Syn -> Syn . LARROW Syn  / 3
8 : Syn -> Syn . RARROW Syn  / 3
9 : Syn -> Syn . COMMA Syn  / 3
10 : Syn -> Syn . AT Syn  / 3
11 : Syn -> Syn . EQEQ Syn  / 3
12 : Syn -> Syn . NEQ Syn  / 3
13 : Syn -> Syn . GT Syn  / 3
14 : Syn -> Syn . LT Syn  / 3
15 : Syn -> Syn . GEQ Syn  / 3
16 : Syn -> Syn . LEQ Syn  / 3
17 : Syn -> Syn . PLUS Syn  / 3

RCURLY => reduce 5
RPAREN => reduce 5
PERIOD => reduce 5
LARROW => shift 38, reduce 5  PRECEDENCE
RARROW => shift 37, reduce 5  PRECEDENCE
COMMA => shift 36, reduce 5  PRECEDENCE
AT => shift 35, reduce 5  PRECEDENCE
EQEQ => shift 34, reduce 5  PRECEDENCE
NEQ => shift 33, reduce 5  PRECEDENCE
GT => shift 32, reduce 5  PRECEDENCE
LT => shift 31, reduce 5  PRECEDENCE
GEQ => shift 30, reduce 5  PRECEDENCE
LEQ => shift 29, reduce 5  PRECEDENCE
PLUS => shift 28, reduce 5  PRECEDENCE

-----

State 47:

32 : Sings -> Simp Sings .  / 3

RCURLY => reduce 32
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

-----

State 48:

2 : Decl -> LANNO ANNO_QUERY LCID . LCID Modes RANNO Decl  / 0

LCID => shift 64

-----

State 49:

7 : Syn -> Syn . LARROW Syn  / 3
8 : Syn -> Syn . RARROW Syn  / 3
9 : Syn -> Syn . COMMA Syn  / 3
10 : Syn -> Syn . AT Syn  / 3
11 : Syn -> Syn . EQEQ Syn  / 3
12 : Syn -> Syn . NEQ Syn  / 3
13 : Syn -> Syn . GT Syn  / 3
14 : Syn -> Syn . LT Syn  / 3
15 : Syn -> Syn . GEQ Syn  / 3
16 : Syn -> Syn . LEQ Syn  / 3
17 : Syn -> Syn . PLUS Syn  / 3
17 : Syn -> Syn PLUS Syn .  / 3

RCURLY => reduce 17
RPAREN => reduce 17
PERIOD => reduce 17
LARROW => reduce 17, shift 38  PRECEDENCE
RARROW => reduce 17, shift 37  PRECEDENCE
COMMA => reduce 17, shift 36  PRECEDENCE
AT => reduce 17, shift 35  PRECEDENCE
EQEQ => reduce 17, shift 34  PRECEDENCE
NEQ => reduce 17, shift 33  PRECEDENCE
GT => reduce 17, shift 32  PRECEDENCE
LT => reduce 17, shift 31  PRECEDENCE
GEQ => reduce 17, shift 30  PRECEDENCE
LEQ => reduce 17, shift 29  PRECEDENCE
PLUS => reduce 17, shift 28  PRECEDENCE

-----

State 50:

7 : Syn -> Syn . LARROW Syn  / 3
8 : Syn -> Syn . RARROW Syn  / 3
9 : Syn -> Syn . COMMA Syn  / 3
10 : Syn -> Syn . AT Syn  / 3
11 : Syn -> Syn . EQEQ Syn  / 3
12 : Syn -> Syn . NEQ Syn  / 3
13 : Syn -> Syn . GT Syn  / 3
14 : Syn -> Syn . LT Syn  / 3
15 : Syn -> Syn . GEQ Syn  / 3
16 : Syn -> Syn . LEQ Syn  / 3
16 : Syn -> Syn LEQ Syn .  / 3
17 : Syn -> Syn . PLUS Syn  / 3

RCURLY => reduce 16
RPAREN => reduce 16
PERIOD => reduce 16
LARROW => reduce 16, shift 38  PRECEDENCE
RARROW => reduce 16, shift 37  PRECEDENCE
COMMA => reduce 16, shift 36  PRECEDENCE
AT => reduce 16, shift 35  PRECEDENCE
EQEQ => reduce 16, shift 34  PRECEDENCE
NEQ => reduce 16, shift 33  PRECEDENCE
GT => reduce 16, shift 32  PRECEDENCE
LT => reduce 16, shift 31  PRECEDENCE
GEQ => reduce 16, shift 30  PRECEDENCE
LEQ => reduce 16, shift 29  PRECEDENCE
PLUS => shift 28, reduce 16  PRECEDENCE

-----

State 51:

7 : Syn -> Syn . LARROW Syn  / 3
8 : Syn -> Syn . RARROW Syn  / 3
9 : Syn -> Syn . COMMA Syn  / 3
10 : Syn -> Syn . AT Syn  / 3
11 : Syn -> Syn . EQEQ Syn  / 3
12 : Syn -> Syn . NEQ Syn  / 3
13 : Syn -> Syn . GT Syn  / 3
14 : Syn -> Syn . LT Syn  / 3
15 : Syn -> Syn . GEQ Syn  / 3
15 : Syn -> Syn GEQ Syn .  / 3
16 : Syn -> Syn . LEQ Syn  / 3
17 : Syn -> Syn . PLUS Syn  / 3

RCURLY => reduce 15
RPAREN => reduce 15
PERIOD => reduce 15
LARROW => reduce 15, shift 38  PRECEDENCE
RARROW => reduce 15, shift 37  PRECEDENCE
COMMA => reduce 15, shift 36  PRECEDENCE
AT => reduce 15, shift 35  PRECEDENCE
EQEQ => reduce 15, shift 34  PRECEDENCE
NEQ => reduce 15, shift 33  PRECEDENCE
GT => reduce 15, shift 32  PRECEDENCE
LT => reduce 15, shift 31  PRECEDENCE
GEQ => reduce 15, shift 30  PRECEDENCE
LEQ => reduce 15, shift 29  PRECEDENCE
PLUS => shift 28, reduce 15  PRECEDENCE

-----

State 52:

7 : Syn -> Syn . LARROW Syn  / 3
8 : Syn -> Syn . RARROW Syn  / 3
9 : Syn -> Syn . COMMA Syn  / 3
10 : Syn -> Syn . AT Syn  / 3
11 : Syn -> Syn . EQEQ Syn  / 3
12 : Syn -> Syn . NEQ Syn  / 3
13 : Syn -> Syn . GT Syn  / 3
14 : Syn -> Syn . LT Syn  / 3
14 : Syn -> Syn LT Syn .  / 3
15 : Syn -> Syn . GEQ Syn  / 3
16 : Syn -> Syn . LEQ Syn  / 3
17 : Syn -> Syn . PLUS Syn  / 3

RCURLY => reduce 14
RPAREN => reduce 14
PERIOD => reduce 14
LARROW => reduce 14, shift 38  PRECEDENCE
RARROW => reduce 14, shift 37  PRECEDENCE
COMMA => reduce 14, shift 36  PRECEDENCE
AT => reduce 14, shift 35  PRECEDENCE
EQEQ => reduce 14, shift 34  PRECEDENCE
NEQ => reduce 14, shift 33  PRECEDENCE
GT => reduce 14, shift 32  PRECEDENCE
LT => reduce 14, shift 31  PRECEDENCE
GEQ => reduce 14, shift 30  PRECEDENCE
LEQ => reduce 14, shift 29  PRECEDENCE
PLUS => shift 28, reduce 14  PRECEDENCE

-----

State 53:

7 : Syn -> Syn . LARROW Syn  / 3
8 : Syn -> Syn . RARROW Syn  / 3
9 : Syn -> Syn . COMMA Syn  / 3
10 : Syn -> Syn . AT Syn  / 3
11 : Syn -> Syn . EQEQ Syn  / 3
12 : Syn -> Syn . NEQ Syn  / 3
13 : Syn -> Syn . GT Syn  / 3
13 : Syn -> Syn GT Syn .  / 3
14 : Syn -> Syn . LT Syn  / 3
15 : Syn -> Syn . GEQ Syn  / 3
16 : Syn -> Syn . LEQ Syn  / 3
17 : Syn -> Syn . PLUS Syn  / 3

RCURLY => reduce 13
RPAREN => reduce 13
PERIOD => reduce 13
LARROW => reduce 13, shift 38  PRECEDENCE
RARROW => reduce 13, shift 37  PRECEDENCE
COMMA => reduce 13, shift 36  PRECEDENCE
AT => reduce 13, shift 35  PRECEDENCE
EQEQ => reduce 13, shift 34  PRECEDENCE
NEQ => reduce 13, shift 33  PRECEDENCE
GT => reduce 13, shift 32  PRECEDENCE
LT => reduce 13, shift 31  PRECEDENCE
GEQ => reduce 13, shift 30  PRECEDENCE
LEQ => reduce 13, shift 29  PRECEDENCE
PLUS => shift 28, reduce 13  PRECEDENCE

-----

State 54:

7 : Syn -> Syn . LARROW Syn  / 3
8 : Syn -> Syn . RARROW Syn  / 3
9 : Syn -> Syn . COMMA Syn  / 3
10 : Syn -> Syn . AT Syn  / 3
11 : Syn -> Syn . EQEQ Syn  / 3
12 : Syn -> Syn . NEQ Syn  / 3
12 : Syn -> Syn NEQ Syn .  / 3
13 : Syn -> Syn . GT Syn  / 3
14 : Syn -> Syn . LT Syn  / 3
15 : Syn -> Syn . GEQ Syn  / 3
16 : Syn -> Syn . LEQ Syn  / 3
17 : Syn -> Syn . PLUS Syn  / 3

RCURLY => reduce 12
RPAREN => reduce 12
PERIOD => reduce 12
LARROW => reduce 12, shift 38  PRECEDENCE
RARROW => reduce 12, shift 37  PRECEDENCE
COMMA => reduce 12, shift 36  PRECEDENCE
AT => reduce 12, shift 35  PRECEDENCE
EQEQ => reduce 12, shift 34  PRECEDENCE
NEQ => reduce 12, shift 33  PRECEDENCE
GT => reduce 12, shift 32  PRECEDENCE
LT => reduce 12, shift 31  PRECEDENCE
GEQ => reduce 12, shift 30  PRECEDENCE
LEQ => reduce 12, shift 29  PRECEDENCE
PLUS => shift 28, reduce 12  PRECEDENCE

-----

State 55:

7 : Syn -> Syn . LARROW Syn  / 3
8 : Syn -> Syn . RARROW Syn  / 3
9 : Syn -> Syn . COMMA Syn  / 3
10 : Syn -> Syn . AT Syn  / 3
11 : Syn -> Syn . EQEQ Syn  / 3
11 : Syn -> Syn EQEQ Syn .  / 3
12 : Syn -> Syn . NEQ Syn  / 3
13 : Syn -> Syn . GT Syn  / 3
14 : Syn -> Syn . LT Syn  / 3
15 : Syn -> Syn . GEQ Syn  / 3
16 : Syn -> Syn . LEQ Syn  / 3
17 : Syn -> Syn . PLUS Syn  / 3

RCURLY => reduce 11
RPAREN => reduce 11
PERIOD => reduce 11
LARROW => reduce 11, shift 38  PRECEDENCE
RARROW => reduce 11, shift 37  PRECEDENCE
COMMA => reduce 11, shift 36  PRECEDENCE
AT => reduce 11, shift 35  PRECEDENCE
EQEQ => reduce 11, shift 34  PRECEDENCE
NEQ => reduce 11, shift 33  PRECEDENCE
GT => reduce 11, shift 32  PRECEDENCE
LT => reduce 11, shift 31  PRECEDENCE
GEQ => reduce 11, shift 30  PRECEDENCE
LEQ => reduce 11, shift 29  PRECEDENCE
PLUS => shift 28, reduce 11  PRECEDENCE

-----

State 56:

7 : Syn -> Syn . LARROW Syn  / 3
8 : Syn -> Syn . RARROW Syn  / 3
9 : Syn -> Syn . COMMA Syn  / 3
10 : Syn -> Syn . AT Syn  / 3
10 : Syn -> Syn AT Syn .  / 3
11 : Syn -> Syn . EQEQ Syn  / 3
12 : Syn -> Syn . NEQ Syn  / 3
13 : Syn -> Syn . GT Syn  / 3
14 : Syn -> Syn . LT Syn  / 3
15 : Syn -> Syn . GEQ Syn  / 3
16 : Syn -> Syn . LEQ Syn  / 3
17 : Syn -> Syn . PLUS Syn  / 3

RCURLY => reduce 10
RPAREN => reduce 10
PERIOD => reduce 10
LARROW => reduce 10, shift 38  PRECEDENCE
RARROW => reduce 10, shift 37  PRECEDENCE
COMMA => reduce 10, shift 36  PRECEDENCE
AT => reduce 10, shift 35  PRECEDENCE
EQEQ => shift 34, reduce 10  PRECEDENCE
NEQ => shift 33, reduce 10  PRECEDENCE
GT => shift 32, reduce 10  PRECEDENCE
LT => shift 31, reduce 10  PRECEDENCE
GEQ => shift 30, reduce 10  PRECEDENCE
LEQ => shift 29, reduce 10  PRECEDENCE
PLUS => shift 28, reduce 10  PRECEDENCE

-----

State 57:

7 : Syn -> Syn . LARROW Syn  / 3
8 : Syn -> Syn . RARROW Syn  / 3
9 : Syn -> Syn . COMMA Syn  / 3
9 : Syn -> Syn COMMA Syn .  / 3
10 : Syn -> Syn . AT Syn  / 3
11 : Syn -> Syn . EQEQ Syn  / 3
12 : Syn -> Syn . NEQ Syn  / 3
13 : Syn -> Syn . GT Syn  / 3
14 : Syn -> Syn . LT Syn  / 3
15 : Syn -> Syn . GEQ Syn  / 3
16 : Syn -> Syn . LEQ Syn  / 3
17 : Syn -> Syn . PLUS Syn  / 3

RCURLY => reduce 9
RPAREN => reduce 9
PERIOD => reduce 9
LARROW => reduce 9, shift 38  PRECEDENCE
RARROW => reduce 9, shift 37  PRECEDENCE
COMMA => reduce 9, shift 36  PRECEDENCE
AT => shift 35, reduce 9  PRECEDENCE
EQEQ => shift 34, reduce 9  PRECEDENCE
NEQ => shift 33, reduce 9  PRECEDENCE
GT => shift 32, reduce 9  PRECEDENCE
LT => shift 31, reduce 9  PRECEDENCE
GEQ => shift 30, reduce 9  PRECEDENCE
LEQ => shift 29, reduce 9  PRECEDENCE
PLUS => shift 28, reduce 9  PRECEDENCE

-----

State 58:

7 : Syn -> Syn . LARROW Syn  / 3
8 : Syn -> Syn . RARROW Syn  / 3
8 : Syn -> Syn RARROW Syn .  / 3
9 : Syn -> Syn . COMMA Syn  / 3
10 : Syn -> Syn . AT Syn  / 3
11 : Syn -> Syn . EQEQ Syn  / 3
12 : Syn -> Syn . NEQ Syn  / 3
13 : Syn -> Syn . GT Syn  / 3
14 : Syn -> Syn . LT Syn  / 3
15 : Syn -> Syn . GEQ Syn  / 3
16 : Syn -> Syn . LEQ Syn  / 3
17 : Syn -> Syn . PLUS Syn  / 3

RCURLY => reduce 8
RPAREN => reduce 8
PERIOD => reduce 8
LARROW => reduce 8, shift 38  PRECEDENCE
RARROW => shift 37, reduce 8  PRECEDENCE
COMMA => shift 36, reduce 8  PRECEDENCE
AT => shift 35, reduce 8  PRECEDENCE
EQEQ => shift 34, reduce 8  PRECEDENCE
NEQ => shift 33, reduce 8  PRECEDENCE
GT => shift 32, reduce 8  PRECEDENCE
LT => shift 31, reduce 8  PRECEDENCE
GEQ => shift 30, reduce 8  PRECEDENCE
LEQ => shift 29, reduce 8  PRECEDENCE
PLUS => shift 28, reduce 8  PRECEDENCE

-----

State 59:

7 : Syn -> Syn . LARROW Syn  / 3
7 : Syn -> Syn LARROW Syn .  / 3
8 : Syn -> Syn . RARROW Syn  / 3
9 : Syn -> Syn . COMMA Syn  / 3
10 : Syn -> Syn . AT Syn  / 3
11 : Syn -> Syn . EQEQ Syn  / 3
12 : Syn -> Syn . NEQ Syn  / 3
13 : Syn -> Syn . GT Syn  / 3
14 : Syn -> Syn . LT Syn  / 3
15 : Syn -> Syn . GEQ Syn  / 3
16 : Syn -> Syn . LEQ Syn  / 3
17 : Syn -> Syn . PLUS Syn  / 3

RCURLY => reduce 7
RPAREN => reduce 7
PERIOD => reduce 7
LARROW => reduce 7, shift 38  PRECEDENCE
RARROW => shift 37, reduce 7  PRECEDENCE
COMMA => shift 36, reduce 7  PRECEDENCE
AT => shift 35, reduce 7  PRECEDENCE
EQEQ => shift 34, reduce 7  PRECEDENCE
NEQ => shift 33, reduce 7  PRECEDENCE
GT => shift 32, reduce 7  PRECEDENCE
LT => shift 31, reduce 7  PRECEDENCE
GEQ => shift 30, reduce 7  PRECEDENCE
LEQ => shift 29, reduce 7  PRECEDENCE
PLUS => shift 28, reduce 7  PRECEDENCE

-----

State 60:

1 : Decl -> Syn PERIOD Decl .  / 0

$ => reduce 1

-----

State 61:

7 : Syn -> Syn . LARROW Syn  / 3
8 : Syn -> Syn . RARROW Syn  / 3
9 : Syn -> Syn . COMMA Syn  / 3
10 : Syn -> Syn . AT Syn  / 3
11 : Syn -> Syn . EQEQ Syn  / 3
12 : Syn -> Syn . NEQ Syn  / 3
13 : Syn -> Syn . GT Syn  / 3
14 : Syn -> Syn . LT Syn  / 3
15 : Syn -> Syn . GEQ Syn  / 3
16 : Syn -> Syn . LEQ Syn  / 3
17 : Syn -> Syn . PLUS Syn  / 3
21 : Syn -> LCURLY Bind RCURLY Syn .  / 3

RCURLY => reduce 21
RPAREN => reduce 21
PERIOD => reduce 21
LARROW => shift 38, reduce 21  PRECEDENCE
RARROW => shift 37, reduce 21  PRECEDENCE
COMMA => shift 36, reduce 21  PRECEDENCE
AT => shift 35, reduce 21  PRECEDENCE
EQEQ => shift 34, reduce 21  PRECEDENCE
NEQ => shift 33, reduce 21  PRECEDENCE
GT => shift 32, reduce 21  PRECEDENCE
LT => shift 31, reduce 21  PRECEDENCE
GEQ => shift 30, reduce 21  PRECEDENCE
LEQ => shift 29, reduce 21  PRECEDENCE
PLUS => shift 28, reduce 21  PRECEDENCE

-----

State 62:

4 : Bind -> UCID COLON Syn .  / 5
7 : Syn -> Syn . LARROW Syn  / 6
8 : Syn -> Syn . RARROW Syn  / 6
9 : Syn -> Syn . COMMA Syn  / 6
10 : Syn -> Syn . AT Syn  / 6
11 : Syn -> Syn . EQEQ Syn  / 6
12 : Syn -> Syn . NEQ Syn  / 6
13 : Syn -> Syn . GT Syn  / 6
14 : Syn -> Syn . LT Syn  / 6
15 : Syn -> Syn . GEQ Syn  / 6
16 : Syn -> Syn . LEQ Syn  / 6
17 : Syn -> Syn . PLUS Syn  / 6

RCURLY => reduce 4
LARROW => shift 38
RARROW => shift 37
COMMA => shift 36
AT => shift 35
EQEQ => shift 34
NEQ => shift 33
GT => shift 32
LT => shift 31
GEQ => shift 30
LEQ => shift 29
PLUS => shift 28

-----

State 63:

7 : Syn -> Syn . LARROW Syn  / 3
8 : Syn -> Syn . RARROW Syn  / 3
9 : Syn -> Syn . COMMA Syn  / 3
10 : Syn -> Syn . AT Syn  / 3
11 : Syn -> Syn . EQEQ Syn  / 3
12 : Syn -> Syn . NEQ Syn  / 3
13 : Syn -> Syn . GT Syn  / 3
14 : Syn -> Syn . LT Syn  / 3
15 : Syn -> Syn . GEQ Syn  / 3
16 : Syn -> Syn . LEQ Syn  / 3
17 : Syn -> Syn . PLUS Syn  / 3
22 : Syn -> EX UCID PERIOD Syn .  / 3

RCURLY => reduce 22
RPAREN => reduce 22
PERIOD => reduce 22
LARROW => shift 38, reduce 22  PRECEDENCE
RARROW => shift 37, reduce 22  PRECEDENCE
COMMA => shift 36, reduce 22  PRECEDENCE
AT => shift 35, reduce 22  PRECEDENCE
EQEQ => shift 34, reduce 22  PRECEDENCE
NEQ => shift 33, reduce 22  PRECEDENCE
GT => shift 32, reduce 22  PRECEDENCE
LT => shift 31, reduce 22  PRECEDENCE
GEQ => shift 30, reduce 22  PRECEDENCE
LEQ => shift 29, reduce 22  PRECEDENCE
PLUS => shift 28, reduce 22  PRECEDENCE

-----

State 64:

2 : Decl -> LANNO ANNO_QUERY LCID LCID . Modes RANNO Decl  / 0
34 : Modes -> .  / 7
35 : Modes -> . PLUS Modes  / 7
36 : Modes -> . MINUS Modes  / 7
37 : Modes -> . USCORE Modes  / 7

PLUS => shift 67
MINUS => shift 66
USCORE => shift 65
RANNO => reduce 34
Modes => goto 68

-----

State 65:

34 : Modes -> .  / 7
35 : Modes -> . PLUS Modes  / 7
36 : Modes -> . MINUS Modes  / 7
37 : Modes -> . USCORE Modes  / 7
37 : Modes -> USCORE . Modes  / 7

PLUS => shift 67
MINUS => shift 66
USCORE => shift 65
RANNO => reduce 34
Modes => goto 69

-----

State 66:

34 : Modes -> .  / 7
35 : Modes -> . PLUS Modes  / 7
36 : Modes -> . MINUS Modes  / 7
36 : Modes -> MINUS . Modes  / 7
37 : Modes -> . USCORE Modes  / 7

PLUS => shift 67
MINUS => shift 66
USCORE => shift 65
RANNO => reduce 34
Modes => goto 70

-----

State 67:

34 : Modes -> .  / 7
35 : Modes -> . PLUS Modes  / 7
35 : Modes -> PLUS . Modes  / 7
36 : Modes -> . MINUS Modes  / 7
37 : Modes -> . USCORE Modes  / 7

PLUS => shift 67
MINUS => shift 66
USCORE => shift 65
RANNO => reduce 34
Modes => goto 71

-----

State 68:

2 : Decl -> LANNO ANNO_QUERY LCID LCID Modes . RANNO Decl  / 0

RANNO => shift 72

-----

State 69:

37 : Modes -> USCORE Modes .  / 7

RANNO => reduce 37

-----

State 70:

36 : Modes -> MINUS Modes .  / 7

RANNO => reduce 36

-----

State 71:

35 : Modes -> PLUS Modes .  / 7

RANNO => reduce 35

-----

State 72:

0 : Decl -> .  / 0
1 : Decl -> . Syn PERIOD Decl  / 0
2 : Decl -> . LANNO ANNO_QUERY LCID LCID Modes RANNO Decl  / 0
2 : Decl -> LANNO ANNO_QUERY LCID LCID Modes RANNO . Decl  / 0
5 : Syn -> . LCID COLON Syn  / 1
6 : Syn -> . LCID EQ Syn  / 1
7 : Syn -> . Syn LARROW Syn  / 1
8 : Syn -> . Syn RARROW Syn  / 1
9 : Syn -> . Syn COMMA Syn  / 1
10 : Syn -> . Syn AT Syn  / 1
11 : Syn -> . Syn EQEQ Syn  / 1
12 : Syn -> . Syn NEQ Syn  / 1
13 : Syn -> . Syn GT Syn  / 1
14 : Syn -> . Syn LT Syn  / 1
15 : Syn -> . Syn GEQ Syn  / 1
16 : Syn -> . Syn LEQ Syn  / 1
17 : Syn -> . Syn PLUS Syn  / 1
18 : Syn -> . Simp  / 1
19 : Syn -> . LCID Sings  / 1
20 : Syn -> . NOT Simp  / 1
21 : Syn -> . LCURLY Bind RCURLY Syn  / 1
22 : Syn -> . EX UCID PERIOD Syn  / 1
23 : Simp -> . LPAREN Syn RPAREN  / 1
24 : Simp -> . UCID  / 1
25 : Simp -> . USCORE  / 1
26 : Simp -> . WORLD  / 1
27 : Simp -> . TYPE  / 1
28 : Simp -> . REL  / 1
29 : Simp -> . NUM  / 1
30 : Simp -> . STRING  / 1

$ => reduce 0
LCURLY => shift 9
LPAREN => shift 8
EX => shift 10
NOT => shift 7
WORLD => shift 6
TYPE => shift 5
REL => shift 4
USCORE => shift 3
UCID => shift 12
LCID => shift 11
NUM => shift 2
STRING => shift 1
LANNO => shift 13
Decl => goto 73
Syn => goto 15
Simp => goto 16

-----

State 73:

2 : Decl -> LANNO ANNO_QUERY LCID LCID Modes RANNO Decl .  / 0

$ => reduce 2

-----

lookahead 0 = $ 
lookahead 1 = PERIOD LARROW RARROW COMMA AT EQEQ NEQ GT LT GEQ LEQ PLUS 
lookahead 2 = RCURLY LPAREN RPAREN PERIOD LARROW RARROW COMMA AT EQEQ NEQ GT LT GEQ LEQ PLUS WORLD TYPE REL USCORE UCID LCID NUM STRING 
lookahead 3 = RCURLY RPAREN PERIOD LARROW RARROW COMMA AT EQEQ NEQ GT LT GEQ LEQ PLUS 
lookahead 4 = RPAREN LARROW RARROW COMMA AT EQEQ NEQ GT LT GEQ LEQ PLUS 
lookahead 5 = RCURLY 
lookahead 6 = RCURLY LARROW RARROW COMMA AT EQEQ NEQ GT LT GEQ LEQ PLUS 
lookahead 7 = RANNO 

*)

functor L10Parse (structure Streamable : STREAMABLE
structure Arg : sig
type pos
type pos_str
type pos_int
type decl
type syn
type sings
type modes
val Done : {} -> decl
val Syn : {1:syn, 2:pos, 3:decl} -> decl
val Query : {1:pos, 2:pos_str, 3:pos_str, 4:modes, 5:pos, 6:decl} -> decl
val Ucid : pos_str -> syn
val ascribe_ucid : {1:pos_str, 2:syn} -> syn
val Ascribe : {1:pos_str, 2:syn} -> syn
val Assign : {1:pos_str, 2:syn} -> syn
val larrow : {1:syn, 2:syn} -> syn
val Arrow : {1:syn, 2:syn} -> syn
val Conj : {1:syn, 2:syn} -> syn
val At : {1:syn, 2:syn} -> syn
val eqeq : {1:syn, 2:syn} -> syn
val neq : {1:syn, 2:syn} -> syn
val gt : {1:syn, 2:syn} -> syn
val lt : {1:syn, 2:syn} -> syn
val geq : {1:syn, 2:syn} -> syn
val leq : {1:syn, 2:syn} -> syn
val plus : {1:syn, 2:syn} -> syn
val id1 : syn -> syn
val App : {1:pos_str, 2:sings} -> syn
val Not : {1:pos, 2:syn} -> syn
val Pi : {1:pos, 2:syn, 3:pos, 4:syn} -> syn
val Ex : {1:pos, 2:pos_str, 3:syn} -> syn
val id2 : {1:pos, 2:syn, 3:pos} -> syn
val Var : pos_str -> syn
val Uscore : pos -> syn
val World : pos -> syn
val Type : pos -> syn
val Rel : pos -> syn
val Num : pos_int -> syn
val String : pos_str -> syn
val sings_end : {} -> sings
val sings_cons : {1:syn, 2:sings} -> sings
val sings_lcid : {1:pos_str, 2:sings} -> sings
val mode_end : {} -> modes
val mode_input : modes -> modes
val mode_output : modes -> modes
val mode_ignore : modes -> modes
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
| REL of pos
| USCORE of pos
| UCID of pos_str
| LCID of pos_str
| NUM of pos_int
| STRING of pos_str
| LANNO of pos
| RANNO of pos
| ANNO_QUERY of pos
val error : terminal Streamable.t -> exn
end)
=
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
| Arg.REL x => (24, Value.pos x)
| Arg.USCORE x => (25, Value.pos x)
| Arg.UCID x => (26, Value.pos_str x)
| Arg.LCID x => (27, Value.pos_str x)
| Arg.NUM x => (28, Value.pos_int x)
| Arg.STRING x => (29, Value.pos_str x)
| Arg.LANNO x => (30, Value.pos x)
| Arg.RANNO x => (31, Value.pos x)
| Arg.ANNO_QUERY x => (32, Value.pos x)
)
)
in
val parse = ParseEngine.parse (
ParseEngine.next6x1 "~\138\128\137\128\139\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\136\135\134\133\132\141\140\131\130\142\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128```\128`\128\128```````````\128\128````````\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128aaa\128a\128\128aaaaaaaaaaa\128\128aaaaaaaa\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128eee\128e\128\128eeeeeeeeeee\128\128eeeeeeee\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128bbb\128b\128\128bbbbbbbbbbb\128\128bbbbbbbb\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128ccc\128c\128\128ccccccccccc\128\128cccccccc\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128ddd\128d\128\128ddddddddddd\128\128dddddddd\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\137\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\135\134\133\132\141\128\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\138\128\137\128\139\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\136\135\134\133\132\141\140\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\149\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\150\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128_\137_\128_\153\152___________\128\128\135\134\133\132\141\151\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128fff\128f\128\128fffffffffff\128\128ffffffff\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\156\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\127\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\168\128\128\167\166\165\164\163\162\161\160\159\158\157\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128l\128l\128l\128\128lllllllllll\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128j\128j\128j\128\128jjjjjjjjjjj\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\169\128\128\128\128\167\166\165\164\163\162\161\160\159\158\157\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\170\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128{\128\128\128\128\171\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\172\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128_\137_\128_\128\128___________\128\128\135\134\133\132\141\151\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\138\128\137\128\139\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\136\135\134\133\132\141\140\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\138\128\137\128\139\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\136\135\134\133\132\141\140\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128_\137_\128_\128\128___________\128\128\135\134\133\132\141\151\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128k\128k\128k\128\128kkkkkkkkkkk\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\177\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\138\128\137\128\139\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\136\135\134\133\132\141\140\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\138\128\137\128\139\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\136\135\134\133\132\141\140\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\138\128\137\128\139\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\136\135\134\133\132\141\140\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\138\128\137\128\139\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\136\135\134\133\132\141\140\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\138\128\137\128\139\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\136\135\134\133\132\141\140\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\138\128\137\128\139\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\136\135\134\133\132\141\140\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\138\128\137\128\139\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\136\135\134\133\132\141\140\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\138\128\137\128\139\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\136\135\134\133\132\141\140\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\138\128\137\128\139\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\136\135\134\133\132\141\140\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\138\128\137\128\139\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\136\135\134\133\132\141\140\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\138\128\137\128\139\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\136\135\134\133\132\141\140\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128~\138\128\137\128\139\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\136\135\134\133\132\141\140\131\130\142\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128ggg\128g\128\128ggggggggggg\128\128gggggggg\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\138\128\137\128\139\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\136\135\134\133\132\141\140\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\138\128\137\128\139\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\136\135\134\133\132\141\140\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\138\128\137\128\139\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\136\135\134\133\132\141\140\131\130\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128]\128]\128]\128\128]]]]]]]]]]]\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128x\128x\128x\128\128\167\166\165\164\163\162\161\160\159\158\157\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128y\128y\128y\128\128\167\166\165\164\163\162\161\160\159\158\157\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128^\128^\128^\128\128^^^^^^^^^^^\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\193\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128m\128m\128m\128\128mmmmmmmmmmm\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128n\128n\128n\128\128nnnnnnnnnn\157\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128o\128o\128o\128\128oooooooooo\157\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128p\128p\128p\128\128pppppppppp\157\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128q\128q\128q\128\128qqqqqqqqqq\157\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128r\128r\128r\128\128rrrrrrrrrr\157\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128s\128s\128s\128\128ssssssssss\157\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128t\128t\128t\128\128tttt\163\162\161\160\159\158\157\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128u\128u\128u\128\128uuu\164\163\162\161\160\159\158\157\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128v\128v\128v\128\128v\166\165\164\163\162\161\160\159\158\157\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128w\128w\128w\128\128w\166\165\164\163\162\161\160\159\158\157\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128}\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128i\128i\128i\128\128\167\166\165\164\163\162\161\160\159\158\157\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128z\128\128\128\128\128\128\167\166\165\164\163\162\161\160\159\158\157\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128h\128h\128h\128\128\167\166\165\164\163\162\161\160\159\158\157\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\196\195\128\128\128\128\194\128\128\128\128\128\\\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\196\195\128\128\128\128\194\128\128\128\128\128\\\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\196\195\128\128\128\128\194\128\128\128\128\128\\\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\196\195\128\128\128\128\194\128\128\128\128\128\\\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\201\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128Y\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128Z\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128[\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128~\138\128\137\128\139\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\136\135\134\133\132\141\140\131\130\142\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128|\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128",
ParseEngine.next6x1 "\142\143\128\128\144\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\145\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\146\128\128\144\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\147\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\153\154\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\153\172\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\173\128\128\144\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\174\128\128\144\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\153\175\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\177\128\128\144\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\178\128\128\144\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\179\128\128\144\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\180\128\128\144\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\181\128\128\144\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\182\128\128\144\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\183\128\128\144\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\184\128\128\144\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\185\128\128\144\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\186\128\128\144\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\187\128\128\144\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\188\143\128\128\144\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\189\128\128\144\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\190\128\128\144\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\191\128\128\144\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\196\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\197\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\198\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\199\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\201\143\128\128\144\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128\128",
Vector.fromList [(0,0,(fn rest => Value.decl(Arg.Done {})::rest)),
(0,3,(fn Value.decl(arg0)::Value.pos(arg1)::Value.syn(arg2)::rest => Value.decl(Arg.Syn {3=arg0,2=arg1,1=arg2})::rest|_=>raise (Fail "bad parser"))),
(0,7,(fn Value.decl(arg0)::Value.pos(arg1)::Value.modes(arg2)::Value.pos_str(arg3)::Value.pos_str(arg4)::_::Value.pos(arg5)::rest => Value.decl(Arg.Query {6=arg0,5=arg1,4=arg2,3=arg3,2=arg4,1=arg5})::rest|_=>raise (Fail "bad parser"))),
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
(4,3,(fn Value.pos(arg0)::Value.syn(arg1)::Value.pos(arg2)::rest => Value.syn(Arg.id2 {3=arg0,2=arg1,1=arg2})::rest|_=>raise (Fail "bad parser"))),
(4,1,(fn Value.pos_str(arg0)::rest => Value.syn(Arg.Var arg0)::rest|_=>raise (Fail "bad parser"))),
(4,1,(fn Value.pos(arg0)::rest => Value.syn(Arg.Uscore arg0)::rest|_=>raise (Fail "bad parser"))),
(4,1,(fn Value.pos(arg0)::rest => Value.syn(Arg.World arg0)::rest|_=>raise (Fail "bad parser"))),
(4,1,(fn Value.pos(arg0)::rest => Value.syn(Arg.Type arg0)::rest|_=>raise (Fail "bad parser"))),
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
