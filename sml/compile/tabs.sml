structure Compiled = struct

datatype compiledPrem = 
   Normal of { knownBefore: Symbol.symbol list,

               (* This premise needs to call to this index *)
               index: (Symbol.symbol * Ast.modedTerm list),

               (* The call uses some symbols *)
               inputPattern: (int list * Symbol.symbol) list,

               (* And returns other symbols *)
               outputPattern: (int list) list,

               (* Which must be checked for some equational constraints *)
               constraints: (Ast.typ * int list * int list) list,

               (* The following call needs the symbols in this map defined *)
               knownAfterwards: (Symbol.symbol * int list option) list }

 | Negated of { knownBefore: Symbol.symbol list,

                (* The premise needs to call this index *)
                index: (Symbol.symbol * Ast.modedTerm list),

                (* The call uses some symbols *)
                inputPattern: (int list * Symbol.symbol) list,

                (* And returns other symbols *)
                outputPattern: (int list) list,

                (* The premise fails should any symbols meet the equational 
                 * constraints *)
                constraints: (Ast.typ * int list * int list) list,
               
                (* The following call needs the symbols in this map defined *)
                knownAfterwards: Symbol.symbol list }

 | Placeholder

 | Conclusion of { knownBefore: Symbol.symbol list,
                   facts: Ast.atomic list }
end

structure InterTab = 
Multitab (type entrytp = int * int * Compiled.compiledPrem)

(* Desciribes all the modes (indxes) over a given relation *)
structure IndexTab = 
   Multitab (type entrytp = {terms: Ast.modedTerm list,
                             input: Ast.typ MapP.map,
                             output: Ast.typ MapP.map})
   
structure MatchTab = Symtab (type entrytp = Coverage'.pathtree list
val name = "MatchTab")

(* Reset all tables *)
structure ResetElton = struct
   fun reset () = 
      (Reset.reset ()
       ; IndexTab.reset ()
       ; InterTab.reset ()
       ; MatchTab.reset ())
end
