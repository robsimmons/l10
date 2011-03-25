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
    (tc_typ typ; tc_args' (MapX.insert (map, x, typ), args))
fun tc_args args = tc_args' (MapX.empty, args)


fun require typ1 typ2 = 
   if typ1 = typ2 then () 
   else raise Fail ("Expected a term of type " ^ name typ1 
                    ^ ", but found a constructor of type" ^ name typ2)

(* tc_term env (term, typ) - checks a term at a given type, and returns a
 * (potentially) larger context if it found any type variables that were
 * not already in the environment. *)
fun tc_term (env : symbol MapX.map) (term, typ) : symbol MapX.map = 
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
          NONE => MapX.insert (env, x, typ)
        | SOME typ' => 
          if typ = typ' then env
          else raise Fail ("Variable " ^ name x ^ " has type " ^ name typ' 
                           ^ " but used where a term of type " ^ name typ
                           ^ " was expected."))

and tc_terms env [] = env
  | tc_terms env (tt :: tts) = tc_terms (tc_term env tt) tts

(* tc_term env (term, typ) - checks a world at a given type, and returns a
 * (potentially) larger context if it found any type variables that were
 * not already in the environment. *)
fun tc_world env (world, terms) = 
   case WorldTab.lookup world of
      NONE => raise Fail ("World " ^ name world ^ " not declared.")
    | SOME typs =>
      if length terms = length typs
      then tc_terms env (ListPair.zip (terms, typs))
      else raise Fail ("World " ^ name world ^ " given " 
                       ^ Int.toString (length terms) 
                       ^ " indices, but should have "
                       ^ Int.toString (length typs) ^ ".")

fun tc_worlds env [] = env
  | tc_worlds env (world :: worlds) = tc_worlds (tc_world env world) worlds

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
       * XXX ALL THE TIME *)
    | A.DeclDepends (world, worlds) => 
      ignore (tc_worlds (tc_world MapX.empty world) worlds)

      (* Rules are well-formed
       * XXX ALL THE TIME *)
    | A.DeclRule (prems, concs) => ()

      (* Databases are well-formed
       * XXX ALL THE TIME 
       * (note: may actually want to allow shadowing here, 
       * since db = (...) @ w. might be useful to write twice
       * when we only want effects. *)
    | A.DeclDatabase (db, prems, world) => ()


end
