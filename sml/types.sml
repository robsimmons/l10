(* Type checking *)
(* Robert J. Simmons *)

structure Types :> 
sig
   exception TypeError of Pos.t * string
   exception Reserved of Pos.t * Symbol.symbol * string

   (*[ val check: Decl.decl -> Decl.decl_t ]*)
   (* Takes a raw parsed declarations, makes sure scope, arity,
    * and simple types are all respected, and prevents duplicate definitions. 
    * May add new constants of extensible type to Tab.consts. *)
   val check: Decl.t -> Decl.t
end =
struct

exception Invariant
exception TypeError of Pos.t * string
exception Reserved of Pos.t * Symbol.symbol * string

(* == Signature invariants == *)

(* Illegal identifiers (stolen from cmlex) *)
val illegal = ref SetX.empty 
val () = 
   List.app
      (fn str => illegal := SetX.insert (!illegal) (Symbol.fromValue str))
      ([ "abstype"
       , "andalso"
       , "as"
       , "case"
       , "datatype"
       , "do"
       , "else"
       , "end"
       , "exception"
       , "fn"
       , "fun"
       , "functor"
       , "handle"
       , "if"
       , "in"
       , "infix"
       , "infixr"
       , "include"
       , "let"
       , "local"
       , "nonfix"
       , "of"
       , "op"
       , "open"
       , "orelse"
       , "raise"
       , "sharing"
       , "sig"
       , "signature"
       , "struct"
       , "structure"
       , "then"
       , "type"
       , "val"
       , "where"
       , "while"
       , "withtype"

       , "before"
       , "div"
       , "mod"
       , "o"

       , "int"
       , "list"
       , "ord"
       , "symbol"

       , "true"
       , "false"
       , "nil"
       , "ref"])

(* Some classifiers *)
fun check_illegal pos x thing = 
   if SetX.member (!illegal) x
   then raise Reserved (pos,x,"Identifier `"^Symbol.toValue x 
                              ^"` is reserved and illegal as a "^thing)
   else ()

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

(* == Types == *)

(*[ sortdef env = Symbol.symbol option DictX.dict ]*)

(*[ val tc_t: Pos.t -> Symbol.symbol -> unit ]*)
fun tc_t pos t = 
   if Tab.member Tab.types t then () 
   else raise TypeError (pos, "Type `" ^ Symbol.toValue t ^ "` not declared")

(* Utility function for requiring two types to be equal *)
fun require pos typ1 typ2 = 
   if Symbol.eq (typ1, typ2) then () 
   else raise TypeError (pos, ( "Expected a term of type `" 
                              ^ Symbol.toValue typ1 
                              ^ "`, but found a constructor of type `" 
                              ^ Symbol.toValue typ2 ^ "`"))

(*[ good_env: Pos.t -> env -> Type.env ]*)
fun good_env pos env = 
   DictX.map
      (fn NONE => (* Shouldn't ever take this branch -rjs Oct 21 2011 *)
             raise TypeError (pos, "Some types for free variables unknown")
        | SOME t => t)
      env


(* == Terms == *)

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
          ( Term.term list -> env * Symbol.symbol * Term.term_t list
          & Term.ground list -> env * Symbol.symbol * Term.ground list
          & Term.moded list -> env * Symbol.symbol * Term.moded_t list)
       & Class.world -> 
          ( Term.term list -> env * Symbol.symbol * Term.term_t list
          & Term.ground list -> env * Symbol.symbol * Term.ground list))]*)

fun tc_term pos env typ term = 
  (case term of  
      Term.SymConst c => 
        (case Tab.find Tab.consts c of 
            NONE => 
              (case Tab.lookup Tab.types typ of
                  Class.Extensible =>  
                   ( Tab.bind (Decl.Const (pos, c, Class.Base typ))
                   ; (env, Term.SymConst c))
                | _ => raise TypeError (pos, ( "Constant `"
                                             ^ Symbol.toValue c
                                             ^ "` not declared and type `"
                                             ^ Symbol.toValue typ 
                                             ^ "` not extensible")))
          | SOME (Class.Base typ') => 
               if Symbol.eq (typ, typ') then (env, Term.SymConst c)
               else raise TypeError (pos, ( "Constant `" ^ Symbol.toValue c 
                                          ^ "` has type `" 
                                          ^ Symbol.toValue typ'
                                          ^ "`, but a term of type `" 
                                          ^ Symbol.toValue typ
                                          ^ "` was expected"))
          | SOME class => 
               raise TypeError (pos, ( "Function symbol `" ^ Symbol.toValue c
                                     ^ "` expected " 
                                     ^ Int.toString (Class.arrows class) 
                                     ^ " argument(s), was given none")))
    | Term.NatConst n => (require pos typ Type.nat; (env, Term.NatConst n))
    | Term.StrConst s => (require pos typ Type.string; (env, Term.StrConst s))
    | Term.Root (f, spine) => 
        (case Tab.find Tab.consts f of
            NONE => raise TypeError (pos, ( "Function symbol `" 
                                          ^ Symbol.toValue f
                                          ^ "` not defined"))
          | SOME class => 
            let 
               val (env', typ', spine_t) = tc_spine pos env f class spine
            in 
               if Symbol.eq (typ, typ') 
               then (env', Term.Root (f, spine_t))
               else raise TypeError (pos, ( "Term `" ^ Symbol.toValue f 
                                          ^ " ...` has type `" 
                                          ^ Symbol.toValue typ'
                                          ^ "`, but a term of type `" 
                                          ^ Symbol.toValue typ
                                          ^ "` was expected"))
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
               else raise TypeError (pos, ( "Variable `" ^ Symbol.toValue x
                                          ^ "` elsewhere given type `" 
                                          ^ Symbol.toValue typ' ^ "`, but here\
                                          \ a term of type `" 
                                          ^ Symbol.toValue typ 
                                          ^ "` was expected")))
    | Term.Mode (m, NONE) => (env, Term.Mode (m, SOME typ)))

and tc_spine pos env f class terms = 
let fun toomany w = 
       TypeError (pos, ( w ^ " `" ^ Symbol.toValue f 
                       ^ "` given " ^ Int.toString (length terms) 
                       ^ " too many arguments"))
in case (class, terms) of 
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
         raise TypeError (pos, ( "Not enough arguments for `" 
                               ^ Symbol.toValue f ^ "`"))
    | (Class.Pi (_, SOME t, class), []) =>
         raise TypeError (pos, ( "Not enough arguments for `" 
                               ^ Symbol.toValue f ^ "`"))
end

(* Takes a list of terms and tries to figure out what their type must be.
 *
 * All term checking is done by *checking,* which creates a problem for 
 * equality, which is treated as polymorphic. Mode checking will fail anyway if
 * both variables in an equality are unknown, so we are okay in failing early
 * in this case. *)

(*[ val seek_typ: Pos.t -> env -> Term.term list -> Symbol.symbol ]*)
fun seek_typ pos env [] = 
       raise TypeError (pos, "Could not infer types of terms in (in)equality")
  | seek_typ pos env (term :: terms) =
      (case term of
          Term.SymConst c => 
            (case Tab.find Tab.consts c of 
                NONE => seek_typ pos env terms
              | SOME typ => (Class.base typ))
        | Term.NatConst _ => Type.nat
        | Term.StrConst _ => Type.string
        | Term.Root (f, _) =>
            (case Tab.find Tab.consts f of
                NONE => seek_typ pos env terms
              | SOME typ => (Class.base typ))
        | Term.Var (NONE, NONE) => seek_typ pos env terms
        | Term.Var (SOME x, NONE) => 
            (case DictX.find env x of
                NONE => seek_typ pos env terms
              | SOME NONE => seek_typ pos env terms
              | SOME (SOME t) => t))
       

(* == Atoms - worlds and atomic propositions == *)

(* Worlds and atomic propositions are ensured, by parser invariant, to have
 * a head variable present in the appropriate table, which means we can do a
 * lookup instead of a more-cautious find. *)

(*[ val tc_atom: env -> 
       ( Class.world -> 
          ( (Pos.t * Atom.world) -> env * (Pos.t * Atom.world_t)
          & (Pos.t * Atom.ground_world) -> env * (Pos.t * Atom.ground_world))
       & Class.rel_t -> 
          ( (Pos.t * Atom.prop) -> env * (Pos.t * Atom.prop_t)
          & (Pos.t * Atom.ground_prop) -> env * (Pos.t * Atom.ground_prop)
          & (Pos.t * Atom.moded) -> env * (Pos.t * Atom.moded_t)))
]*)

fun tc_atom env class (pos, (w, terms)) = 
let 
   val (env', _, terms') = tc_spine pos env w class terms
in (env', (pos, (w, terms'))) 
end

(*[ val tc_world: env ->
       ( Pos.t * Atom.world -> env * (Pos.t * Atom.world_t)
       & Pos.t * Atom.ground_world -> env * (Pos.t * Atom.ground_world)) ]*)
fun tc_world env (world as (_, (w, _))) =
   tc_atom env (Tab.lookup Tab.worlds w) world

(*[ val tc_worlds: env -> 
       (Pos.t * Prem.wprem) list -> env * (Pos.t * Prem.wprem_t) list
]*)
fun tc_worlds env [] = (env, [])
  | tc_worlds env (world :: worlds) = 
    let 
       val (pos, f, world)
           (*[ <: Pos.t
                  * (Pat.wpat_t -> Prem.wprem_t)
                  * (Symbol.symbol * Term.term list) ]*) = 
          case world of
             (pos, Prem.Normal (Pat.Atom world)) => (pos, Prem.Normal, world)
           | (pos, Prem.Negated (Pat.Atom world)) => (pos, Prem.Negated, world)
           
       val (env', (pos, world')) = tc_world env (pos, world)
       val (env'', worlds') = tc_worlds env' worlds
       val world = (pos, f (Pat.Atom world'))
    in
       (env'', world :: worlds')
    end

(*[ val tc_prop: env ->
       ( Pos.t * Atom.prop -> env * (Pos.t * Atom.prop_t)
       & Pos.t * Atom.ground_prop -> env * (Pos.t * Atom.ground_prop)) ]*)
fun tc_prop env (prop as (_, (r, _))) =
   tc_atom env (Tab.lookup Tab.rels r) prop

(*[ val tc_props: env ->
       ( (Pos.t * Atom.prop) list -> env * (Pos.t * Atom.prop_t) list
       & (Pos.t * Atom.prop) conslist -> env * (Pos.t * Atom.prop_t) conslist
       & (Pos.t * Atom.ground_prop) list 
           -> env * (Pos.t * Atom.ground_prop) list) 
]*)
fun tc_props env [] = (env, [])
  | tc_props env (prop :: props) =
    let 
       val (env', prop') = tc_prop env prop
       val (env'', props') = tc_props env' props
    in
       (env'', prop' :: props')
    end

(*[ val tc_pat: Pos.t -> env -> Pat.pat -> env * Pat.pat_t ]*)
fun tc_pat pos env pat =
   case pat of
      Pat.Atom atom => 
      let val (env', (pos, atom')) = tc_prop env (pos, atom) in
         (env', Pat.Atom atom')
      end
    | Pat.Exists (x, NONE, pat) =>
      let 
         val oldt = DictX.find env x 
         val (env, pat) = tc_pat pos (DictX.insert env x NONE) pat
         val boundt =
            case DictX.find env x of 
               NONE => raise Invariant
             | SOME NONE =>
                  raise TypeError (pos, "Cannot infer type of existentially\
                                        \ bound variable `" 
                                        ^ Symbol.toValue x ^ "`")
             | SOME (SOME t) => t
         val env = 
            case oldt of
               NONE => DictX.remove env x
             | SOME t => DictX.insert env x t
      in
         (env, Pat.Exists (x, SOME boundt, pat))
      end

(*[ val tc_prem: Pos.t -> env -> Prem.prem -> env * Prem.prem_t ]*)
fun tc_prem pos env prem =
   case prem of 
      Prem.Normal pat => 
      let val (env', pat') = tc_pat pos env pat in
         (env', Prem.Normal pat')
      end
    | Prem.Negated pat => 
      let val (env', pat') = tc_pat pos env pat in
         (env', Prem.Negated pat')
      end
    | Prem.Binrel (binrel, term1, term2, NONE) =>
      let val t = case binrel of 
                      Binrel.Eq => seek_typ pos env [term1, term2]
                    | Binrel.Neq => seek_typ pos env [term1, term2]
                    | Binrel.Gt => Type.nat
                    | Binrel.Geq => Type.nat
         val (env', term1') = tc_term pos env t term1
         val (env'', term2') = tc_term pos env t term2
      in
         (env'', Prem.Binrel (binrel, term1', term2', SOME t))
      end

(*[ val tc_prems: env ->
       (Pos.t * Prem.prem) list -> env * (Pos.t * Prem.prem_t) list ]*)
fun tc_prems env [] = (env, [])
  | tc_prems env ((pos, prem) :: prems) =
    let
       val (env', prem') = tc_prem pos env prem
       val (env'', prems') = tc_prems env' prems
    in
       (env'', (pos, prem') :: prems')
    end 


(* == Classifiers == *)

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
      let val (env', _, terms') = 
             tc_spine pos env w (Tab.lookup Tab.worlds w) terms 
      in
         (env', Class.Rel (pos, (w, terms')))
      end
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
               NONE => raise Invariant
             | SOME NONE =>
                  raise TypeError (pos, "Cannot infer type of bound variable `" 
                                        ^ Symbol.toValue x ^ "`")
             | SOME (SOME ty) => ty
         val env = 
            case oldt of
               NONE => DictX.remove env x
             | SOME t => DictX.insert env x t
      in (env, Class.Pi (x, SOME boundty, class))
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
                                              ^ "` free in classifier")  
   end


(* == Top-level declarations == *)

(*[ val check: Decl.decl -> Decl.decl_t ]*)
fun check decl = 
   case decl of 
      Decl.World (pos, w, class) => 
       ( tc_namespace pos "World" w
       ; Decl.World (pos, w, tc_closed_class pos class))

    | Decl.Const (pos, c, class) => 
      let 
         (*[ val typ: Class.typ ]*)
         val typ = tc_closed_class pos class
         (*[ val knd: Class.knd ]*)
         val knd = Tab.lookup Tab.types (Class.base class)
      in
       ( tc_namespace pos "Constant" c
       ; case knd of
            Class.Type => ()
          | Class.Extensible => 
              (case typ of 
                  Class.Base _ => ()
                | _ => raise TypeError (pos, ( "Extensible type `" 
                                             ^ Symbol.toValue (Class.base typ) 
                                             ^ "` cannot have a complex\
                                             \ constructor; only `" 
                                             ^ Symbol.toValue c ^ ": "
                                             ^ Symbol.toValue (Class.base typ) 
                                             ^ "` is allowed")))
          | Class.Builtin => 
               raise TypeError (pos, ( "Built-in type `"
                                     ^ Symbol.toValue (Class.base typ) 
                                     ^ "` cannot be given new constants"))
       ; Decl.Const (pos, c, typ))
      end

    | Decl.Rel (pos, r, class) => 
       ( tc_namespace pos "Relation" r
       ; Decl.Rel (pos, r, tc_closed_class pos class))

    | Decl.Type (pos, t, class) => 
       ( tc_namespace pos "Type" t
       ; check_illegal pos t "type"
       ; Decl.Type (pos, t, tc_closed_class pos class))

    | Decl.DB (pos, (db, props, world)) => 
      let  
         val (_, props') = tc_props DictX.empty props
         val (_, world') = tc_world DictX.empty world
      in
       ( check_illegal pos db "database"
       ; Decl.DB (pos, (db, props', world')))
      end

    | Decl.Depend (pos, (world, worlds), NONE) => 
      let
         val (env, world') = tc_world DictX.empty world
         val (env, worlds') = tc_worlds env worlds
      in
         Decl.Depend (pos, (world', worlds'), SOME (good_env pos env))
      end

    | Decl.Rule (pos, (prems, concs), NONE) => 
      let
         val (env, prems') = tc_prems DictX.empty prems
         val (env', concs') = tc_props env concs
      in
         Decl.Rule (pos, (prems', concs'), SOME (good_env pos env'))
      end

    | Decl.Query (pos, qry, mode as (r, _)) =>
        (case (Tab.find Tab.rels r, Tab.find Tab.rels qry) of 
            (NONE, _) => raise TypeError (pos, "Relation `" ^ Symbol.toValue r 
                                               ^ "` never declared")
          | (_, SOME _) => raise TypeError (pos, "Query `"^Symbol.toValue qry
                                                 ^"' has the same name as an\ 
                                                 \ existing relation, and\ 
                                                 \ therefore conflicts with\
                                                 \ default query for that\ 
                                                 \ relation")
          | (SOME class, NONE) => 
            let val (_, (pos, mode')) = tc_atom DictX.empty class (pos, mode) 
            in
             ( check_illegal pos qry "query"
             ; Decl.Query (pos, qry, mode'))
            end)
    | (decl as Decl.Representation (pos, t, rep)) =>
        (case Tab.find Tab.types t of
            NONE => raise TypeError (pos, ( "Cannot give a TYPE declaration\ 
                                          \ for `" ^ Symbol.toValue t ^ "`\
                                          \, which was never declared"))
          | SOME Class.Type => 
            let 
               fun msg rep' = 
                  ( "Type `" ^ Symbol.toValue t ^ "` already " 
                  ^ Type.repToString rep' ^ " and can't also be " 
                  ^ Type.repToString rep)
            in case Tab.find Tab.representations t of 
                  NONE => decl 
                | SOME rep' => 
                     if rep = rep' then decl
                     else raise TypeError (pos, msg rep')
            end
          | SOME Class.Builtin => 
               raise TypeError (pos, ( "Cannot give a TYPE declaration for\
                                     \ builtin type `" ^ Symbol.toValue t 
                                     ^ "`"))
          | SOME Class.Extensible => 
               raise TypeError (pos, ( "Cannot give a TYPE declaration for\
                                     \ extensible type `" ^ Symbol.toValue t 
                                     ^ "`")))
end
