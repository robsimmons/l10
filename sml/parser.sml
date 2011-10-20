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
      type pos_int = Pos.t * IntInf.int
      type modes = Mode.t list
      datatype terminal = datatype Token.t

      datatype syn = 
         Ucid of Pos.t * string
       | Ascribe of (Pos.t * string) * syn
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
       | Not of Pos.t * syn
       | World of Pos.t
       | Type of Pos.t
       | Rel of Pos.t
       | Num of Pos.t * IntInf.int
       | String of Pos.t * string
       | Pos of Pos.t * syn

      fun getpos syn = 
         case syn of 
            Ucid (pos, _) => pos
          | Ascribe ((pos, _), syn) => Pos.union pos (getpos syn)
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
          | Not (pos, syn) => Pos.union pos (getpos syn)
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


   (* The "real" parser. One of the invariants maintained by the real parser
    * is that things parsed as Atom.world are always headed by a previously-
    * declared world, whereas things parsed as Atom.prop a. *)
   open Arg
   datatype psig = PS of { worlds: SetX.set, rels: SetX.set}
   fun isWorld (PS {worlds, ...}) x = SetX.member worlds x
   fun addWorld (PS {worlds, rels}) x = 
      PS { worlds = SetX.insert worlds x, rels = rels} 

   fun isRel (PS { rels, ...}) x = SetX.member rels x
   fun addRel (PS {worlds, rels}) x = 
      PS { worlds = SetX.insert worlds x, rels = rels} 

   fun rels (PS {rels, ...}) = rels
   val empty = PS { worlds = SetX.empty, rels = SetX.empty }
  
   (*[ val p_t: syn -> Symbol.symbol ]*)
   fun p_t syn = 
      case syn of 
         App ((_, t), []) => Symbol.fromValue t
       | _ => raise SyntaxError (SOME (getpos syn), "Expected a simple type")

   (*[ val p_ground: syn -> Term.ground ]*)
   fun p_ground syn = 
      case syn of 
         App ((_, c), []) => Term.SymConst (Symbol.fromValue c)
       | App ((_, c), syns) => 
         Term.Root (Symbol.fromValue c, map p_ground syns)
       | Num (_, n) => Term.NatConst n
       | String (_, s) => Term.StrConst s
       | Var (pos, x) => 
         raise SyntaxError (SOME pos, "Free variable in ground term")
       | Uscore pos => 
         raise SyntaxError (SOME pos, "Underscore in ground term")
       | _ =>
         raise SyntaxError (SOME (getpos syn), "Ill-formed term")

   (*[ val p_term: syn -> Term.term ]*)
   fun p_term syn = 
      case syn of 
         App ((_, c), []) => Term.SymConst (Symbol.fromValue c)
       | App ((_, c), syns) => 
         Term.Root (Symbol.fromValue c, map p_term syns)
       | Num (_, n) => Term.NatConst n
       | String (_, s) => Term.StrConst s
       | Var (_, x) => Term.Var (SOME (Symbol.fromValue x), NONE)
       | Uscore _ => Term.Var (NONE, NONE)
       | _ => raise SyntaxError (SOME (getpos syn), "Ill-formed term")

   (*[ val p_world': syn -> psig -> (Pos.t * Atom.world) option ]*)
   fun p_world' syn psig =
      case syn of 
         App ((_, x), syns) =>
         let val w = Symbol.fromValue x in 
            if isWorld psig w
            then SOME (getpos syn, (w, map p_term syns))
            else NONE
         end
       | _ => NONE


   (* XXX STYLE: Parsing worlds, props, ground worlds, and ground props with 
    * refinement types ends up being a bit cut-paste-y. -rjs Oct 12 2011 *)

   (*[ val p_world: syn -> psig -> (Pos.t * Atom.world) ]*)
   fun p_world syn psig = 
      case syn of 
         App ((pos, x), syns) =>
         let val w = Symbol.fromValue x in 
            if isWorld psig w
            then (getpos syn, (w, map p_term syns))
            else raise SyntaxError 
               (SOME pos, 
                "Not a declared world constant: `" ^ x ^ "`")
         end
       | _ => raise SyntaxError (SOME (getpos syn), "Not a valid world")

   (*[ val p_prop: syn -> psig -> Atom.prop ]*)
   fun p_prop syn psig = 
      case syn of 
         App ((pos, x), syns) =>
         let val a = Symbol.fromValue x in 
            if isRel psig a
            then (a, map p_term syns)
            else raise SyntaxError 
               (SOME pos, 
                "Not a declared relation constant: `" ^ x ^ "`")
         end
       | _ => raise SyntaxError (SOME (getpos syn), "Not a valid world")

   (*[ val p_ground_world: syn -> psig -> (Pos.t * Atom.ground_world) ]*)
   fun p_ground_world syn psig =
      case syn of 
         App ((pos, x), syns) =>
         let val w = Symbol.fromValue x in 
            if isWorld psig w
            then (getpos syn, (w, map p_ground syns))
            else raise SyntaxError 
               (SOME pos, 
                "Not a declared world constant: `" ^ x ^ "`")
         end
       | _ => raise SyntaxError (SOME (getpos syn), "Not a valid world")

   (*[ val p_ground_prop: syn -> psig -> (Pos.t * Atom.ground_prop) ]*)
   fun p_ground_prop syn psig = 
      case syn of 
         App ((pos, x), syns) =>
         let val a = Symbol.fromValue x in 
            if isRel psig a
            then (getpos syn, (a, map p_ground syns))
            else raise SyntaxError 
               (SOME pos, 
                "Not a declared relation constant: `" ^ x ^ "`")
         end
       | _ => raise SyntaxError (SOME (getpos syn), "Not a valid world")

   (*[ val p_rule: syn -> psig -> Rule.rule ]*)
   fun p_rule syn psig: Rule.t = 
      let
         (*[ p_pat: syn -> Pat.pat ]*)
         fun p_pat syn = 
            case syn of 
               Ex (_, (_, x), syn) => 
               Pat.Exists (Symbol.fromValue x, p_pat syn)
             | Conj (syn1, syn2) => 
               raise SyntaxError 
                  (SOME (getpos syn),
                   "Existential quantifiers cannot span conjunctions \ 
                   \(unimplemented)") 
             | syn => Pat.Atom (p_prop syn psig)

         (*[ val p_prem: syn -> Prem.prem ]*)
         fun p_prem syn = 
            case syn of 
               Not (_, syn) => Prem.Negated (p_pat syn)
             | Binrel (br, syn1, syn2) => 
               Prem.Binrel (br, p_term syn1, p_term syn2, NONE)
             | syn => Prem.Normal (p_pat syn) 

         (*[ val p_prems: syn -> (Pos.t * Prem.prem) list ]*)
         fun p_prems syn = 
            case syn of 
               Conj (syn1, syn2) => p_prems syn1 @ p_prems syn2
             | syn => [ (getpos syn, p_prem syn) ]

         (*[ val p_concs: syn -> (Pos.t * Atom.prop) list ]*)
         fun p_concs syn =
            case syn of 
               Conj (syn1, syn2) => p_concs syn1 @ p_concs syn2
             | syn => [ (getpos syn, p_prop syn psig) ]
      in
         case syn of
            Arrow (syn1, syn2) => (p_prems syn1, p_concs syn2)
          | _ => ([], p_concs syn)
      end

   (*[ val p_decl: Pos.t -> syn -> psig -> (Decl.decl * psig) ]*)
   fun p_decl pos syn psig = 
      case syn of 
         Ascribe ((_, id), syn) => 
         let      
            val id = Symbol.fromValue id

            (*[ val pi: 
                   Pos.t
                   -> syn * Decl.class
                   -> Decl.class ]*)
            fun pi pos (arg, class) = 
                let 
                   fun p_arg (Ucid (_, x)) = (x, NONE)
                     | p_arg (Ascribe ((_, x), syn)) = (x, SOME (p_t syn))
                     | p_arg _ = 
                       raise SyntaxError 
                          (SOME (getpos syn),
                           "Pi-bindings `{...}` must be of the form `{x:t}`")

                   val (x, t) = p_arg syn 
                   fun ty () = 
                      case t of 
                         NONE => 
                         raise SyntaxError 
                                 (SOME pos, 
                                  "Cannot infer type of bound variable `" 
                                  ^ x ^ "`")
                       | SOME t => t
                in 
                   case class of 
                      Decl.World (p, w, class) => 
                      Decl.World (p, w, Class.Arrow (ty (), class))
                    | Decl.Const (p, c, class) => 
                      Decl.Const (p, c, Class.Arrow (ty (), class))
                    | Decl.Rel (p, r, class) => 
                      Decl.Rel (p, r, Class.Pi (Symbol.fromValue x, t, class))
                    | Decl.Type _ => 
                      raise SyntaxError 
                         (SOME pos,
                          "Dependent types `{...} type` not allowed")
               end

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
                  Decl.Rel (pos, id, Class.Rel (p_world syn psig))
                | At (syn, _) => 
                  raise SyntaxError
                     (SOME (getpos syn), 
                      "Non-`rel` to the left of `@` in a classifier")
                | _ => 
                  raise SyntaxError
                     (SOME (getpos syn), 
                      "Not a valid classifier")

            val decl = class syn
            val psig' = 
               case decl of 
                  Decl.World (_, w, _) => addWorld psig w
                | Decl.Rel (_, a, _) => addRel psig a
                | _ => psig
         in
            (decl, psig')
         end

       | Assign ((_, id), At (syn1, syn2)) => 
         let 
            (*[ val p_props: syn -> (Pos.t * Atom.ground_prop) list ]*)
            fun p_props (Conj (syn1, syn2)) = p_props syn1 @ p_props syn2
              | p_props syn = [ p_ground_prop syn psig ]
         in 
            (Decl.DB (pos, 
                      (Symbol.fromValue id, 
                       p_props syn1,
                       p_ground_world syn2 psig)),
             psig)
         end

       | Assign (id, syn) => 
         raise SyntaxError  
            (SOME (getpos syn),
             "Database assignment not of the form (...) @ ...")

       | Arrow (syn1, syn2) =>
         (case p_world' syn2 psig of
             NONE => (Decl.Rule (pos, p_rule syn psig, NONE), psig)
           | SOME (p, world) => 
             let 
                (*[ val p_worlds: syn -> (Pos.t * Atom.world) list ]*)
                fun p_worlds (Conj (syn1, syn2)) = p_worlds syn1 @ p_worlds syn2
                  | p_worlds syn = [ p_world syn psig ]
             in
                (Decl.Depend (pos, ((p, world), p_worlds syn1), NONE), psig)
             end)
                    
       | App _ =>
         (case p_world' syn psig of 
             NONE => (Decl.Rule (pos, p_rule syn psig, NONE), psig)
           | SOME (p, world) => 
                (Decl.Depend (pos, ((p, world), []), NONE), psig))

       | _ => raise SyntaxError (SOME pos, "Invalid toplevel statement")

   (*[ val parse': 
         Token.t Stream.stream -> psig -> unit -> Decl.decl Stream.front ]*)
   fun parse' stream psig () = 
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
                  (*[ val modes: Atom.moded ]*)
                  val modes = (Symbol.fromValue a,
                               map (fn mode => Term.Mode (mode, NONE)) modes)
                  (*[ val decl: Decl.decl ]*)
                  val decl = Decl.Query (Pos.union left right, name, modes) 
                  (*[ val stream'': Decl.decl Stream.stream ]*)
                  val stream'' = Stream.lazy (parse' stream' psig)
               in 
                  Stream.Cons (decl, stream'')
               end
             | Syn (syn, pos) => 
               let
                  val pos = Pos.union (getpos syn) pos
                  (*[ val decl: Decl.decl ]*)
                  val (decl, psig') = p_decl pos syn psig
                  (*[ val stream'': Decl.decl Stream.stream ]*)
                  val stream'' = Stream.lazy (parse' stream' psig')
               in
                  Stream.Cons (decl, stream'')
               end
         end

   (*[ val parse: Token.t Stream.stream -> Decl.decl Stream.stream ]*)
   fun parse stream = Stream.lazy (parse' stream empty)
         
end
