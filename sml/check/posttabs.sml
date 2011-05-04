structure InterTab = Multitab (type entrytp = int * int * Ast.typ MapX.map)

(* Desciribes all the modes (indxes) over a given relation *)
structure IndexTab = 
   Multitab (type entrytp = {terms: ModedTerm.term list,
                   input: Ast.typ MapP.map,
                   output: Ast.typ MapP.map})
   
structure MatchTab = Symtab (type entrytp = Coverage'.pathtree list)

(* Reset all tables *)
structure Reset = struct
   fun reset () = 
      (TypeTab.reset ()
       ; WorldTab.reset ()
       ; ConTab.reset ()
       ; TypeConTab.reset ()
       ; RelTab.reset ()
       ; SearchTab.reset ()
       ; RuleTab.reset ()
       ; IndexTab.reset ()
       ; InterTab.reset ()
       ; MatchTab.reset ())
end
