structure Parser:> 
sig
   exception SyntaxError of Pos.t option * string
   exception TypeError of Pos.t * string
   
   (*[ val parse: Token.t Stream.stream -> Decl.decl Stream.stream ]*)
   val parse: Token.t Stream.stream -> Decl.t Stream.stream
end = struct

   exception SyntaxError of Pos.t option * string
   exception TypeError of Pos.t * string

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
       | Uscore of Pos.t
       | Not of Pos.t * syn
       | World of Pos.t
       | Type of Pos.t
       | Extensible of Pos.t
       | Rel of Pos.t
       | Num of Pos.t * IntInf.int
       | String of Pos.t * string
       | Paren of Pos.t * syn * Pos.t

      fun strip (Paren (_, syn, _)) = strip syn
        | strip syn = syn

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
          | Uscore pos => pos
          | Not (pos, syn) => Pos.union pos (getpos syn)
          | World pos => pos
          | Type pos => pos
          | Extensible pos => pos
          | Rel pos => pos
          | Num (pos, _) => pos
          | String (pos, _) => pos
          | Paren (pos1, _, pos2) => Pos.union pos1 pos2

      fun str syn = 
         case syn of 
            Ucid (_, s) => s
          | Ascribe ((_, x), syn) => "(" ^ x ^ " : " ^ str syn ^ ")"
          | Assign ((_, x), syn) => "(" ^ x ^ " = " ^ str syn ^ ")"
          | Arrow (syn1, syn2) => "(" ^ str syn1 ^ " -> " ^ str syn2 ^ ")"
          | Conj (syn1, syn2) => "(" ^ str syn1 ^ " , " ^ str syn2 ^ ")"
          | At (syn1, syn2) => "(" ^ str syn1 ^ " @ " ^ str syn2 ^ ")"
          | Binrel (b, syn1, syn2) => 
               "(" ^ str syn1 ^ " " ^ Binrel.toString b ^ " " ^ str syn2 ^ ")"
          | App ((_, x), []) => x
          | App ((_, x), syns) => 
               "(" ^ x ^ " " ^ String.concatWith " " (map str syns) ^ ")"
          | Pi (_, syn1, _, syn2) => 
               "({ " ^ str syn1 ^ " : ... } " ^ str syn2 ^ ")"
          | Ex (_, (_, x), syn) =>
               "(Ex " ^ x ^ " . " ^ str syn ^ ")"
          | Uscore pos => "_"
          | Not (pos, syn) => "(not " ^ str syn ^ ")"
          | World pos => "world"
          | Type pos => "type"
          | Extensible pos => "extensible"
          | Rel pos => "rel" 
          | Num (_, n) => IntInf.toString n 
          | String (_, s) => "\"" ^ s ^ "\"" 
          | Paren (_, syn, _) => "(" ^ str syn ^ ")"

      type sings = syn list      
      datatype decl = 
          Syn of syn * Pos.t * decl
        | PragmaQuery of
             Pos.t 
             * (Pos.t * string)  
             * (Pos.t * string) 
             * Mode.t list
             * Pos.t
             * decl
        | PragmaType of
             Pos.t 
             * (Pos.t * string)  
             * (Pos.t * string) 
             * Pos.t
             * decl
        | Done of unit

      fun error s = 
         case Stream.front s of 
            Stream.Nil => SyntaxError (NONE, "Syntax error at end of file")
          | Stream.Cons (tok, pos) => 
            SyntaxError (SOME (Token.pos tok), "Unexpected token")

      val ascribe_ucid = Ascribe
      fun larrow (syn1, syn2) = Arrow (syn2, syn1)
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
      fun sings_end () = []
      val var = Ucid
      fun sings_cons (syn, sings) = syn :: sings
      fun sings_lcid (lcid, sings) = App (lcid, []) :: sings
      fun mode_end () = []
      fun mode_input  modes = Mode.Input :: modes
      fun mode_output modes = Mode.Output :: modes
      fun mode_ignore modes = Mode.Ignore :: modes 
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
      PS { worlds = worlds, rels = SetX.insert rels x} 

   fun rels (PS {rels, ...}) = rels
  
   (*[ val p_t: syn -> Symbol.symbol ]*)
   fun p_t syn = 
      case strip syn of 
         App ((_, t), []) => Symbol.fromValue t
       | _ => raise SyntaxError (SOME (getpos syn), 
                                 "Ill-formed simple type `" 
                                 ^ str syn ^ "`")

   (*[ val p_ground: syn -> Term.ground ]*)
   fun p_ground syn = 
      case strip syn of 
         App ((_, c), []) => Term.SymConst (Symbol.fromValue c)
       | App ((_, c), syns) => 
         Term.Root (Symbol.fromValue c, map p_ground syns)
       | Num (_, n) => Term.NatConst n
       | String (_, s) => Term.StrConst s
       | Ucid (pos, x) => 
         raise SyntaxError (SOME pos, "Free variable in ground term")
       | Uscore pos => 
         raise SyntaxError (SOME pos, "Underscore in ground term")
       | _ => 
         raise SyntaxError (SOME (getpos syn), "Ill-formed term `" 
                                               ^ str syn ^ "`")

   (*[ val p_term: syn -> Term.term ]*)
   fun p_term syn = 
      case strip syn of 
         App ((_, c), []) => Term.SymConst (Symbol.fromValue c)
       | App ((_, c), syns) => 
         Term.Root (Symbol.fromValue c, map p_term syns)
       | Num (_, n) => Term.NatConst n
       | String (_, s) => Term.StrConst s
       | Ucid (_, x) => Term.Var (SOME (Symbol.fromValue x), NONE)
       | Uscore _ => Term.Var (NONE, NONE)
       | _ => raise SyntaxError (SOME (getpos syn), "Ill-formed term `" 
                                                    ^ str syn ^ "`")

   (*[ val p_world: syn -> psig -> (Pos.t * Atom.world) ]*)
   fun p_world syn psig = 
      case strip syn of 
         App ((pos, x), syns) =>
         let val w = Symbol.fromValue x in 
            if isWorld psig w
            then (getpos syn, (w, map p_term syns))
            else raise TypeError 
               (pos, 
                "Not a declared world constant: `" ^ x ^ "`")
         end
       | _ => raise SyntaxError (SOME (getpos syn), "Ill-formed world `"
                                                    ^ str syn ^ "`")

   (*[ val p_prop: syn -> psig -> Atom.prop ]*)
   fun p_prop syn psig = 
      case strip syn of 
         App ((pos, x), syns) =>
         let val a = Symbol.fromValue x in 
            if isRel psig a
            then (a, map p_term syns)
            else raise TypeError 
               (pos, 
                "Not a declared relation constant: `" ^ x ^ "`")
         end
       | _ => raise SyntaxError (SOME (getpos syn), "Ill-formed atomic\ 
                                                    \ proposition `" ^ str syn
                                                    ^ "`")

   (*[ val p_ground_world: syn -> psig -> (Pos.t * Atom.ground_world) ]*)
   fun p_ground_world syn psig =
      case strip syn of 
         App ((pos, x), syns) =>
         let val w = Symbol.fromValue x in 
            if isWorld psig w
            then (getpos syn, (w, map p_ground syns))
            else raise TypeError 
               (pos, 
                "Not a declared world constant: `" ^ x ^ "`")
         end
       | _ => raise SyntaxError (SOME (getpos syn), "Ill-formed world `"
                                                    ^ str syn ^ "`")

   (*[ val p_ground_prop: syn -> psig -> (Pos.t * Atom.ground_prop) ]*)
   fun p_ground_prop syn psig = 
      case strip syn of 
         App ((pos, x), syns) =>
         let val a = Symbol.fromValue x in 
            if isRel psig a
            then (getpos syn, (a, map p_ground syns))
            else raise TypeError 
               (pos, 
                "Not a declared relation constant: `" ^ x ^ "`")
         end
       | _ => raise SyntaxError (SOME (getpos syn), "Ill-formed atomic\ 
                                                    \ proposition `" ^ str syn
                                                    ^ "`")

   (*[ val p_rule: syn -> psig -> Rule.rule ]*)
   fun p_rule syn psig: Rule.t = 
      let
         (*[ p_pat: syn -> Pat.pat ]*)
         fun p_pat syn = 
            case strip syn of 
               Ex (_, (_, x), syn) => 
               Pat.Exists (Symbol.fromValue x, NONE, p_pat syn)
             | Conj (syn1, syn2) => 
               raise SyntaxError 
                  (SOME (getpos syn),
                   "Existential quantifiers cannot span conjunctions \ 
                   \(unimplemented)") 
             | syn => Pat.Atom (p_prop syn psig)

         (*[ val p_prem: syn -> Prem.prem ]*)
         fun p_prem syn = 
            case strip syn of 
               Not (_, syn) => Prem.Negated (p_pat syn)
             | Binrel (br, syn1, syn2) => 
               Prem.Binrel (br, p_term syn1, p_term syn2, NONE)
             | syn => Prem.Normal (p_pat syn) 

         (*[ val p_prems: syn -> (Pos.t * Prem.prem) list ]*)
         fun p_prems syn = 
            case strip syn of 
               Conj (syn1, syn2) => p_prems syn1 @ p_prems syn2
             | syn => [ (getpos syn, p_prem syn) ]

         (*[ val p_concs: syn -> (Pos.t * Atom.prop) conslist ]*)
         fun p_concs syn =
            case strip syn of 
               Conj (syn1, syn2) => p_concs syn1 @ p_concs syn2
             | syn => [ (getpos syn, p_prop syn psig) ]
      in
         case strip syn of
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
                   fun p_arg (Ucid (_, x)) = (Symbol.fromValue x, NONE)
                     | p_arg (Ascribe ((_, x), syn)) = 
                          (Symbol.fromValue x, SOME (p_t syn))
                     | p_arg syn = 
                          (* Think this is dead code -rjs Oct 21 2011 *)
                          raise SyntaxError 
                             ( SOME pos
                             , "Pi-bindings `{...}` must be of the form\
                               \ `{x:t}`, got `" ^ str syn ^ "`")

                   val (x, t) = p_arg arg 
                   fun ty () = 
                      case t of 
                         NONE => 
                         raise SyntaxError 
                                 (SOME pos, 
                                  "Cannot infer type of bound variable `" 
                                  ^ Symbol.toValue x ^ "`")
                       | SOME t => t
                in 
                   case class of 
                      Decl.World (p, w, class) => 
                         Decl.World (p, w, Class.Arrow (ty (), class))
                    | Decl.Const (p, c, class) => 
                         Decl.Const (p, c, Class.Arrow (ty (), class))
                    | Decl.Rel (p, r, class) =>   
                        (case t of 
                            NONE => Decl.Rel (p, r, Class.Pi (x, t, class))
                          | SOME t' => 
                               if SetX.member (Class.fv class) x 
                               then Decl.Rel (p, r, Class.Pi (x, t, class))
                               else Decl.Rel (p, r, Class.Arrow (t', class)))
                    | Decl.Type _ => 
                         raise SyntaxError 
                            ( SOME pos
                            , "Declared types can only be classified by `type`\
                              \ or `extensible`")
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
                      "Declared types can only be classified by `type` or\
                      \ `extensible`")

            (*[ val class: syn -> Decl.class ]*)
            fun class syn =
               case strip syn of
                  Arrow (syn1, syn2) => 
                  arrow pos (p_t syn1, class syn2)
                | Pi (left, syn1, right, syn2) =>
                  pi (Pos.union left right) (syn1, class syn2)
                | App ((pos, t), []) => 
                  Decl.Const (pos, id, Class.Base (Symbol.fromValue t))
                | World _ => 
                  Decl.World (pos, id, Class.World)
                | Type _ => 
                  Decl.Type (pos, id, Class.Type)
                | Extensible _ => 
                  Decl.Type (pos, id, Class.Extensible)
                | At (syn1, syn2) => 
                  (case strip syn1 of 
                      Rel _ => 
                         Decl.Rel (pos, id, Class.Rel (p_world syn2 psig))
                    | _ => raise SyntaxError
                         (SOME (getpos syn1), 
                          "Expected-`rel` to the left of `@` in a classifier,\
                          \ got `" ^ str syn1 ^ "`"))
                | Rel pos => 
                     Decl.Rel (pos, id, 
                               Class.Rel (pos, (Symbol.fromValue "world", []))) 
                | _ => 
                  raise SyntaxError
                     (SOME (getpos syn), 
                      "Not a valid classifier: `" ^ str syn ^ "`")

            val decl = class syn
            val psig' = 
               case decl of 
                  Decl.World (_, w, _) => addWorld psig w
                | Decl.Rel (_, a, _) => addRel psig a
                | _ => psig
         in
            (decl, psig')
         end

       | Assign ((_, id), syn) => 
         let 
            (*[ val p_props: syn -> (Pos.t * Atom.ground_prop) list ]*)
            fun p_props syn =
               case strip syn of 
                  Conj (syn1, syn2) => p_props syn1 @ p_props syn2
                | _ => [ p_ground_prop syn psig ]
         in 
            (Decl.DB (pos, (Symbol.fromValue id, p_props syn)), psig)
         end

       | Arrow (syn1, syn2) => (Decl.Rule (pos, p_rule syn psig, NONE), psig)
                    
       | App _ => (Decl.Rule (pos, p_rule syn psig, NONE), psig)

       | _ => raise SyntaxError (SOME pos, "Ill-formed top-level statement `"
                                           ^ str syn ^ "`")

   (*[ val parse': decl -> psig -> unit -> Decl.decl Stream.front ]*)
   fun parse' decl psig () = 
      let 
         (*[ val stream_cons: Decl.decl * Decl.decl Stream.stream
                -> Decl.decl Stream.front ]*)
         val stream_cons = Stream.Cons

         (*[ val stream_lazy: (unit -> Decl.decl Stream.front)
                -> Decl.decl Stream.stream ]*)
         val stream_lazy = Stream.lazy
      in 
         case decl of 
            Done () => Stream.Nil
          | PragmaQuery (left, (_, name), (_, a), modes, right, decl') => 
            let 
               val name = Symbol.fromValue name
               val modes = (Symbol.fromValue a,
                            map (fn mode => Term.Mode (mode, NONE)) modes)
               val decl = Decl.Query (Pos.union left right, name, modes) 
            in 
               stream_cons (decl, stream_lazy (parse' decl' psig))
            end
          | PragmaType (left, (_, typ), (_, directive), right, decl') =>
            let
               fun msg () =  
                  ( "Types can be transparent, hashconsed, external, or\
                  \ sealed, I don't know how to make them `" ^ directive ^ "`")
               val directive = 
                   case directive of
                      "transparent" => Type.Transparent
                    | "hashconsed" => Type.HashConsed
                    | "external" => Type.External
                    | "sealed" => Type.Sealed
                    | _ => raise SyntaxError 
                              (SOME (Pos.union left right), msg ())
            in
               stream_cons ( Decl.Representation 
                                ( Pos.union left right
                                , Symbol.fromValue typ
                                , directive)
                           , stream_lazy (parse' decl' psig))
            end
          | Syn (syn, pos, decl') => 
            let
               val pos = Pos.union (getpos syn) pos
               val (decl, psig') = p_decl pos syn psig
            in
               stream_cons (decl, stream_lazy (parse' decl' psig'))
            end
      end

   (*[ val parse: Token.t Stream.stream -> Decl.decl Stream.stream ]*)
   fun parse stream = 
      let
         val worlds = 
            Tab.fold (fn (w, _, set) => SetX.insert set w) SetX.empty Tab.worlds
         val rels = 
            Tab.fold (fn (r, _, set) => SetX.insert set r) SetX.empty Tab.rels
         val init = PS { worlds = worlds, rels = rels}
      in 
         (Stream.lazy 
            (*[ <: (unit -> Decl.decl Stream.front)
                     -> Decl.decl Stream.stream ]*)) 
            (parse' (#1 (Parse.parse stream)) init)
      end
end
