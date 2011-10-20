(*

anno
initial state = 9
total states = 20

-----

anno
state 9 (initial, final:anno_error):

9-10 => state 11   (final:anno_space)
13 => state 11   (final:anno_space)
32 => state 11   (final:anno_space)
35 => state 13
40 => state 4   (sink:anno_lparen)
41 => state 5   (sink:anno_rparen)
43 => state 6   (sink:anno_plus)
45 => state 10   (final:anno_minus)
81 => state 14
95 => state 7   (sink:anno_uscore)
97-122 => state 12   (final:anno_lcid)
123 => state 15

-----

anno
state 10 (final:anno_minus):

45 => state 1   (sink:anno_linecomment)

-----

anno
state 11 (final:anno_space):

9-10 => state 11   (final:anno_space)
13 => state 11   (final:anno_space)
32 => state 11   (final:anno_space)

-----

anno
state 12 (final:anno_lcid):

39 => state 12   (final:anno_lcid)
48-57 => state 12   (final:anno_lcid)
65-90 => state 12   (final:anno_lcid)
92 => state 12   (final:anno_lcid)
95 => state 12   (final:anno_lcid)
97-122 => state 12   (final:anno_lcid)

-----

anno
state 13:

45 => state 16

-----

anno
state 14:

85 => state 17

-----

anno
state 15:

45 => state 3   (sink:anno_comment)

-----

anno
state 16:

125 => state 8   (sink:anno_end)

-----

anno
state 17:

69 => state 18

-----

anno
state 18:

82 => state 19

-----

anno
state 19:

89 => state 2   (sink:anno_query)

=====

comment
initial state = 5
total states = 7

-----

comment
state 4 (final:comment_skip):

45 => state 3   (sink:comment_open)

-----

comment
state 5 (initial, final:comment_error):

0-44 => state 1   (sink:comment_skip)
45 => state 6   (final:comment_skip)
46-122 => state 1   (sink:comment_skip)
123 => state 4   (final:comment_skip)
124-127 => state 1   (sink:comment_skip)

-----

comment
state 6 (final:comment_skip):

125 => state 2   (sink:comment_close)

=====

lexmain
initial state = 36
total states = 53

-----

lexmain
state 22 (final:lcurly):

45 => state 37   (final:comment)

-----

lexmain
state 23 (final:space):

9-10 => state 23   (final:space)
13 => state 23   (final:space)
32 => state 23   (final:space)

-----

lexmain
state 24 (final:world):

39 => state 35   (final:lcid)
48-57 => state 35   (final:lcid)
65-90 => state 35   (final:lcid)
92 => state 35   (final:lcid)
95 => state 35   (final:lcid)
97-122 => state 35   (final:lcid)

-----

lexmain
state 25 (final:rel):

39 => state 35   (final:lcid)
48-57 => state 35   (final:lcid)
65-90 => state 35   (final:lcid)
92 => state 35   (final:lcid)
95 => state 35   (final:lcid)
97-122 => state 35   (final:lcid)

-----

lexmain
state 26 (final:lcid):

39 => state 35   (final:lcid)
48-57 => state 35   (final:lcid)
65-90 => state 35   (final:lcid)
92 => state 35   (final:lcid)
95 => state 35   (final:lcid)
97-120 => state 35   (final:lcid)
121 => state 29   (final:lcid)
122 => state 35   (final:lcid)

-----

lexmain
state 27 (final:ty):

39 => state 35   (final:lcid)
48-57 => state 35   (final:lcid)
65-90 => state 35   (final:lcid)
92 => state 35   (final:lcid)
95 => state 35   (final:lcid)
97-122 => state 35   (final:lcid)

-----

lexmain
state 28 (final:lcid):

39 => state 35   (final:lcid)
48-57 => state 35   (final:lcid)
65-90 => state 35   (final:lcid)
92 => state 35   (final:lcid)
95 => state 35   (final:lcid)
97-110 => state 35   (final:lcid)
111 => state 42   (final:lcid)
112-122 => state 35   (final:lcid)

-----

lexmain
state 29 (final:lcid):

39 => state 35   (final:lcid)
48-57 => state 35   (final:lcid)
65-90 => state 35   (final:lcid)
92 => state 35   (final:lcid)
95 => state 35   (final:lcid)
97-111 => state 35   (final:lcid)
112 => state 33   (final:lcid)
113-122 => state 35   (final:lcid)

-----

lexmain
state 30 (final:lcid):

39 => state 35   (final:lcid)
48-57 => state 35   (final:lcid)
65-90 => state 35   (final:lcid)
92 => state 35   (final:lcid)
95 => state 35   (final:lcid)
97-110 => state 35   (final:lcid)
111 => state 38   (final:lcid)
112-122 => state 35   (final:lcid)

-----

lexmain
state 31 (final:ex):

39 => state 48   (final:ucid)
48-57 => state 48   (final:ucid)
65-90 => state 48   (final:ucid)
92 => state 48   (final:ucid)
95 => state 48   (final:ucid)
97-122 => state 48   (final:ucid)

-----

lexmain
state 32 (final:lcid):

39 => state 35   (final:lcid)
48-57 => state 35   (final:lcid)
65-90 => state 35   (final:lcid)
92 => state 35   (final:lcid)
95 => state 35   (final:lcid)
97-107 => state 35   (final:lcid)
108 => state 25   (final:rel)
109-122 => state 35   (final:lcid)

-----

lexmain
state 33 (final:lcid):

39 => state 35   (final:lcid)
48-57 => state 35   (final:lcid)
65-90 => state 35   (final:lcid)
92 => state 35   (final:lcid)
95 => state 35   (final:lcid)
97-100 => state 35   (final:lcid)
101 => state 27   (final:ty)
102-122 => state 35   (final:lcid)

-----

lexmain
state 34 (final:num):

48-57 => state 34   (final:num)

-----

lexmain
state 35 (final:lcid):

39 => state 35   (final:lcid)
48-57 => state 35   (final:lcid)
65-90 => state 35   (final:lcid)
92 => state 35   (final:lcid)
95 => state 35   (final:lcid)
97-122 => state 35   (final:lcid)

-----

lexmain
state 36 (initial, final:error):

9-10 => state 23   (final:space)
13 => state 23   (final:space)
32 => state 23   (final:space)
33 => state 49
34 => state 50
40 => state 12   (sink:lparen)
41 => state 19   (sink:rparen)
43 => state 10   (sink:plus)
44 => state 20   (sink:comma)
45 => state 51
46 => state 15   (sink:period)
47 => state 52
48 => state 9   (sink:num)
49-57 => state 34   (final:num)
58 => state 7   (sink:colon)
60 => state 44   (final:lt)
61 => state 40   (final:eq)
62 => state 39   (final:gt)
64 => state 17   (sink:at)
65-68 => state 48   (final:ucid)
69 => state 41   (final:ucid)
70-90 => state 48   (final:ucid)
95 => state 8   (sink:uscore)
97-109 => state 35   (final:lcid)
110 => state 28   (final:lcid)
111-113 => state 35   (final:lcid)
114 => state 47   (final:lcid)
115 => state 35   (final:lcid)
116 => state 26   (final:lcid)
117-118 => state 35   (final:lcid)
119 => state 30   (final:lcid)
120-122 => state 35   (final:lcid)
123 => state 22   (final:lcurly)
125 => state 2   (sink:rcurly)
EOS => state 21   (sink:eof)

-----

lexmain
state 37 (final:comment):

35 => state 6   (sink:anno_start)

-----

lexmain
state 38 (final:lcid):

39 => state 35   (final:lcid)
48-57 => state 35   (final:lcid)
65-90 => state 35   (final:lcid)
92 => state 35   (final:lcid)
95 => state 35   (final:lcid)
97-113 => state 35   (final:lcid)
114 => state 45   (final:lcid)
115-122 => state 35   (final:lcid)

-----

lexmain
state 39 (final:gt):

61 => state 16   (sink:geq)

-----

lexmain
state 40 (final:eq):

61 => state 5   (sink:eqeq)

-----

lexmain
state 41 (final:ucid):

39 => state 48   (final:ucid)
48-57 => state 48   (final:ucid)
65-90 => state 48   (final:ucid)
92 => state 48   (final:ucid)
95 => state 48   (final:ucid)
97-119 => state 48   (final:ucid)
120 => state 31   (final:ex)
121-122 => state 48   (final:ucid)

-----

lexmain
state 42 (final:lcid):

39 => state 35   (final:lcid)
48-57 => state 35   (final:lcid)
65-90 => state 35   (final:lcid)
92 => state 35   (final:lcid)
95 => state 35   (final:lcid)
97-115 => state 35   (final:lcid)
116 => state 46   (final:not)
117-122 => state 35   (final:lcid)

-----

lexmain
state 43 (final:lcid):

39 => state 35   (final:lcid)
48-57 => state 35   (final:lcid)
65-90 => state 35   (final:lcid)
92 => state 35   (final:lcid)
95 => state 35   (final:lcid)
97-99 => state 35   (final:lcid)
100 => state 24   (final:world)
101-122 => state 35   (final:lcid)

-----

lexmain
state 44 (final:lt):

45 => state 11   (sink:larrow)
61 => state 3   (sink:leq)

-----

lexmain
state 45 (final:lcid):

39 => state 35   (final:lcid)
48-57 => state 35   (final:lcid)
65-90 => state 35   (final:lcid)
92 => state 35   (final:lcid)
95 => state 35   (final:lcid)
97-107 => state 35   (final:lcid)
108 => state 43   (final:lcid)
109-122 => state 35   (final:lcid)

-----

lexmain
state 46 (final:not):

39 => state 35   (final:lcid)
48-57 => state 35   (final:lcid)
65-90 => state 35   (final:lcid)
92 => state 35   (final:lcid)
95 => state 35   (final:lcid)
97-122 => state 35   (final:lcid)

-----

lexmain
state 47 (final:lcid):

39 => state 35   (final:lcid)
48-57 => state 35   (final:lcid)
65-90 => state 35   (final:lcid)
92 => state 35   (final:lcid)
95 => state 35   (final:lcid)
97-100 => state 35   (final:lcid)
101 => state 32   (final:lcid)
102-122 => state 35   (final:lcid)

-----

lexmain
state 48 (final:ucid):

39 => state 48   (final:ucid)
48-57 => state 48   (final:ucid)
65-90 => state 48   (final:ucid)
92 => state 48   (final:ucid)
95 => state 48   (final:ucid)
97-122 => state 48   (final:ucid)

-----

lexmain
state 49:

61 => state 13   (sink:neq)

-----

lexmain
state 50:

32-33 => state 50
34 => state 18   (sink:str)
35-42 => state 50
48-57 => state 50
64-90 => state 50
94 => state 50
97-122 => state 50

-----

lexmain
state 51:

45 => state 4   (sink:linecomment)
62 => state 1   (sink:rarrow)

-----

lexmain
state 52:

47 => state 14   (sink:linecomment)

=====

linecomment
initial state = 3
total states = 4

-----

linecomment
state 3 (initial, final:linecomment_error):

0-9 => state 2   (sink:linecomment_skip)
10 => state 1   (sink:linecomment_close)
11-12 => state 2   (sink:linecomment_skip)
13 => state 1   (sink:linecomment_close)
14-127 => state 2   (sink:linecomment_skip)

*)

functor L10Lex (structure Streamable : STREAMABLE
structure Arg : sig
type symbol
val ord : symbol -> int
type tok
type u
val anno_comment : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val anno_end : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val anno_error : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val anno_lcid : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val anno_linecomment : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val anno_lparen : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val anno_minus : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val anno_plus : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val anno_query : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val anno_rparen : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val anno_space : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val anno_start : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val anno_uscore : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val at : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val colon : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val comma : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val comment : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val comment_close : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> u
val comment_error : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> u
val comment_open : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> u
val comment_skip : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> u
val eof : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val eq : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val eqeq : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val error : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val ex : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val geq : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val gt : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val larrow : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val lcid : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val lcurly : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val leq : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val linecomment : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val linecomment_close : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> u
val linecomment_error : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> u
val linecomment_skip : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> u
val lparen : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val lt : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val neq : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val not : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val num : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val period : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val plus : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val rarrow : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val rcurly : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val rel : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val rparen : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val space : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val str : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val ty : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val ucid : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val uscore : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
val world : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
end)
=
struct
local
structure LexEngine = LexEngineFun (structure Streamable = Streamable
type symbol = Arg.symbol
val ord = Arg.ord)
structure Tables = struct
fun error _ = raise (Fail "Illegal lexeme")
val anno = (9, 8, 12, Vector.fromList [Arg.anno_linecomment,Arg.anno_query,Arg.anno_comment,Arg.anno_lparen,Arg.anno_rparen,Arg.anno_plus,Arg.anno_uscore,Arg.anno_end,Arg.anno_error,Arg.anno_minus,Arg.anno_space,Arg.anno_lcid], LexEngine.next7x1 128 "\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\v\v\^@\^@\v\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\v\^@\^@\r\^@\^@\^@\^@\^D\^E\^@\^F\^@\n\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^N\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\a\^@\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\^O\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^A\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\v\v\^@\^@\v\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\v\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\f\^@\^@\^@\^@\^@\^@\^@\^@\f\f\f\f\f\f\f\f\f\f\^@\^@\^@\^@\^@\^@\^@\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\^@\f\^@\^@\f\^@\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^P\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^Q\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^C\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\b\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^R\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^S\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^B\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@", LexEngine.next0x1 "\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@")
val comment = (5, 3, 6, Vector.fromList [Arg.comment_skip,Arg.comment_close,Arg.comment_open,Arg.comment_skip,Arg.comment_error,Arg.comment_skip], LexEngine.next7x1 128 "\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^C\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^F\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^D\^A\^A\^A\^A\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^B\^@\^@", LexEngine.next0x1 "\^@\^@\^@\^@\^@\^@\^@")
val lexmain = (36, 21, 48, Vector.fromList [Arg.rarrow,Arg.rcurly,Arg.leq,Arg.linecomment,Arg.eqeq,Arg.anno_start,Arg.colon,Arg.uscore,Arg.num,Arg.plus,Arg.larrow,Arg.lparen,Arg.neq,Arg.linecomment,Arg.period,Arg.geq,Arg.at,Arg.str,Arg.rparen,Arg.comma,Arg.eof,Arg.lcurly,Arg.space,Arg.world,Arg.rel,Arg.lcid,Arg.ty,Arg.lcid,Arg.lcid,Arg.lcid,Arg.ex,Arg.lcid,Arg.lcid,Arg.num,Arg.lcid,Arg.error,Arg.comment,Arg.lcid,Arg.gt,Arg.eq,Arg.ucid,Arg.lcid,Arg.lcid,Arg.lt,Arg.lcid,Arg.not,Arg.lcid,Arg.ucid], LexEngine.next7x1 128 "\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@%\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^W\^W\^@\^@\^W\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^W\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@#\^@\^@\^@\^@\^@\^@\^@\^@##########\^@\^@\^@\^@\^@\^@\^@##########################\^@#\^@\^@#\^@##########################\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@#\^@\^@\^@\^@\^@\^@\^@\^@##########\^@\^@\^@\^@\^@\^@\^@##########################\^@#\^@\^@#\^@##########################\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@#\^@\^@\^@\^@\^@\^@\^@\^@##########\^@\^@\^@\^@\^@\^@\^@##########################\^@#\^@\^@#\^@########################\^]#\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@#\^@\^@\^@\^@\^@\^@\^@\^@##########\^@\^@\^@\^@\^@\^@\^@##########################\^@#\^@\^@#\^@##########################\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@#\^@\^@\^@\^@\^@\^@\^@\^@##########\^@\^@\^@\^@\^@\^@\^@##########################\^@#\^@\^@#\^@##############*###########\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@#\^@\^@\^@\^@\^@\^@\^@\^@##########\^@\^@\^@\^@\^@\^@\^@##########################\^@#\^@\^@#\^@###############!##########\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@#\^@\^@\^@\^@\^@\^@\^@\^@##########\^@\^@\^@\^@\^@\^@\^@##########################\^@#\^@\^@#\^@##############&###########\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@0\^@\^@\^@\^@\^@\^@\^@\^@0000000000\^@\^@\^@\^@\^@\^@\^@00000000000000000000000000\^@0\^@\^@0\^@00000000000000000000000000\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@#\^@\^@\^@\^@\^@\^@\^@\^@##########\^@\^@\^@\^@\^@\^@\^@##########################\^@#\^@\^@#\^@###########\^Y##############\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@#\^@\^@\^@\^@\^@\^@\^@\^@##########\^@\^@\^@\^@\^@\^@\^@##########################\^@#\^@\^@#\^@####\^[#####################\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\"\"\"\"\"\"\"\"\"\"\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@#\^@\^@\^@\^@\^@\^@\^@\^@##########\^@\^@\^@\^@\^@\^@\^@##########################\^@#\^@\^@#\^@##########################\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^W\^W\^@\^@\^W\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^W12\^@\^@\^@\^@\^@\f\^S\^@\n\^T3\^O4\t\"\"\"\"\"\"\"\"\"\a\^@,('\^@\^Q0000)000000000000000000000\^@\^@\^@\^@\b\^@#############\^\###/#\^Z##\^^###\^V\^@\^B\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^F\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@#\^@\^@\^@\^@\^@\^@\^@\^@##########\^@\^@\^@\^@\^@\^@\^@##########################\^@#\^@\^@#\^@#################-########\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^P\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^E\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@0\^@\^@\^@\^@\^@\^@\^@\^@0000000000\^@\^@\^@\^@\^@\^@\^@00000000000000000000000000\^@0\^@\^@0\^@00000000000000000000000\^_00\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@#\^@\^@\^@\^@\^@\^@\^@\^@##########\^@\^@\^@\^@\^@\^@\^@##########################\^@#\^@\^@#\^@###################.######\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@#\^@\^@\^@\^@\^@\^@\^@\^@##########\^@\^@\^@\^@\^@\^@\^@##########################\^@#\^@\^@#\^@###\^X######################\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\v\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^C\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@#\^@\^@\^@\^@\^@\^@\^@\^@##########\^@\^@\^@\^@\^@\^@\^@##########################\^@#\^@\^@#\^@###########+##############\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@#\^@\^@\^@\^@\^@\^@\^@\^@##########\^@\^@\^@\^@\^@\^@\^@##########################\^@#\^@\^@#\^@##########################\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@#\^@\^@\^@\^@\^@\^@\^@\^@##########\^@\^@\^@\^@\^@\^@\^@##########################\^@#\^@\^@#\^@#### #####################\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@0\^@\^@\^@\^@\^@\^@\^@\^@0000000000\^@\^@\^@\^@\^@\^@\^@00000000000000000000000000\^@0\^@\^@0\^@00000000000000000000000000\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\r\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@22\^R22222222\^@\^@\^@\^@\^@2222222222\^@\^@\^@\^@\^@\^@222222222222222222222222222\^@\^@\^@2\^@\^@22222222222222222222222222\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^D\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^A\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^N\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@", LexEngine.next0x1 "\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^U\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@")
val linecomment = (3, 2, 3, Vector.fromList [Arg.linecomment_close,Arg.linecomment_skip,Arg.linecomment_error], LexEngine.next7x1 128 "\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^A\^B\^B\^A\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B", LexEngine.next0x1 "\^@\^@\^@\^@")
end
in
fun anno s = LexEngine.lex {anno=anno, comment=comment, lexmain=lexmain, linecomment=linecomment} Tables.anno s
and comment s = LexEngine.lex {anno=anno, comment=comment, lexmain=lexmain, linecomment=linecomment} Tables.comment s
and lexmain s = LexEngine.lex {anno=anno, comment=comment, lexmain=lexmain, linecomment=linecomment} Tables.lexmain s
and linecomment s = LexEngine.lex {anno=anno, comment=comment, lexmain=lexmain, linecomment=linecomment} Tables.linecomment s
end
end
