structure Types :> sig
  
   (* checkDecl decl
    *
    * Takes a raw parsed declarations, makes sure scope, arity,
    * and simple types are all respected, and prevents duplicate definitions. 
    *
    * Exceptions: Fail
    * Effects:    May add new constants of extensible type to ConTab. *)
   val checkDecl : Ast.decl -> unit

end = struct

structure A = Ast
open Global
open Symbol

(* tc_newvar (syntax, x, lookup_result) 
 * Utility function used with table look up to make sure syntax isn't bound *)
fun tc_newvar (syntax, x, lookup_result) = 
   case lookup_result of 
      NONE => ()
    | _ => raise Fail (syntax ^ " " ^ name x ^ " is already declared.")

(* tc_type typ - asserts that a symbol is a type *)
fun tc_typ typ = 
   case TypeTab.lookup typ of
      NONE => raise Fail ("Type " ^ name typ ^ " not declared.")
    | _ => ()

(* tc_args args - checks that types are defined, returns bound variables *)
fun tc_args' (map, []) = map
  | tc_args' (map, (NONE, typ) :: args) = 
    (tc_typ typ; tc_args' (map, args))
  | tc_args' (map, (SOME x, typ) :: args) = 
    (tc_typ typ; tc_args' (MapX.insert (map, x, SOME typ), args))
fun tc_args args = tc_args' (MapX.empty, args)


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
      (case ConTab.lookup c of 
          NONE => (case TypeTab.lookup typ of
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
      (case ConTab.lookup f of
          NONE => (case TypeTab.lookup typ of
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
                           ^ " argument(s), was given none."))
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
   case WorldTab.lookup w of
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
   case RelTab.lookup r of
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
       (case ConTab.lookup c of 
           NONE => (ignore (tc_term env (term, symbol "_unknown_"))
                    (* raises Fail *) 
                    ; raise Fail "Unreachable")
         | SOME (_, typ) => typ)
     | A.NatConst _ => TypeTab.nat
     | A.StrConst _ => TypeTab.string
     | A.Structured (f, _) =>
       (case ConTab.lookup f of
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
      A.DeclType typ => tc_newvar ("Type", typ, TypeTab.lookup typ)

      (* Worlds are well-formed 
       * if they haven't been declared already
       * and if all their indices are valid types *)
    | A.DeclWorld (w, args) => ignore (tc_args args)

      (* Constant declarations are well-formed 
       * if they haven't been declared already
       * and if their indices are valid types *)
    | A.DeclConst (c, args, typ) => 
      (tc_newvar ("Constant", c, ConTab.lookup c)
       ; ignore (tc_args args) 
       ; tc_typ typ)

      (* Relations declarations are well-formed
       * if they haven't been declared already
       * if their indices are valid types
       * if the associated world is valid under (only) the named indices *)
    | A.DeclRelation (r, args, world) =>
      let
         val () = tc_newvar ("Relation", r, RelTab.lookup r)
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
      let val env = tc_atomics (tc_world MapX.empty world) prems in
         case MapX.firsti env of
            NONE => ()
          | SOME (x, _) =>
            raise Fail ("Free variables aren't allowed in database"
                        ^ " declarations, but " ^ name x ^ " was free.")
      end

end
