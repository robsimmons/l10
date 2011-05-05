(* Intermediate form for compiled terms *)
(* Robert J. Simmons *)

structure Rule = struct

datatype compiledPrem = 
   Normal of { (* This premise needs to call to this index *)
               index: (Symbol.symbol * Ast.modedTerm list),

               (* The call uses some symbols *)
               inputPattern: (int list * Symbol.symbol) list,

               (* And returns other symbols... *)
               outputPattern: (int list) list,

               (* ...which must be checked for some equational constraints *)
               constraints: (Ast.typ * int list * int list) list,

               (* The following call needs the symbols in this map defined *)
               knownAfterwards: (Symbol.symbol * int list option) list }

 | Negated of { (* The premise needs to call this index *)
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

 | Conclusion of { facts: Ast.atomic list }
end

