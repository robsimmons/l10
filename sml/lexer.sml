structure Token = 
struct

   datatype t = 
      LCURLY of Pos.t
    | RCURLY of Pos.t
    | LPAREN of Pos.t
    | RPAREN of Pos.t
    | EX of Pos.t
    | PERIOD of Pos.t

    | COLON of Pos.t
    | EQ of Pos.t
    | LARROW of Pos.t
    | RARROW of Pos.t
    | COMMA of Pos.t
    | AT of Pos.t
   
    | EQEQ of Pos.t
    | NEQ of Pos.t
    | GT of Pos.t
    | LT of Pos.t
    | GEQ of Pos.t
    | LEQ of Pos.t
  
    | PLUS of Pos.t
    | MINUS of Pos.t

    | WORLD of Pos.t
    | TYPE of Pos.t
    | REL of Pos.t
    | USCORE of Pos.t
  
    | UCID of Pos.t * string
    | LCID of Pos.t * string
    | NUM of Pos.t * IntInf.int
    | STRING of Pos.t * string

    | LANNO of Pos.t
    | RANNO of Pos.t
    | ANNO_QUERY of Pos.t
  
end

structure Lexer:> 
sig
   val lex: string -> char Stream.stream -> Token.t Stream.stream
end = 
struct
   open Token
   open Stream

   structure Arg = 
   struct
      type symbol = char * Coord.t
      fun ord (c, _) = Char.ord c
      type tok = Coord.t -> Token.t front
      type u = Coord.t -> Coord.t * symbol stream
      type arg = 
         { 
         follow: symbol stream,
         len: int,
         self: { lexmain: symbol stream -> tok,
                 anno: symbol stream -> tok,
                 linecomment: symbol stream -> u,
                 comment: symbol stream -> u },
         start: symbol stream,
         str: symbol list
         }

      val extent =
         let 
            fun loop accum [] right = 
                (Pos.pos right right, right, String.implode (rev accum))
              | loop accum ((c, right) :: str) _ = 
                loop (c :: accum) str right
         in
            loop []
         end

      fun simple nextstate token ({ follow, self, str, ...}: arg) left = 
         let 
            val (pos, coord, _) = extent str left
         in
            Cons (token pos, lazy (fn () => (nextstate self) follow coord))
         end
 
      fun fastforward nextstate ({ follow, self, str, ...}: arg) left = 
         (nextstate self) follow (#2 (extent str left))

      fun eof _ _ = Nil
      val space = fastforward #lexmain

      val lcurly = simple #lexmain LCURLY
      val rcurly = simple #lexmain RCURLY
      val lparen = simple #lexmain LPAREN
      val rparen = simple #lexmain RPAREN
      val ex = simple #lexmain EX

      val period = simple #lexmain PERIOD
      val comma = simple #lexmain COMMA
      val colon = simple #lexmain COLON
      val eq = simple #lexmain EQ
      val rarrow = simple #lexmain RARROW
      val larrow = simple #lexmain LARROW
      val at = simple #lexmain AT

      val eqeq = simple #lexmain EQEQ
      val neq = simple #lexmain NEQ
      val gt = simple #lexmain GT
      val lt = simple #lexmain LT
      val geq = simple #lexmain GEQ
      val leq = simple #lexmain LEQ
      val plus = simple #lexmain PLUS

      val world = simple #lexmain WORLD
      val ty = simple #lexmain TYPE
      val rel = simple #lexmain REL
      val uscore = simple #lexmain USCORE

      val ucid = fn _ => raise Match                 
      val lcid = fn _ => raise Match                 
      val num = fn _ => raise Match                 
      val str = fn _ => raise Match                 

      val linecomment = fn _ => raise Match
      val comment = fn _ => raise Match
      val anno_start = simple #anno LANNO
      fun error _ coord = 
         raise Fail ("Lex error at " ^ Coord.toString coord 
                     ^ "\n(position " ^ Int.toString (Coord.abs coord) ^ ")")

      val anno_space = fastforward #anno
      val anno_query = simple #anno ANNO_QUERY
      val anno_plus = simple #anno PLUS
      val anno_minus = simple #anno MINUS
      val anno_uscore = simple #anno USCORE
      val anno_lcid = fn _ => raise Match

      val anno_end = simple #lexmain RANNO
      val anno_linecomment = fn _ => raise Match
      val anno_comment = fn _ => raise Match
      fun anno_error _ coord =
         raise Fail ("Lex error in annotation at " ^ Coord.toString coord 
                     ^ "\n(position " ^ Int.toString (Coord.abs coord) ^ ")")

      fun linecomment_close ({ follow, self, str, ...}: arg) coord =
         (#2 (extent str coord), follow)
      val linecomment_skip = fastforward #linecomment
      fun linecomment_error _ coord =
         raise Fail ("Unterminated line comment at end of file at " 
                     ^ Coord.toString coord 
                     ^ "\n(position " ^ Int.toString (Coord.abs coord) ^ ")")

      fun comment_open ({ follow, self, str, ...}: arg) coord = 
         let 
            val (coord', follow') = 
               (#comment self) follow (#2 (extent str coord))
         in
            (#comment self) follow' coord'
         end
      val comment_skip = fastforward #comment
      fun comment_close ({ follow, self, str, ... }: arg) coord = 
         (#2 (extent str coord), follow)
      fun comment_error _ coord =
         raise Fail ("Unclosed comment at end of file at " 
                     ^ Coord.toString coord 
                     ^ "\n(position " ^ Int.toString (Coord.abs coord) ^ ")")

   end

   structure LexMain = 
      L10Lex
      (structure Streamable = StreamStreamable
       structure Arg = Arg)
 
   fun lex name stream = 
      let 
         val (coord, stream') = MarkCharStream.mark name stream
      in  
         lazy (fn () => LexMain.lexmain stream' coord)
      end

end
