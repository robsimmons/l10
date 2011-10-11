structure Parser:> 
sig
   exception SyntaxError of Pos.t option * string
   val parse: char Stream.stream -> Decl.t Stream.stream
end = struct

   exception SyntaxError of Pos.t option * string
(*
   fun string (_, syn) =
      case syn of  
         Ascribe (c, s) => c ^ " : " ^ string s 
       | Assign (c, s) => c ^ " = " ^ string s
       | Conj (s1, s2) => "(" ^ string s1 ^ ", " ^ string s2 ^ ")"
       | Arrow (s1, s2) => "(" ^ string s1 ^ " -> " ^ string s2 ^ ")"
       | At (s1, s2) => "(" ^ string s1 ^ " @ " ^ string s2 ^ ")"
       | Pi (s1, s2) => "({" ^ string s1 ^ "} " ^ string s2 ^ ")"
       | Ex (s1, s2) => "(Ex " ^ s1 ^ ". " ^ string s2 ^ ")"
       | Var (SOME s) => s
       | Var NONE => "_"
       | App (c, s) => 
         "(" ^ c ^ " ^ " ^ String.concatWith " " (map string s) ^ ")"
       | Int i => Int.toString i
       | Str s => "\"" ^ s ^ "\""
       | World => "world"
       | Type => "type"
       | Rel => "rel"
       | Binrel (br, s1, s2) => 
         "(" ^ string s1 ^ " " ^ A.strBinrel br ^ " " ^ string s2 ^ ")"
*)

   structure Arg = 
   struct
      type pos = Pos.t
      type pos_str = Pos.t * string
      type pos_int = Pos.t * int
      type decl = Decl.t
      type modes = Mode.t list
      datatype terminal = datatype Token.t

      datatype syn = 
         Ascribe of (Pos.t * string) * syn
       | Assign of (Pos.t * string) * syn
       | Arrow of syn * syn
       | Conj of syn * syn
       | At of syn * syn
       | Binrel of Binrel.t * syn * syn
       | App of (Pos.t * string) * syn list
       | Pi of Pos.t * syn * syn
       | Ex of Pos.t * (Pos.t * string) * syn
       | Var of Pos.t * string 
       | Uscore of Pos.t
       | World of Pos.t
       | Type of Pos.t
       | Rel of Pos.t
       | Num of Pos.t * int
       | String of Pos.t * string
       | Pos of Pos.t * syn
      
      type sings = syn list

      fun getpos syn = 
         case syn of 
            Ascribe ((pos, _), syn) => Pos.union pos (getpos syn)
          | Assign ((pos, _), syn) => Pos.union pos (getpos syn)
          | Arrow (syn1, syn2) => Pos.union (getpos syn1) (getpos syn2)
          | Conj (syn1, syn2) => Pos.union (getpos syn1) (getpos syn2)
          | At (syn1, syn2) => Pos.union (getpos syn1) (getpos syn2)
          | Binrel (_, syn1, syn2) => Pos.union (getpos syn1) (getpos syn2)
          | App ((pos, _), []) => pos
          | App ((pos, _), syns) => Pos.union pos (getpos (List.last syns))
          | Pi (pos, _, syn) => Pos.union pos (getpos syn)
          | Ex (pos, (_, _), syn) => Pos.union pos (getpos syn)
          | Var (pos, _) => pos
          | Uscore pos => pos
          | World pos => pos
          | Type pos => pos
          | Rel pos => pos
          | Num (pos, _) => pos
          | String (pos, _) => pos
          | Pos (pos, _) => pos
       
      fun error s = 
         case Stream.front s of 
            Stream.Nil => SyntaxError (NONE, "Syntax error at end of file")
          | Stream.Cons (tok, pos) => 
            SyntaxError (SOME (Token.pos tok), "Unexpected token")

      val ascribe_ucid = Ascribe
      fun rarrow (syn1, syn2) = Arrow (syn2, syn1)
      fun binrel r (syn1, syn2) = Binrel (r, syn1, syn2)
      fun binrel' r (syn1, syn2) = Binrel (r, syn2, syn1)
      val eqeq = binrel Binrel.Eq
      val neq  = binrel Binrel.Neq
      val gt   = binrel Binrel.Gt
      val lt   = binrel' Binrel.Gt
      val geq  = binrel Binrel.Geq
      val leq  = binrel' Binrel.Geq
      fun plus (syn1, syn2) = 
         let val coord = Pos.left (getpos syn1) 
         in App ((Pos.pos coord coord, "_plus"), [syn1, syn2]) end
      fun id1 x = x
      fun id2 (left, x, right) = Pos (Pos.union left right, x)
      fun sings_end () = []
      fun sings_cons (syn, sings) = syn :: sings
      fun sings_lcid (lcid, sings) = App (lcid, []) :: sings

      fun mode_end () = []
      fun mode_input modes = Mode.Input :: modes
      fun mode_output modes = Mode.Output :: modes
      fun mode_ignore modes = Mode.Ignore :: modes 

      (*[ val anno_query: 
             (Pos.t * string) * (Pos.t * string) * Mode.t list 
             -> Decl.decl ]*)
      fun anno_query ((_, query), (_, a), modes) = 
         Decl.Query (Symbol.fromValue query, 
                     (Symbol.fromValue a, 
                      map (fn mode => Term.Mode (mode, NONE)) modes))

      fun full_decl _ = raise Match
      fun anno decl = decl
   end

   structure Parse =  
      L10Parse
      (structure Streamable = StreamStreamable
       structure Arg = Arg)

   fun parse _ = raise Match
end
