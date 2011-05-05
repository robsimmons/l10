(* Loading signatures known to be well-typed *)
(* Robert J. Simmons *)

structure Load :> sig
  
   (* loadDecl decl
    * 
    * Preconditions:  decl has been typechecked (types.sml)
    * Exceptions:     Those that can come from mode checking. 
    * Effects:        Adds new types, worlds, constants, and relations
    *                 to the symbol tables in check/tabs.sml 
    *                 Prints out reconstructed declaration. *)
   val loadDecl : Ast.decl -> unit

   (* Module effects: Load predefined symbols into the symbol tables. *)
  

end = struct

open Symbol
structure A = Ast

fun bindDependency ((w, pats), worlds) = SearchTab.bind (w, (pats, worlds))

fun loadDecl decl = 
   case decl of
      A.DeclType typ => 
      let in
         print (name typ ^ ": type.\n")
         ; TypeTab.bind (typ, TypeTab.NO)
         ; print "\n"
      end

    | A.DeclWorld (w, args) => 
      let val typs = map #2 args in
         print (name w ^ ": " ^ A.strTyps typs ^ "world.\n")
         ; WorldTab.bind (w, (map #2 args))
         ; ConTab.bind (w, (map #2 args, TypeTab.world))
         ; print "\n"
      end

    | A.DeclConst (c, args, typ) => 
      let val typs = map #2 args in
         print (name c ^ ": " ^ A.strTyps typs ^ name typ ^ ".\n")
         ; ConTab.bind (c, (map #2 args, typ))
         ; print "\n"
      end

    | A.DeclRelation (r, args, world) => 
      let in
         print (name r ^ ": " ^ A.strArgs args 
                ^ "rel @ " ^ A.strWorld world ^ ".\n")
         ; RelTab.bind (r, (args, world))
         ; ConTab.bind (r, (map #2 args, TypeTab.rel))
         ; print "\n"
      end

    | A.DeclDepends (world, worlds) => 
      let
         val fv = Mode.checkDependency (world, worlds)
      in
         bindDependency (world, worlds)
         ; print (A.strWorld world ^ " <- "
                ^ String.concatWith ", " (map A.strWorld worlds) ^ ".\n")
         ; print "\n"
      end

    | A.DeclRule (prems, concs) => 
      let 
         val (world, worlds) = Mode.pullDependency (prems, concs)
         val fv = Mode.checkDependency (world, worlds)
         val (checked_prems, concs) = Mode.checkRule ((prems, concs), fv)
      in
         bindDependency (world, worlds)
         ; RuleTab.register (world, (prems, concs))
         ; if null prems then ()
           else print (String.concatWith ", " (map A.strPrem prems) ^ "\n -> ")
         ; print (String.concatWith ", " (map A.strAtomic concs) 
                  ^ ".\n")
         (* ; print (A.strWorld world ^ " <- "
                ^ String.concatWith ", " (map A.strWorld worlds) ^ ".\n") *)
         ; print "\n"
      end

    | A.DeclDatabase (db, facts, world) => 
      let in
         print (name db ^ " = (" 
                ^ String.concatWith ", " (map A.strAtomic facts) 
                ^ ")\n   @ " ^ A.strWorld world ^ "\n\n") 
         ; DbTab.bind (db, (facts, world))
      end

end
