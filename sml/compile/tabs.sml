(* Persistant data used in compilation *)
(* Robert J. Simmons *)

(* Index table 
 * For a relation r, IndexTab.lookup r = SOME {terms, input, output}
 * terms - A moded term (true = index on this term, false = return this term)
 * input - A map of all the input variable positions
 * output - A map of all the output variable positions *)
structure IndexTab = 
   Multitab (type entrytp = {terms: Ast.modedTerm list,
                             input: Ast.typ MapP.map,
                             output: Ast.typ MapP.map})

(* Relation Match Table
 * For every relation r: tp1 -> .. -> tpn -> rel @ W, 
 * MatchTab r = [ pathtree1, ..., pathtreeN ], which describes all the ways
 * a declared atomic proposition (r t1 ... tn) may need to be matched against
 * a premise. *)
structure RelMatchTab = Symtab (type entrytp = Coverage'.pathtree list
val name = "MatchTab")

(* Compiled Premise Table 
 * Stores instructions for running each premise in isolation. *)
structure CompiledPremTab:> sig
   type entry = int * int * CompiledData.prem
   val reset: unit -> unit
   val bind: entry -> unit
   val lookup: unit -> entry list
end = struct

   type entry = int * int * CompiledData.prem

   val db: entry list ref = ref []

   fun reset () = db := []

   fun bind entry = db := entry :: !db

   fun lookup () = !db
                            
end

(* Reset all tables *)
structure ResetElton = struct
   fun reset () = 
      (Reset.reset ()
       ; IndexTab.reset ()
       ; CompiledPremTab.reset ()
       ; RelMatchTab.reset ())
end
