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

    | NOT of Pos.t
    | WORLD of Pos.t
    | TYPE of Pos.t
    | EXTENSIBLE of Pos.t
    | REL of Pos.t
    | USCORE of Pos.t
  
    | UCID of Pos.t * string
    | LCID of Pos.t * string
    | NUM of Pos.t * IntInf.int
    | STRING of Pos.t * string

    | PRAGMA_QUERY of Pos.t
    | PRAGMA_TYPE of Pos.t

    | LANNO of Pos.t
    | RANNO of Pos.t
    | ANNO_QUERY of Pos.t
    | ANNO_TYPE of Pos.t
  
   fun pos tok = 
      case tok of
         LCURLY pos => pos
       | RCURLY pos => pos
       | LPAREN pos => pos
       | RPAREN pos => pos
       | EX pos => pos
       | PERIOD pos => pos

       | COLON pos => pos
       | EQ pos => pos
       | LARROW pos => pos
       | RARROW pos => pos
       | COMMA pos => pos
       | AT pos => pos
   
       | EQEQ pos => pos
       | NEQ pos => pos
       | GT pos => pos
       | LT pos => pos
       | GEQ pos => pos
       | LEQ pos => pos
  
       | PLUS pos => pos
       | MINUS pos => pos

       | NOT pos => pos
       | WORLD pos => pos
       | TYPE pos => pos
       | EXTENSIBLE pos => pos
       | REL pos => pos
       | USCORE pos => pos
  
       | UCID (pos, _) => pos
       | LCID (pos, _) => pos
       | NUM (pos, _) => pos
       | STRING (pos, _) => pos

       | LANNO pos => pos
       | RANNO pos => pos
       | ANNO_QUERY pos => pos
       | ANNO_TYPE pos => pos
end

structure Lexer:> 
sig
   exception LexError of Coord.t * string
   val lex: string -> char Stream.stream -> Token.t Stream.stream
end = 
struct
   open Token
   open Stream

   exception Invariant
   exception LexError of Coord.t * string

   structure Arg = 
   struct
      type symbol = char * Coord.t
      fun ord (c, _) = Char.ord c
      type tok = Coord.t -> Token.t front
      type u = Coord.t -> Coord.t * symbol stream
      type self = 
         {
         lexmain: symbol stream -> tok,
         anno: symbol stream -> tok,
         linecomment: symbol stream -> u,
         comment: symbol stream -> u 
         }
      type info = 
         { 
         follow: symbol stream,
         len: int,
         self: self,
         start: symbol stream,
         match: symbol list
         }

      fun extent match left =
         let 
            fun loop accum match =
               case match of 
                  [] => 
                     raise Invariant (* Don't call extent on epsilon match! *)
                | [ (c, right) ] => (* Base case *)
                   ( Pos.pos left right
                   , right
                   , String.implode (rev (c :: accum)))
                | ((c, _) :: match) =>
                     loop (c :: accum) match
         in
            loop [] match
         end

      fun simple nextstate token ({ follow, self, match, ...}: info) left = 
         let 
            val (pos, coord, match') = extent match left
         in
            Cons (token pos, lazy (fn () => (nextstate self) follow coord))
         end

      fun action nextstate f ({ follow, self, match, ...}: info) left = 
         let 
            val (pos, coord, match') = extent match left
         in
            Cons (f (pos, match'), lazy (fn () => (nextstate self) follow coord))
         end

      fun fastforward nextstate ({ follow, self, match, ...}: info) left = 
         (nextstate self) follow (#2 (extent match left))

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
      val minus = simple #lexmain MINUS

      val not = simple #lexmain NOT
      val world = simple #lexmain WORLD
      val ty = simple #lexmain TYPE
      val extensible = simple #lexmain EXTENSIBLE
      val rel = simple #lexmain REL
      val uscore = simple #lexmain USCORE

      val ucid = action #lexmain UCID
      val lcid = action #lexmain LCID
      val num = action #lexmain 
         (fn (pos, match) => 
            (case IntInf.fromString match of 
               NONE => raise LexError (Pos.left pos, "Bad integer constant")
             | SOME i => NUM (pos, i)))
      val str = action #lexmain
         (fn (pos, match) => 
            STRING (pos, String.substring (match, 1, size match - 2)))
      val pragma = action #lexmain
         (fn (pos, match) =>
            (case String.map Char.toLower (String.extract (match, 1, NONE)) of
                "type" => PRAGMA_TYPE pos
              | "query" => PRAGMA_QUERY pos))

      fun linecomment ({ follow, self, match, ...}: info) coord = 
         let val (coord', follow') = 
                (#linecomment self) follow (#2 (extent match coord))
         in (#lexmain self) follow' coord' end
      fun comment ({ follow, self, match, ...}: info) coord = 
         let val (coord', follow') = 
                (#comment self) follow (#2 (extent match coord))
         in (#lexmain self) follow' coord' end
      val anno_start = simple #anno LANNO
      fun error _ coord = raise LexError (coord, "Lex error")

      val anno_space = fastforward #anno
      val anno_query = simple #anno ANNO_QUERY
      val anno_type = simple #anno ANNO_TYPE
      val anno_lparen = simple #anno LPAREN
      val anno_rparen = simple #anno RPAREN
      val anno_plus = simple #anno PLUS
      val anno_minus = simple #anno MINUS
      val anno_uscore = simple #anno USCORE
      val anno_lcid = action #anno LCID
      val anno_colon = simple #anno COLON

      val anno_end = simple #lexmain RANNO
      fun anno_linecomment ({ follow, self, match, ...}: info) coord = 
         let val (coord', follow') = 
                (#linecomment self) follow (#2 (extent match coord))
         in (#anno self) follow' coord' end
      fun anno_comment ({ follow, self, match, ...}: info) coord = 
         let val (coord', follow') = 
                (#comment self) follow (#2 (extent match coord))
         in (#anno self) follow' coord' end
      fun anno_error _ coord = 
         raise LexError (coord, "Lex error in annotation")

      fun linecomment_close ({ follow, self, match, ...}: info) coord =
         (#2 (extent match coord), follow)
      val linecomment_skip = fastforward #linecomment
      fun linecomment_error _ coord =
         raise LexError(coord, "Unterminated line comment at end of file")

      fun comment_open ({ follow, self, match, ...}: info) coord = 
         let val (coord', follow') = 
                (#comment self) follow (#2 (extent match coord))
         in (#comment self) follow' coord' end
      val comment_skip = fastforward #comment
      fun comment_close ({ follow, self, match, ... }: info) coord = 
         (#2 (extent match coord), follow)
      fun comment_error _ coord =
         raise LexError (coord, "Unclosed comment at end of file")

   end

   structure Lex = 
      L10Lex
      (structure Streamable = StreamStreamable
       structure Arg = Arg)
 
   fun lex name stream = 
      let 
         fun eol stream = 
            case Stream.front stream of
               Stream.Cons (#"\n", _) => true
             | Stream.Cons (#"\v", _) => true
             | Stream.Cons (#"\f", _) => true
             | Stream.Cons (#"\r", stream) => 
                 (case Stream.front stream of
                     Stream.Cons (#"\n", _) => false
                   | _ => true)
             | _ => false

         val coord = Coord.init name
         val stream' = 
            CoordinatedStream.coordinate eol coord stream
      in  
         lazy (fn () => Lex.lexmain stream' coord)
      end
end
