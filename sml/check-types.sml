(* Type checking *)
(* Robert J. Simmons *)

structure Types :> sig
  
   exception TypeError of Pos.t * string

   (*[ val check: Decl.decl -> Decl.decl_t ]*)
   (* Takes a raw parsed declarations, makes sure scope, arity,
    * and simple types are all respected, and prevents duplicate definitions. 
    * May add new constants of extensible type to ConTab. *)
   val check: Decl.t -> Decl.t

end = struct

   exception TypeError of Pos.t * string


(* 
structure A = Ast
open Symbol

fun tc_database x = 
   if isSome (DbTab.find x)
   then raise Fail ("Database " ^ name x ^ " already defined")
   else ()




fun require typ1 typ2 = 
   if typ1 = typ2 then () 
   else raise Fail ("Expected a term of type " ^ name typ1 
                    ^ ", but found a constructor of type" ^ name typ2)

(* tc_term env (term, typ) - checks a term at a given type, and returns a
 * (potentially) larger context if it found any type variables that were
 * not already in the environment. *)
fun tc_term env (term, typ) = 
   case term of  
      A.Const c => 
      (case ConTab.find c of 
          NONE => (case TypeTab.find typ of
                      SOME TypeTab.YES => 
                      (ConTab.bind (c, ([], typ)); env)
                    | SOME TypeTab.CONSTANTS => 
                      (ConTab.bind (c, ([], typ)); env)
                    | _ => raise Fail ("Constant " ^ name c 
                                       ^ " not defined and type " ^ name typ
                                       ^ " not extensible."))
        | SOME ([], typ') => env
        | SOME (typs, typ') => 
          raise Fail ("Constant " ^ name c ^ " should have " 
                      ^ Int.toString (length typs) 
                      ^ " argument(s), was given none."))
    | A.NatConst n => (require typ TypeTab.nat; env)
    | A.StrConst s => (require typ TypeTab.string; env)
    | A.Structured (f, terms) => 
      (case ConTab.find f of
          NONE => (case TypeTab.find typ of
                      SOME TypeTab.YES => 
                      let val typs = List.tabulate (length terms, (fn _ => typ))
                      in 
                         ConTab.bind (f, (typs, typ))
                         ; tc_terms env (ListPair.zip (terms, typs))
                      end
                    | _ => raise Fail ("Function symbol " ^ name f
                                       ^ " not defined and type " ^ name typ
                                       ^ " not extensible."))
        | SOME (typs, typ') =>
          if length terms = length typs 
          then tc_terms env (ListPair.zip (terms, typs))
          else raise Fail ("Function symbol " ^ name f ^ " should have " 
                           ^ Int.toString (length typs)
                           ^ " argument(s), was given " 
                           ^ Int.toString (length terms) ^ "."))
    | A.Var NONE => env
    | A.Var (SOME x) =>  
      (case MapX.find (env, x) of 
          NONE => MapX.insert (env, x, SOME typ)
        | SOME NONE => MapX.insert (env, x, SOME typ)
        | SOME (SOME typ') => 
          if typ = typ' then env
          else raise Fail ("Variable " ^ name x ^ " has type " ^ name typ' 
                           ^ " but used where a term of type " ^ name typ
                           ^ " was expected."))

and tc_terms env [] = env
  | tc_terms env (tt :: tts) = tc_terms (tc_term env tt) tts

(* tc_term env (term, typ) - checks a world at a given type, and returns a
 * (potentially) larger context if it found any type variables that were
 * not already in the environment. *)
fun tc_world env (w, terms) = 
   case WorldTab.find w of
      NONE => raise Fail ("World " ^ name w ^ " not declared.")
    | SOME typs =>
      if length terms = length typs
      then tc_terms env (ListPair.zip (terms, typs))
      else raise Fail ("World " ^ name w ^ " given " 
                       ^ Int.toString (length terms) 
                       ^ " term arguments, but should have "
                       ^ Int.toString (length typs) ^ ".")

fun tc_worlds env [] = env
  | tc_worlds env (world :: worlds) = 
    tc_worlds (tc_world env world) worlds

fun tc_atomic env (r, terms) = 
   case RelTab.find r of
      NONE => raise Fail ("Relation " ^ name r ^ " not declared.")
    | SOME (args, world) => 
      if length terms = length args
      then tc_terms env (ListPair.zip (terms, map #2 args))
      else raise Fail ("Relation " ^ name r ^ " given " 
                       ^ Int.toString (length terms)
                       ^ " term arguments, but should have "
                       ^ Int.toString (length args) ^ ".") 

fun tc_atomics env [] = env
  | tc_atomics env (atomic :: atomics) = 
    tc_atomics (tc_atomic env atomic) atomics

fun tc_pattern env pat = 
   case pat of
      A.Atomic atomic => tc_atomic env atomic
    | A.One => env
    | A.Conj (pat1, pat2) => tc_pattern (tc_pattern env pat1) pat2
    | A.Exists (x, pat) => 
      let 
         val prev_x = MapX.find (env, x) 
         val new_env = tc_pattern (MapX.insert (env, x, NONE)) pat
      in
         case MapX.find (new_env, x) of
            SOME NONE => 
            raise Fail ("Variable " ^ name x ^ " introduced by existential"
                        ^ " quantifier but not used.")
          | SOME _ => () 
          | NONE => raise Fail "Invariant" 
         ; case prev_x of
              NONE => #1 (MapX.remove (env, x))
            | SOME v => MapX.insert (env, x, v)
      end

(* seek_typ env typs 
 * Takes a list of terms and tries to figure out what their type must be.
 *
 * All term checking is done by *checking,* which creates a problem for 
 * equality, which is inherently polymorphic. Mode checking will fail if
 * both variables in an equality are unknown, so we are okay in failing early
 * in this case. *)
fun seek_typ env [] = 
    raise Fail ("Could not discover type of arguments to (in)equality")
  | seek_typ env (term :: terms) =
    case term of
       A.Const c => 
       (case ConTab.find c of 
           NONE => (ignore (tc_term env (term, symbol "_unknown_"))
                    (* raises Fail *) 
                    ; raise Fail "Unreachable")
         | SOME (_, typ) => typ)
     | A.NatConst _ => TypeTab.nat
     | A.StrConst _ => TypeTab.string
     | A.Structured (f, _) =>
       (case ConTab.find f of
           NONE => (ignore (tc_term env (term, symbol "_unknown_"))
                    (* raises Fail *) 
                    ; raise Fail "Unreachable")
         | SOME (_, typ) => typ)
     | A.Var NONE => seek_typ env terms
     | A.Var (SOME x) => 
       (case MapX.find (env, x) of
           NONE => seek_typ env terms
         | SOME NONE => seek_typ env terms
         | SOME (SOME typ) => typ)

(* tc_eq env (term1, term2) 
 * Ensure that term1 and term2 have the same type. *)
fun tc_eq env (term1, term2) = 
   let val typ = seek_typ env [ term1, term2 ]
   in tc_term (tc_term env (term1, typ)) (term2, typ) end

fun tc_prem env prem = 
   case prem of 
      A.Normal pat => tc_pattern env pat
    | A.Negated pat => tc_pattern env pat
    | A.Count (pat, term) => tc_term (tc_pattern env pat) (term, TypeTab.nat)
    | A.Binrel (A.Eq, term1, term2) => tc_eq env (term1, term2)
    | A.Binrel (A.Neq, term1, term2) => tc_eq env (term1, term2)
    | A.Binrel (_, term1, term2) => 
      tc_term (tc_term env (term1, TypeTab.nat)) (term2, TypeTab.nat)

fun tc_prems env [] = env 
  | tc_prems env (prem :: prems) =
    tc_prems (tc_prem env prem) prems

fun checkDecl decl = 
   case decl of 
      (* Types are well-formed 
       * if they haven't been declared already *)
      A.DeclType typ => tc_namespace ("Type", typ)

      (* Worlds are well-formed 
       * if they haven't been declared already
       * and if all their indices are valid types *)
    | A.DeclWorld (w, args) => 
      (tc_namespace ("World", w)
       ; ignore (tc_args args))

      (* Constant declarations are well-formed 
       * if they haven't been declared already
       * and if their indices are valid types *)
    | A.DeclConst (c, args, typ) => 
      (tc_namespace ("Constant", c)
       ; ignore (tc_args args) 
       ; tc_typ typ)

      (* Relations declarations are well-formed
       * if they haven't been declared already
       * if their indices are valid types
       * if the associated world is valid under (only) the named indices *)
    | A.DeclRelation (r, args, world) =>
      let
         val () = tc_namespace ("Relation", r)
         val env = tc_args args 
         val env' = tc_world env world
         val newenv = 
            MapX.filteri (fn (x, _) => not (MapX.inDomain (env, x))) env'
      in
         case MapX.firsti newenv of
            NONE => ()
          | SOME (x, _) => 
            raise Fail ("Variable " ^ name x 
                        ^ " used in world but not bound." )
      end

      (* Dependencies are well-formed 
       * if all of their sub-worlds are well-formed. *)
    | A.DeclDepends (world, worlds) => 
      ignore (tc_worlds (tc_world MapX.empty world) worlds)

      (* Rules are well-formed 
       * if all of their sub-propositions are well-formed 
       * if all existential variables are used at least once so that we
       * know their type. *)
    | A.DeclRule (prems, concs) => 
      ignore (tc_prems (tc_atomics MapX.empty concs) prems)

      (* Databases are well-formed
       * If their world includes no free variables and are well formed
       * If the premises include no free variables and are well formed *)
    | A.DeclDatabase (db, prems, world) => 
      let 
         val () = tc_database db
         val env = tc_atomics (tc_world MapX.empty world) prems 
      in
         case MapX.firsti env of
            NONE => ()
          | SOME (x, _) =>
            raise Fail ("Free variables aren't allowed in database"
                        ^ " declarations, but " ^ name x ^ " was free.")
      end

(* tc_args args - checks that types are defined, returns bound variables *)
fun tc_args' (map, []) = map
  | tc_args' (map, (NONE, typ) :: args) = 
    (tc_typ typ; tc_args' (map, args))
  | tc_args' (map, (SOME x, typ) :: args) = 
    (tc_typ typ; tc_args' (MapX.insert (map, x, SOME typ), args))
fun tc_args args = tc_args' (MapX.empty, args)

*)

(* Utility function for requiring two types to be equal *)
fun require pos typ1 typ2 = 
   if Symbol.eq (typ1, typ2) then () 
   else raise TypeError (pos, "Expected a term of type " ^ Symbol.toValue typ1 
                              ^ ", but found a constructor of type" 
                              ^ Symbol.toValue typ2)


(*[ sortdef env = Symbol.symbol option DictX.dict ]*)

(*[ val tc_t: Pos.t -> Symbol.symbol -> unit ]*)
fun tc_t pos t = 
   if Tab.member Tab.types t then () 
   else raise TypeError (pos, "Type " ^ Symbol.toValue t ^ " not declared.")


(*[ val tc_namespace: Pos.t -> string -> Symbol.symbol -> unit ]*)
(* Avoid double definition for the namespace that is shared by everything
 * except for database declarations. *)
fun tc_namespace pos syntax x = 
   let 
      fun doubledef s = 
         syntax ^ " `" ^ Symbol.toValue x ^ "` already declared as a " ^ s
      fun illegalId s = 
         syntax ^ " identifier `" ^ Symbol.toValue x ^ "` contains " ^ s
   in 
      if Tab.member Tab.types x
      then raise TypeError (pos, doubledef "type")
      else if Tab.member Tab.worlds x
      then raise TypeError (pos, doubledef "world")
      else if Tab.member Tab.rels x
      then raise TypeError (pos, doubledef "relation")
      else if Tab.member Tab.consts x
      then raise TypeError (pos, doubledef "term constructor")
      else if String.isSubstring "_" (Symbol.toValue x)
      then raise TypeError (pos, illegalId "underscore")
      else if String.isSubstring "'" (Symbol.toValue x)
      then raise TypeError (pos, illegalId "single-quote")
      else ()
   end


(* Checks a term at a given type, and returns a (potentially) larger context if
 * it found any type variables that were not already in the environment.
 * It is an invariant that the types passed as arguments are already
 * well-formed. *)

(*[ val tc_term: Pos.t -> env -> Symbol.symbol -> 
       ( Term.term -> env * Term.term_t
       & Term.ground -> env * Term.ground
       & Term.moded -> env * Term.moded_t) ]*)

(*[ val tc_spine: Pos.t -> env -> Symbol.symbol -> 
       ( Class.typ ->
          ( Term.term conslist -> env * Symbol.symbol * Term.term_t conslist
          & Term.term list     -> env * Symbol.symbol * Term.term_t list
          & Term.ground conslist -> env * Symbol.symbol * Term.ground conslist
          & Term.ground list     -> env * Symbol.symbol * Term.ground list
          & Term.moded conslist -> env * Symbol.symbol * Term.moded_t conslist
          & Term.moded list     -> env * Symbol.symbol * Term.moded_t list)
       & Class.rel_t -> 
          ( Term.term list -> env * Symbol.symbol * Term.term_t list)
       & Class.world -> 
          ( Term.term list -> env * Symbol.symbol * Term.term_t list))]*)

fun tc_term pos env typ term = 
   case term of  
      Term.SymConst c => 
      (case Tab.find Tab.consts c of 
          NONE => (case Tab.lookup Tab.types typ of
                      Class.Extensible =>  
                         ( Tab.bind (Decl.Const (pos, c, Class.Base typ))
                         ; (env, Term.SymConst c))
                    | _ => raise TypeError (pos, "Constant `"
                                                 ^ Symbol.toValue c
                                                 ^ "` not declared and type `"
                                                 ^ Symbol.toValue typ 
                                                 ^ "` not extensible"))
        | SOME (Class.Base typ') => 
             if Symbol.eq (typ, typ') then (env, Term.SymConst c)
             else raise TypeError (pos, "Constant `" ^ Symbol.toValue c 
                                        ^ "` has type `" ^ Symbol.toValue typ'
                                        ^ "`, but a term of type `" 
                                        ^ Symbol.toValue typ
                                        ^ "` was expected")
        | SOME class => 
             raise TypeError (pos, "Function symbol `" ^ Symbol.toValue c
                                   ^ "` expected" 
                                   ^ Int.toString (Class.arrows class) 
                                   ^ " argument(s), was given none"))
    | Term.NatConst n => (require pos typ Type.nat; (env, Term.NatConst n))
    | Term.StrConst s => (require pos typ Type.string; (env, Term.StrConst s))
    | Term.Root (f, spine) => 
      (case Tab.find Tab.consts f of
          NONE => raise TypeError (pos, "Function symbol " ^ Symbol.toValue f
                                        ^ " not defined")
        | SOME class => 
          let 
             val (env', typ', spine_t) = tc_spine pos env f class spine
          in 
             if Symbol.eq (typ, typ') 
             then (env', Term.Root (f, spine_t))
             else raise TypeError (pos, "Term `" ^ Symbol.toValue f 
                                        ^ " ...` has type `" 
                                        ^ Symbol.toValue typ'
                                        ^ "`, but a term of type `" 
                                        ^ Symbol.toValue typ
                                        ^ "` was expected")
          end)
    | Term.Var (NONE, NONE) => (env, Term.Var (NONE, SOME typ))
    | Term.Var (SOME x, NONE) => 
      (case DictX.find env x of
          NONE => 
             (DictX.insert env x (SOME typ), Term.Var (SOME x, SOME typ))
        | SOME NONE => 
             (DictX.insert env x (SOME typ), Term.Var (SOME x, SOME typ))
        | SOME (SOME typ') => 
             if Symbol.eq (typ, typ') 
             then (env, Term.Var (SOME x, SOME typ))
             else raise TypeError (pos, "Variable `" ^ Symbol.toValue x
                                        ^ "` elsewhere given type `" 
                                        ^ Symbol.toValue typ' ^ "`, but here\
                                        \ a term of type `" 
                                        ^ Symbol.toValue typ 
                                        ^ "` was expected"))
    | Term.Mode (m, NONE) => (env, Term.Mode (m, SOME typ))

(* RJS Oct 18 2011 - is it okay that I'm leaving out the part where I 
 * substitue pi-bound types into the kind? This is, as a result, basically just
 * doing simple type checking, but I think that's what I want to be doing. *)
and tc_spine pos env f class terms = 
   let fun toomany w = 
         TypeError (pos, w ^ " `" ^ Symbol.toValue f 
                               ^ "` given " ^ Int.toString (length terms) 
                               ^ " too many arguments")
   in 
      case (class, terms) of 
         (Class.Base t', []) => (env, t', [])
       | (Class.World, []) => (env, Type.world, [])
       | (Class.Rel _, []) => (env, Type.rel, [])
       | (Class.Arrow (t, class), term1 :: terms) =>
         let 
            val (env', term1') = tc_term pos env t term1 
            val (env'', t', terms') = tc_spine pos env' f class terms
         in
            (env'', t', term1' :: terms')
         end
       | (Class.Pi (_, SOME t, class), term1 :: terms) =>
         let 
            val (env', term1') = tc_term pos env t term1 
            val (env'', t', terms') = tc_spine pos env' f class terms
         in
            (env'', t', term1' :: terms')
         end
       | (Class.Base _, _) => raise toomany "Function symbol" 
       | (Class.World, _) => raise toomany "World "
       | (Class.Rel _, _) => raise toomany "Predicate "
       | (Class.Arrow (t, class), []) =>
            raise TypeError (pos, "Not enough arguments for `" 
                                  ^ Symbol.toValue f ^ "`")
       | (Class.Pi (_, SOME t, class), []) =>
            raise TypeError (pos, "Not enough arguments for `" 
                                  ^ Symbol.toValue f ^ "`")
   end
       

(*[ val tc_class: Pos.t -> env -> ( Class.world -> env * Class.world 
                                  & Class.typ -> env * Class.typ
                                  & Class.rel -> env * Class.rel_t
                                  & Class.knd -> env * Class.knd) ]*)
fun tc_class pos env class = 
   case class of 
      Class.Base t => 
         ( tc_t pos t
         ; (env, Class.Base t))
    | Class.Rel (pos, (w, terms)) =>
      (case Tab.find Tab.worlds w of 
          NONE => raise TypeError (pos, "World `" ^ Symbol.toValue w 
                                        ^ "` not declared")
        | SOME class => 
          let val (env', _, terms') = tc_spine pos env w class terms in
             (env', Class.Rel (pos, (w, terms')))
          end)
    | Class.World => (env, Class.World)
    | Class.Type => (env, Class.Type)
    | Class.Builtin => (env, Class.Builtin)
    | Class.Extensible => (env, Class.Extensible)
    | Class.Arrow (t, class) => 
      let val (env, class) = tc_class pos env class in
         ( tc_t pos t
         ; (env, Class.Arrow (t, class)))
      end
    | Class.Pi (x, t_ish, class) =>
      let 
         val oldt = DictX.find env x 
         val () = case t_ish of NONE => () | SOME t => tc_t pos t
         val (env, class) = tc_class pos (DictX.insert env x t_ish) class
         val boundty =
            case DictX.find env x of 
               NONE => raise TypeError (pos, "Internal invariant broken")
             | SOME NONE =>
                  raise TypeError (pos, "Cannot infer type of bound variable `" 
                                        ^ Symbol.toValue x ^ "`")
             | SOME (SOME ty) => ty
         val env = 
            case oldt of
               NONE => DictX.remove env x
             | SOME t => DictX.insert env x t
      in 
        (env, Class.Pi (x, SOME boundty, class))
      end


(*[ val tc_closed_class: Pos.t -> ( Class.world -> Class.world 
                                  & Class.typ -> Class.typ
                                  & Class.rel -> Class.rel_t
                                  & Class.knd -> Class.knd) ]*)
fun tc_closed_class pos class = 
   let val (env, class) = tc_class pos DictX.empty class in
      case DictX.toList env of
         [] => class
       | (x, _) :: _ => raise TypeError (pos, "Variable `" ^ Symbol.toValue x 
                                              ^ "` free in classifier.")  
   end


(*[ val check: Decl.decl -> Decl.decl_t ]*)
fun check decl = 
   case decl of 
      Decl.Type (pos, t, class) => 
         ( tc_namespace pos "Type" t
         ; Decl.Type (pos, t, tc_closed_class pos class))

    | Decl.World (pos, w, class) => 
         ( tc_namespace pos "World" w
         ; Decl.World (pos, w, tc_closed_class pos class))

    | Decl.Const (pos, c, class) => 
      let val class = tc_closed_class pos class in
         ( tc_namespace pos "Constant" c
         ; case (Tab.lookup Tab.types (Class.base class), class) of
              (Class.Extensible, Class.Base _) => ()
            | (Class.Type, _) => ()
            | (Class.Extensible, _) =>
                 raise TypeError (pos, "Extensible type `" 
                    ^ Symbol.toValue (Class.base class) ^ "` given a constant\
                    \ that is not of base type.")
            | (Class.Builtin, _) => 
                 raise TypeError (pos, "Built-in type `"
                    ^ Symbol.toValue (Class.base class) ^ "` cannot be given\
                    \ new constants.")
            | _ => raise TypeError (pos, "WHY IS THIS NOT A REDUNDANT MATCH?")
         ; Decl.Const (pos, c, tc_closed_class pos class))
      end
    | _ => raise Match

(*
      (* Relations declarations are well-formed
       * if they haven't been declared already
       * if their indices are valid types
       * if the associated world is valid under (only) the named indices *)
    | A.DeclRelation (r, args, world) =>
      let
         val () = tc_namespace ("Relation", r)
         val env = tc_args args 
         val env' = tc_world env world
         val newenv = 
            MapX.filteri (fn (x, _) => not (MapX.inDomain (env, x))) env'
      in
         case MapX.firsti newenv of
            NONE => ()
          | SOME (x, _) => 
            raise Fail ("Variable " ^ name x 
                        ^ " used in world but not bound." )
      end
*)


end
