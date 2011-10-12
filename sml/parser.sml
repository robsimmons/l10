structure Parser:> 
sig
   exception SyntaxError of Pos.t option * string
   
   (*[ val parse: Token.t Stream.stream -> Decl.decl Stream.stream ]*)
   val parse: Token.t Stream.stream -> Decl.t Stream.stream
end = struct

   exception SyntaxError of Pos.t option * string

   (* The "surface parser", which interacts with the CMLex infrastructure *)
   structure Arg = 
   struct
      type pos = Pos.t
      type pos_str = Pos.t * string
      type pos_int = Pos.t * int
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
       | Pi of Pos.t * syn * Pos.t * syn
       | Ex of Pos.t * (Pos.t * string) * syn
       | Var of Pos.t * string 
       | Uscore of Pos.t
       | World of Pos.t
       | Type of Pos.t
       | Rel of Pos.t
       | Num of Pos.t * int
       | String of Pos.t * string
       | Pos of Pos.t * syn

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
          | Pi (pos, _, _, syn) => Pos.union pos (getpos syn)
          | Ex (pos, (_, _), syn) => Pos.union pos (getpos syn)
          | Var (pos, _) => pos
          | Uscore pos => pos
          | World pos => pos
          | Type pos => pos
          | Rel pos => pos
          | Num (pos, _) => pos
          | String (pos, _) => pos
          | Pos (pos, _) => pos

      type sings = syn list      
      datatype decl = 
         Syn of syn * Pos.t
       | Query of Pos.t 
                  * (Pos.t * string)  
                  * (Pos.t * string) 
                  * Mode.t list
                  * Pos.t

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
      fun mode_input  modes = Mode.Input :: modes
      fun mode_output modes = Mode.Output :: modes
      fun mode_ignore modes = Mode.Ignore :: modes 
      fun full_decl (syn, pos) = Syn (syn, pos)
   end

   structure Parse =  
      L10Parse
      (structure Streamable = StreamStreamable
       structure Arg = Arg)


   (* The "real" parser *)
   open Arg
  
   (*[ val p_t: syn -> Symbol.symbol ]*)
   fun p_t syn = 
      case syn of 
         App ((_, t), []) => Symbol.fromValue t
       | _ => raise SyntaxError (SOME (getpos syn), "Expected a simple type")

   (*[ val p_ground: syn -> Term.ground ]*)
   fun p_ground syn = raise Match

   (*[ val p_term: syn -> Term.term ]*)
   fun p_term syn = raise Match

   (*[ val p_world': syn -> SetX.set -> (Pos.t * Atom.world) option ]*)
   fun p_world' syn worlds =
      case syn of 
         App ((_, id), syns) =>
         let val w = Symbol.fromValue id in 
            if SetX.member worlds w 
            then SOME (getpos syn, (w, map p_term syns))
            else NONE
         end
       | _ => NONE

   (*[ val p_world: syn -> SetX.set -> (Pos.t * Atom.world) ]*)
   fun p_world syn worlds = raise Match

   (*[ val p_prop: syn -> SetX.set -> Atom.world ]*)
   fun p_prop syn worlds = raise Match

   (*[ val p_ground_world: syn -> SetX.set -> (Pos.t * Atom.ground_world) ]*)
   fun p_ground_world syn worlds = raise Match

   (*[ val p_ground_prop: syn -> SetX.set -> (Pos.t * Atom.ground_prop) ]*)
   fun p_ground_prop syn worlds = raise Match

   (*[ val p_rule: syn -> SetX.set -> Rule.rule ]*)
   fun p_rule syn worlds = raise Match

   (*[ val p_decl: Pos.t -> syn -> SetX.set -> (Decl.decl * SetX.set) ]*)
   fun p_decl pos syn worlds = 
      case syn of 
         Ascribe ((_, id), syn) => 
         let      
            val id = Symbol.fromValue id

            (*[ val pi: 
                   Pos.t
                   -> syn * Decl.class
                   -> Decl.class ]*)
            fun pi pos (Ascribe ((_, x), syn), class) = 
                let val t = p_t syn in 
                   case class of 
                      Decl.World (p, w, class) => 
                      Decl.World (p, w, Class.Arrow (t, class))
                    | Decl.Const (p, c, class) => 
                      Decl.Const (p, c, Class.Arrow (t, class))
                    | Decl.Rel (p, r, class) => 
                      Decl.Rel (p, r, Class.Pi (Symbol.fromValue x, t, class))
                    | Decl.Type _ => 
                      raise SyntaxError 
                         (SOME pos,
                          "Dependent types `{...} type` not allowed")
               end
             | pi pos (syn, _) = 
               raise SyntaxError 
                  (SOME (getpos syn),
                   "Pi-bindings `{...}` must be of the form `{x:t}`")

            (*[ val arrow: 
                   Pos.t
                   -> Symbol.symbol * Decl.class
                   -> Decl.class ]*)
            fun arrow pos (t, class) =
               case class of 
                  Decl.World (p, w, class) => 
                  Decl.World (p, w, Class.Arrow (t, class))
                | Decl.Const (p, c, class) => 
                  Decl.Const (p, c, Class.Arrow (t, class))
                | Decl.Rel (p, r, class) => 
                  Decl.Rel (p, r, Class.Arrow (t, class))
                | Decl.Type _ => 
                  raise SyntaxError 
                     (SOME pos,
                      "Dependent types `t -> type` not allowed")

            (*[ val class: syn -> Decl.class ]*)
            fun class syn =
               case syn of
                  Arrow (syn1, syn2) => 
                  arrow pos (p_t syn1, class syn2)
                | Pi (left, syn1, right, syn2) =>
                  pi (Pos.union left right) (syn1, class syn2)
                | App ((pos, t), []) => 
                  Decl.Const (pos, id, Class.Base (Symbol.fromValue t))
                | World _ => 
                  Decl.World (pos, id, Class.World)
                | At (Rel _, syn) => 
                  Decl.Rel (pos, id, Class.Rel (p_world syn worlds))
                | At (syn, _) => 
                  raise SyntaxError
                     (SOME (getpos syn), 
                      "Non-`rel` to the left of `@` in a classifier")
                | _ => 
                  raise SyntaxError
                     (SOME (getpos syn), 
                      "Not a valid classifier")

            val decl = class syn
            val worlds' = 
               case decl of 
                  Decl.World (_, w, _) => SetX.insert worlds w
                | _ => worlds
         in
            (decl, worlds')
         end

       | Assign ((_, id), At (syn1, syn2)) => 
         let 
            (*[ val p_props: syn -> (Pos.t * Atom.ground_prop) list ]*)
            fun p_props (Conj (syn1, syn2)) = p_props syn1 @ p_props syn2
              | p_props syn = [ p_ground_prop syn worlds ]
         in 
            (Decl.DB 
                (pos, Symbol.fromValue id, 
                 p_props syn1, 
                 p_ground_world syn2 worlds),
             worlds)
         end

       | Assign (id, syn) => 
         raise SyntaxError  
            (SOME (getpos syn),
             "Database assignment not of the form (...) @ ...")

       | Arrow (syn1, syn2) =>
         (case p_world' syn2 worlds of
             NONE => (Decl.Rule (pos, p_rule syn worlds), worlds)
           | SOME (p, world) => 
             let 
                (*[ val p_worlds: syn -> (Pos.t * Atom.world) list ]*)
                fun p_worlds (Conj (syn1, syn2)) = p_worlds syn1 @ p_worlds syn2
                  | p_worlds syn = [ p_world syn worlds ]
             in
                (Decl.Depends (pos, (p, world), p_worlds syn1), worlds)
             end)
                    
       | App _ =>
         (case p_world' syn worlds of 
             NONE => (Decl.Rule (pos, p_rule syn worlds), worlds)
           | SOME (p, world) => (Decl.Depends (pos, (p, world), []), worlds))

       | _ => raise SyntaxError (SOME pos, "Invalid toplevel statement")

   (*[ val parse': 
         Token.t Stream.stream 
         -> SetX.set 
         -> unit 
         -> Decl.decl Stream.front ]*)
   fun parse' stream worlds () = 
      case Stream.front stream of 
         Stream.Nil => Stream.Nil
       | Stream.Cons _ => 
         let 
            val (syndecl, stream') = Parse.parse stream 
         in
            case syndecl of 
               Query (left, (_, name), (_, a), modes, right) => 
               let 
                  val name = Symbol.fromValue name
                  val modes = (Symbol.fromValue a,
                               map (fn mode => Term.Mode (mode, NONE)) modes)
                  val decl = Decl.Query (Pos.union left right, name, modes) 
               in 
                  Stream.Cons (decl, Stream.lazy (parse' stream' worlds))
               end
             | Syn (syn, pos) => 
               let
                  val pos = Pos.union (getpos syn) pos
                  val (decl, worlds') = p_decl pos syn worlds
               in
                  Stream.Cons (decl, Stream.lazy (parse' stream' worlds'))
               end
         end

   (*[ val parse: Token.t Stream.stream -> Decl.decl Stream.stream ]*)
   fun parse stream = Stream.lazy (parse' stream SetX.empty)
         
end
