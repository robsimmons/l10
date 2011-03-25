structure Load :> sig
  
   (* loadDecl decl
    * 
    * Preconditions:  decl has been typechecked
    * Exceptions:     none
    * Effects:        Adds new types, worlds, constants, and relations
    *                 to the symbol tables in check/tabs.sml 
    *                 Prints out reconstructed declaration. *)
   val loadDecl : Ast.decl -> unit

   (* Module effects: Load predefined symbols into the symbol tables. *)
  

end = struct

open Symbol
structure A = Ast

fun loadDecl decl = 
   case decl of
      A.DeclType typ => 
      let in
         print (name typ ^ ": type.\n")
         ; TypeTab.bind (typ, TypeTab.NO)
      end

    | A.DeclWorld (w, args) => 
      let val typs = map #2 args in
         print (name w ^ ": " ^ A.strTyps typs ^ "world.\n")
         ; WorldTab.bind (w, (map #2 args))
      end

    | A.DeclConst (c, args, typ) => 
      let val typs = map #2 args in
         print (name c ^ ": " ^ A.strTyps typs ^ name typ ^ ".\n")
         ; ConTab.bind (c, (map #2 args, typ))
      end

    | A.DeclRelation (r, args, world) => 
      let in
         print (name r ^ ": " ^ A.strArgs args 
                ^ "rel @ " ^ A.strWorld world ^ ".\n")
         ; RelTab.bind (r, (args, world))
      end

    | A.DeclDepends (world, worlds) => 
      let in
         print (A.strWorld world ^ " <- "
                ^ String.concatWith ", " (map A.strWorld worlds) ^ ".\n")
      end

    | A.DeclRule (prems, concs) => 
      let in
         print (String.concatWith ", " (map A.strPrem prems) ^ "\n")
         ; print (" -> " ^ String.concatWith ", " (map A.strAtomic concs) 
                  ^ ".\n")
      end

    | A.DeclDatabase (db, facts, world) => 
      let in 
         print (name db ^ " = (" 
                ^ String.concatWith ", " (map A.strAtomic facts) 
                ^ ")\n   @ " ^ A.strWorld world ^ "\n") 
      end

end
