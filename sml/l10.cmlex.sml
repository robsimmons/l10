(*

anno
initial state = 12
total states = 25

-----

anno
state 11 (final:anno_minus):

45 => state 1   (sink:anno_linecomment)

-----

anno
state 12 (initial, final:anno_error):

9-10 => state 13   (final:anno_space)
13 => state 13   (final:anno_space)
32 => state 13   (final:anno_space)
35 => state 15
40 => state 3   (sink:anno_lparen)
41 => state 9   (sink:anno_rparen)
43 => state 8   (sink:anno_plus)
45 => state 11   (final:anno_minus)
58 => state 2   (sink:anno_colon)
81 => state 17
84 => state 16
95 => state 7   (sink:anno_uscore)
97-122 => state 14   (final:anno_lcid)
123 => state 18

-----

anno
state 13 (final:anno_space):

9-10 => state 13   (final:anno_space)
13 => state 13   (final:anno_space)
32 => state 13   (final:anno_space)

-----

anno
state 14 (final:anno_lcid):

39 => state 14   (final:anno_lcid)
48-57 => state 14   (final:anno_lcid)
65-90 => state 14   (final:anno_lcid)
92 => state 14   (final:anno_lcid)
95 => state 14   (final:anno_lcid)
97-122 => state 14   (final:anno_lcid)

-----

anno
state 15:

45 => state 19

-----

anno
state 16:

89 => state 20

-----

anno
state 17:

85 => state 21

-----

anno
state 18:

45 => state 5   (sink:anno_comment)

-----

anno
state 19:

125 => state 6   (sink:anno_end)

-----

anno
state 20:

80 => state 22

-----

anno
state 21:

69 => state 23

-----

anno
state 22:

69 => state 10   (sink:anno_type)

-----

anno
state 23:

82 => state 24

-----

anno
state 24:

89 => state 4   (sink:anno_query)

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
initial state = 45
total states = 63

-----

lexmain
state 22 (final:gt):

61 => state 7   (sink:geq)

-----

lexmain
state 23 (final:lcid):

39 => state 54   (final:lcid)
48-57 => state 54   (final:lcid)
65-90 => state 54   (final:lcid)
92 => state 54   (final:lcid)
95 => state 54   (final:lcid)
97-115 => state 54   (final:lcid)
116 => state 46   (final:lcid)
117-122 => state 54   (final:lcid)

-----

lexmain
state 24 (final:not):

39 => state 54   (final:lcid)
48-57 => state 54   (final:lcid)
65-90 => state 54   (final:lcid)
92 => state 54   (final:lcid)
95 => state 54   (final:lcid)
97-122 => state 54   (final:lcid)

-----

lexmain
state 25 (final:lt):

45 => state 13   (sink:larrow)
61 => state 3   (sink:leq)

-----

lexmain
state 26 (final:lcid):

39 => state 54   (final:lcid)
48-57 => state 54   (final:lcid)
65-90 => state 54   (final:lcid)
92 => state 54   (final:lcid)
95 => state 54   (final:lcid)
97-107 => state 54   (final:lcid)
108 => state 48   (final:lcid)
109-122 => state 54   (final:lcid)

-----

lexmain
state 27 (final:lcid):

39 => state 54   (final:lcid)
48-57 => state 54   (final:lcid)
65-90 => state 54   (final:lcid)
92 => state 54   (final:lcid)
95 => state 54   (final:lcid)
97-104 => state 54   (final:lcid)
105 => state 41   (final:lcid)
106-122 => state 54   (final:lcid)

-----

lexmain
state 28 (final:lcid):

39 => state 54   (final:lcid)
48-57 => state 54   (final:lcid)
65-90 => state 54   (final:lcid)
92 => state 54   (final:lcid)
95 => state 54   (final:lcid)
97-111 => state 54   (final:lcid)
112 => state 37   (final:lcid)
113-122 => state 54   (final:lcid)

-----

lexmain
state 29 (final:world):

39 => state 54   (final:lcid)
48-57 => state 54   (final:lcid)
65-90 => state 54   (final:lcid)
92 => state 54   (final:lcid)
95 => state 54   (final:lcid)
97-122 => state 54   (final:lcid)

-----

lexmain
state 30 (final:lcid):

39 => state 54   (final:lcid)
48-57 => state 54   (final:lcid)
65-90 => state 54   (final:lcid)
92 => state 54   (final:lcid)
95 => state 54   (final:lcid)
97-115 => state 54   (final:lcid)
116 => state 24   (final:not)
117-122 => state 54   (final:lcid)

-----

lexmain
state 31 (final:lcid):

39 => state 54   (final:lcid)
48-57 => state 54   (final:lcid)
65-90 => state 54   (final:lcid)
92 => state 54   (final:lcid)
95 => state 54   (final:lcid)
97-109 => state 54   (final:lcid)
110 => state 55   (final:lcid)
111-122 => state 54   (final:lcid)

-----

lexmain
state 32 (final:lcid):

39 => state 54   (final:lcid)
48-57 => state 54   (final:lcid)
65-90 => state 54   (final:lcid)
92 => state 54   (final:lcid)
95 => state 54   (final:lcid)
97-120 => state 54   (final:lcid)
121 => state 28   (final:lcid)
122 => state 54   (final:lcid)

-----

lexmain
state 33 (final:ty):

39 => state 54   (final:lcid)
48-57 => state 54   (final:lcid)
65-90 => state 54   (final:lcid)
92 => state 54   (final:lcid)
95 => state 54   (final:lcid)
97-122 => state 54   (final:lcid)

-----

lexmain
state 34 (final:lcid):

39 => state 54   (final:lcid)
48-57 => state 54   (final:lcid)
65-90 => state 54   (final:lcid)
92 => state 54   (final:lcid)
95 => state 54   (final:lcid)
97-100 => state 54   (final:lcid)
101 => state 35   (final:extensible)
102-122 => state 54   (final:lcid)

-----

lexmain
state 35 (final:extensible):

39 => state 54   (final:lcid)
48-57 => state 54   (final:lcid)
65-90 => state 54   (final:lcid)
92 => state 54   (final:lcid)
95 => state 54   (final:lcid)
97-122 => state 54   (final:lcid)

-----

lexmain
state 36 (final:lcid):

39 => state 54   (final:lcid)
48-57 => state 54   (final:lcid)
65-90 => state 54   (final:lcid)
92 => state 54   (final:lcid)
95 => state 54   (final:lcid)
97-119 => state 54   (final:lcid)
120 => state 23   (final:lcid)
121-122 => state 54   (final:lcid)

-----

lexmain
state 37 (final:lcid):

39 => state 54   (final:lcid)
48-57 => state 54   (final:lcid)
65-90 => state 54   (final:lcid)
92 => state 54   (final:lcid)
95 => state 54   (final:lcid)
97-100 => state 54   (final:lcid)
101 => state 33   (final:ty)
102-122 => state 54   (final:lcid)

-----

lexmain
state 38 (final:lcid):

39 => state 54   (final:lcid)
48-57 => state 54   (final:lcid)
65-90 => state 54   (final:lcid)
92 => state 54   (final:lcid)
95 => state 54   (final:lcid)
97-110 => state 54   (final:lcid)
111 => state 30   (final:lcid)
112-122 => state 54   (final:lcid)

-----

lexmain
state 39 (final:lcid):

39 => state 54   (final:lcid)
48-57 => state 54   (final:lcid)
65-90 => state 54   (final:lcid)
92 => state 54   (final:lcid)
95 => state 54   (final:lcid)
97-107 => state 54   (final:lcid)
108 => state 44   (final:rel)
109-122 => state 54   (final:lcid)

-----

lexmain
state 40 (final:ucid):

39 => state 40   (final:ucid)
48-57 => state 40   (final:ucid)
65-90 => state 40   (final:ucid)
92 => state 40   (final:ucid)
95 => state 40   (final:ucid)
97-122 => state 40   (final:ucid)

-----

lexmain
state 41 (final:lcid):

39 => state 54   (final:lcid)
48-57 => state 54   (final:lcid)
65-90 => state 54   (final:lcid)
92 => state 54   (final:lcid)
95 => state 54   (final:lcid)
97 => state 54   (final:lcid)
98 => state 52   (final:lcid)
99-122 => state 54   (final:lcid)

-----

lexmain
state 42 (final:ucid):

39 => state 40   (final:ucid)
48-57 => state 40   (final:ucid)
65-90 => state 40   (final:ucid)
92 => state 40   (final:ucid)
95 => state 40   (final:ucid)
97-119 => state 40   (final:ucid)
120 => state 57   (final:ex)
121-122 => state 40   (final:ucid)

-----

lexmain
state 43 (final:space):

9-10 => state 43   (final:space)
13 => state 43   (final:space)
32 => state 43   (final:space)

-----

lexmain
state 44 (final:rel):

39 => state 54   (final:lcid)
48-57 => state 54   (final:lcid)
65-90 => state 54   (final:lcid)
92 => state 54   (final:lcid)
95 => state 54   (final:lcid)
97-122 => state 54   (final:lcid)

-----

lexmain
state 45 (initial, final:error):

9-10 => state 43   (final:space)
13 => state 43   (final:space)
32 => state 43   (final:space)
33 => state 59
34 => state 60
40 => state 12   (sink:lparen)
41 => state 4   (sink:rparen)
43 => state 14   (sink:plus)
44 => state 2   (sink:comma)
45 => state 61
46 => state 8   (sink:period)
47 => state 62
48 => state 9   (sink:num)
49-57 => state 58   (final:num)
58 => state 16   (sink:colon)
60 => state 25   (final:lt)
61 => state 56   (final:eq)
62 => state 22   (final:gt)
64 => state 5   (sink:at)
65-68 => state 40   (final:ucid)
69 => state 42   (final:ucid)
70-90 => state 40   (final:ucid)
95 => state 10   (sink:uscore)
97-100 => state 54   (final:lcid)
101 => state 36   (final:lcid)
102-109 => state 54   (final:lcid)
110 => state 38   (final:lcid)
111-113 => state 54   (final:lcid)
114 => state 53   (final:lcid)
115 => state 54   (final:lcid)
116 => state 32   (final:lcid)
117-118 => state 54   (final:lcid)
119 => state 49   (final:lcid)
120-122 => state 54   (final:lcid)
123 => state 47   (final:lcurly)
125 => state 19   (sink:rcurly)
EOS => state 21   (sink:eof)

-----

lexmain
state 46 (final:lcid):

39 => state 54   (final:lcid)
48-57 => state 54   (final:lcid)
65-90 => state 54   (final:lcid)
92 => state 54   (final:lcid)
95 => state 54   (final:lcid)
97-100 => state 54   (final:lcid)
101 => state 31   (final:lcid)
102-122 => state 54   (final:lcid)

-----

lexmain
state 47 (final:lcurly):

45 => state 50   (final:comment)

-----

lexmain
state 48 (final:lcid):

39 => state 54   (final:lcid)
48-57 => state 54   (final:lcid)
65-90 => state 54   (final:lcid)
92 => state 54   (final:lcid)
95 => state 54   (final:lcid)
97-99 => state 54   (final:lcid)
100 => state 29   (final:world)
101-122 => state 54   (final:lcid)

-----

lexmain
state 49 (final:lcid):

39 => state 54   (final:lcid)
48-57 => state 54   (final:lcid)
65-90 => state 54   (final:lcid)
92 => state 54   (final:lcid)
95 => state 54   (final:lcid)
97-110 => state 54   (final:lcid)
111 => state 51   (final:lcid)
112-122 => state 54   (final:lcid)

-----

lexmain
state 50 (final:comment):

35 => state 15   (sink:anno_start)

-----

lexmain
state 51 (final:lcid):

39 => state 54   (final:lcid)
48-57 => state 54   (final:lcid)
65-90 => state 54   (final:lcid)
92 => state 54   (final:lcid)
95 => state 54   (final:lcid)
97-113 => state 54   (final:lcid)
114 => state 26   (final:lcid)
115-122 => state 54   (final:lcid)

-----

lexmain
state 52 (final:lcid):

39 => state 54   (final:lcid)
48-57 => state 54   (final:lcid)
65-90 => state 54   (final:lcid)
92 => state 54   (final:lcid)
95 => state 54   (final:lcid)
97-107 => state 54   (final:lcid)
108 => state 34   (final:lcid)
109-122 => state 54   (final:lcid)

-----

lexmain
state 53 (final:lcid):

39 => state 54   (final:lcid)
48-57 => state 54   (final:lcid)
65-90 => state 54   (final:lcid)
92 => state 54   (final:lcid)
95 => state 54   (final:lcid)
97-100 => state 54   (final:lcid)
101 => state 39   (final:lcid)
102-122 => state 54   (final:lcid)

-----

lexmain
state 54 (final:lcid):

39 => state 54   (final:lcid)
48-57 => state 54   (final:lcid)
65-90 => state 54   (final:lcid)
92 => state 54   (final:lcid)
95 => state 54   (final:lcid)
97-122 => state 54   (final:lcid)

-----

lexmain
state 55 (final:lcid):

39 => state 54   (final:lcid)
48-57 => state 54   (final:lcid)
65-90 => state 54   (final:lcid)
92 => state 54   (final:lcid)
95 => state 54   (final:lcid)
97-114 => state 54   (final:lcid)
115 => state 27   (final:lcid)
116-122 => state 54   (final:lcid)

-----

lexmain
state 56 (final:eq):

61 => state 18   (sink:eqeq)

-----

lexmain
state 57 (final:ex):

39 => state 40   (final:ucid)
48-57 => state 40   (final:ucid)
65-90 => state 40   (final:ucid)
92 => state 40   (final:ucid)
95 => state 40   (final:ucid)
97-122 => state 40   (final:ucid)

-----

lexmain
state 58 (final:num):

48-57 => state 58   (final:num)

-----

lexmain
state 59:

61 => state 11   (sink:neq)

-----

lexmain
state 60:

32-33 => state 60
34 => state 1   (sink:str)
35-42 => state 60
48-57 => state 60
64-90 => state 60
94 => state 60
97-122 => state 60

-----

lexmain
state 61:

45 => state 17   (sink:linecomment)
62 => state 20   (sink:rarrow)

-----

lexmain
state 62:

47 => state 6   (sink:linecomment)

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
val anno_colon : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
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
val anno_type : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
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
val extensible : { match : symbol list, len : int, start : symbol Streamable.t, follow : symbol Streamable.t, self : {anno : symbol Streamable.t -> tok, comment : symbol Streamable.t -> u, lexmain : symbol Streamable.t -> tok, linecomment : symbol Streamable.t -> u} } -> tok
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
val anno = (12, 10, 14, Vector.fromList [Arg.anno_linecomment,Arg.anno_colon,Arg.anno_lparen,Arg.anno_query,Arg.anno_comment,Arg.anno_end,Arg.anno_uscore,Arg.anno_plus,Arg.anno_rparen,Arg.anno_type,Arg.anno_minus,Arg.anno_error,Arg.anno_space,Arg.anno_lcid], LexEngine.next7x1 128 "\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^A\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\r\r\^@\^@\r\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\r\^@\^@\^O\^@\^@\^@\^@\^C\t\^@\b\^@\v\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^B\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^Q\^@\^@\^P\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\a\^@\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^R\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\r\r\^@\^@\r\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\r\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^N\^@\^@\^@\^@\^@\^@\^@\^@\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^@\^@\^@\^@\^@\^@\^@\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^@\^N\^@\^@\^N\^@\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^N\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^S\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^T\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^U\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^E\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^F\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^V\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^W\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\n\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^X\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^D\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@", LexEngine.next0x1 "\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@")
val comment = (5, 3, 6, Vector.fromList [Arg.comment_skip,Arg.comment_close,Arg.comment_open,Arg.comment_skip,Arg.comment_error,Arg.comment_skip], LexEngine.next7x1 128 "\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^C\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^F\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^A\^D\^A\^A\^A\^A\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^B\^@\^@", LexEngine.next0x1 "\^@\^@\^@\^@\^@\^@\^@")
val lexmain = (45, 21, 58, Vector.fromList [Arg.str,Arg.comma,Arg.leq,Arg.rparen,Arg.at,Arg.linecomment,Arg.geq,Arg.period,Arg.num,Arg.uscore,Arg.neq,Arg.lparen,Arg.larrow,Arg.plus,Arg.anno_start,Arg.colon,Arg.linecomment,Arg.eqeq,Arg.rcurly,Arg.rarrow,Arg.eof,Arg.gt,Arg.lcid,Arg.not,Arg.lt,Arg.lcid,Arg.lcid,Arg.lcid,Arg.world,Arg.lcid,Arg.lcid,Arg.lcid,Arg.ty,Arg.lcid,Arg.extensible,Arg.lcid,Arg.lcid,Arg.lcid,Arg.lcid,Arg.ucid,Arg.lcid,Arg.ucid,Arg.space,Arg.rel,Arg.error,Arg.lcid,Arg.lcurly,Arg.lcid,Arg.lcid,Arg.comment,Arg.lcid,Arg.lcid,Arg.lcid,Arg.lcid,Arg.lcid,Arg.eq,Arg.ex,Arg.num], LexEngine.next7x1 128 "\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\a\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@6\^@\^@\^@\^@\^@\^@\^@\^@6666666666\^@\^@\^@\^@\^@\^@\^@66666666666666666666666666\^@6\^@\^@6\^@6666666666666666666.666666\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@6\^@\^@\^@\^@\^@\^@\^@\^@6666666666\^@\^@\^@\^@\^@\^@\^@66666666666666666666666666\^@6\^@\^@6\^@66666666666666666666666666\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\r\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^C\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@6\^@\^@\^@\^@\^@\^@\^@\^@6666666666\^@\^@\^@\^@\^@\^@\^@66666666666666666666666666\^@6\^@\^@6\^@66666666666066666666666666\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@6\^@\^@\^@\^@\^@\^@\^@\^@6666666666\^@\^@\^@\^@\^@\^@\^@66666666666666666666666666\^@6\^@\^@6\^@66666666)66666666666666666\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@6\^@\^@\^@\^@\^@\^@\^@\^@6666666666\^@\^@\^@\^@\^@\^@\^@66666666666666666666666666\^@6\^@\^@6\^@666666666666666%6666666666\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@6\^@\^@\^@\^@\^@\^@\^@\^@6666666666\^@\^@\^@\^@\^@\^@\^@66666666666666666666666666\^@6\^@\^@6\^@66666666666666666666666666\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@6\^@\^@\^@\^@\^@\^@\^@\^@6666666666\^@\^@\^@\^@\^@\^@\^@66666666666666666666666666\^@6\^@\^@6\^@6666666666666666666\^X666666\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@6\^@\^@\^@\^@\^@\^@\^@\^@6666666666\^@\^@\^@\^@\^@\^@\^@66666666666666666666666666\^@6\^@\^@6\^@66666666666667666666666666\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@6\^@\^@\^@\^@\^@\^@\^@\^@6666666666\^@\^@\^@\^@\^@\^@\^@66666666666666666666666666\^@6\^@\^@6\^@666666666666666666666666\^\6\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@6\^@\^@\^@\^@\^@\^@\^@\^@6666666666\^@\^@\^@\^@\^@\^@\^@66666666666666666666666666\^@6\^@\^@6\^@66666666666666666666666666\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@6\^@\^@\^@\^@\^@\^@\^@\^@6666666666\^@\^@\^@\^@\^@\^@\^@66666666666666666666666666\^@6\^@\^@6\^@6666#666666666666666666666\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@6\^@\^@\^@\^@\^@\^@\^@\^@6666666666\^@\^@\^@\^@\^@\^@\^@66666666666666666666666666\^@6\^@\^@6\^@66666666666666666666666666\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@6\^@\^@\^@\^@\^@\^@\^@\^@6666666666\^@\^@\^@\^@\^@\^@\^@66666666666666666666666666\^@6\^@\^@6\^@66666666666666666666666\^W66\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@6\^@\^@\^@\^@\^@\^@\^@\^@6666666666\^@\^@\^@\^@\^@\^@\^@66666666666666666666666666\^@6\^@\^@6\^@6666!666666666666666666666\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@6\^@\^@\^@\^@\^@\^@\^@\^@6666666666\^@\^@\^@\^@\^@\^@\^@66666666666666666666666666\^@6\^@\^@6\^@66666666666666\^^66666666666\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@6\^@\^@\^@\^@\^@\^@\^@\^@6666666666\^@\^@\^@\^@\^@\^@\^@66666666666666666666666666\^@6\^@\^@6\^@66666666666,66666666666666\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@(\^@\^@\^@\^@\^@\^@\^@\^@((((((((((\^@\^@\^@\^@\^@\^@\^@((((((((((((((((((((((((((\^@(\^@\^@(\^@((((((((((((((((((((((((((\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@6\^@\^@\^@\^@\^@\^@\^@\^@6666666666\^@\^@\^@\^@\^@\^@\^@66666666666666666666666666\^@6\^@\^@6\^@64666666666666666666666666\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@(\^@\^@\^@\^@\^@\^@\^@\^@((((((((((\^@\^@\^@\^@\^@\^@\^@((((((((((((((((((((((((((\^@(\^@\^@(\^@(((((((((((((((((((((((9((\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@++\^@\^@+\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@+\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@6\^@\^@\^@\^@\^@\^@\^@\^@6666666666\^@\^@\^@\^@\^@\^@\^@66666666666666666666666666\^@6\^@\^@6\^@66666666666666666666666666\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@++\^@\^@+\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@+;<\^@\^@\^@\^@\^@\f\^D\^@\^N\^B=\b>\t:::::::::\^P\^@\^Y8\^V\^@\^E((((*(((((((((((((((((((((\^@\^@\^@\^@\n\^@6666$66666666&66656 661666/\^@\^S\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@6\^@\^@\^@\^@\^@\^@\^@\^@6666666666\^@\^@\^@\^@\^@\^@\^@66666666666666666666666666\^@6\^@\^@6\^@6666\^_666666666666666666666\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@2\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@6\^@\^@\^@\^@\^@\^@\^@\^@6666666666\^@\^@\^@\^@\^@\^@\^@66666666666666666666666666\^@6\^@\^@6\^@666\^]6666666666666666666666\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@6\^@\^@\^@\^@\^@\^@\^@\^@6666666666\^@\^@\^@\^@\^@\^@\^@66666666666666666666666666\^@6\^@\^@6\^@66666666666666366666666666\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^O\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@6\^@\^@\^@\^@\^@\^@\^@\^@6666666666\^@\^@\^@\^@\^@\^@\^@66666666666666666666666666\^@6\^@\^@6\^@66666666666666666\^Z66666666\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@6\^@\^@\^@\^@\^@\^@\^@\^@6666666666\^@\^@\^@\^@\^@\^@\^@66666666666666666666666666\^@6\^@\^@6\^@66666666666\"66666666666666\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@6\^@\^@\^@\^@\^@\^@\^@\^@6666666666\^@\^@\^@\^@\^@\^@\^@66666666666666666666666666\^@6\^@\^@6\^@6666'666666666666666666666\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@6\^@\^@\^@\^@\^@\^@\^@\^@6666666666\^@\^@\^@\^@\^@\^@\^@66666666666666666666666666\^@6\^@\^@6\^@66666666666666666666666666\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@6\^@\^@\^@\^@\^@\^@\^@\^@6666666666\^@\^@\^@\^@\^@\^@\^@66666666666666666666666666\^@6\^@\^@6\^@666666666666666666\^[6666666\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^R\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@(\^@\^@\^@\^@\^@\^@\^@\^@((((((((((\^@\^@\^@\^@\^@\^@\^@((((((((((((((((((((((((((\^@(\^@\^@(\^@((((((((((((((((((((((((((\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@::::::::::\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\v\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@<<\^A<<<<<<<<\^@\^@\^@\^@\^@<<<<<<<<<<\^@\^@\^@\^@\^@\^@<<<<<<<<<<<<<<<<<<<<<<<<<<<\^@\^@\^@<\^@\^@<<<<<<<<<<<<<<<<<<<<<<<<<<\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^Q\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^T\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^F\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@", LexEngine.next0x1 "\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^U\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@")
val linecomment = (3, 2, 3, Vector.fromList [Arg.linecomment_close,Arg.linecomment_skip,Arg.linecomment_error], LexEngine.next7x1 128 "\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^@\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^A\^B\^B\^A\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B\^B", LexEngine.next0x1 "\^@\^@\^@\^@")
end
in
fun anno s = LexEngine.lex {anno=anno, comment=comment, lexmain=lexmain, linecomment=linecomment} Tables.anno s
and comment s = LexEngine.lex {anno=anno, comment=comment, lexmain=lexmain, linecomment=linecomment} Tables.comment s
and lexmain s = LexEngine.lex {anno=anno, comment=comment, lexmain=lexmain, linecomment=linecomment} Tables.lexmain s
and linecomment s = LexEngine.lex {anno=anno, comment=comment, lexmain=lexmain, linecomment=linecomment} Tables.linecomment s
end
end
