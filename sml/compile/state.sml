(* Persistant data used in compilation *)
(* Robert J. Simmons *)

(* Index table 
 * For a relation r, IndexTab.lookup r = SOME {terms, input, output}
 * terms - A moded term (true = index on this term, false = return this term)
 * input - A map of all the input variable positions
 * output - A map of all the output variable positions *)
structure IndexTab = 
   Multitab (type entrytp = {(* id: int, *)
                             terms: Ast.modedTerm list,
                             input: Ast.typ MapP.map,
                             output: Ast.typ MapP.map})

(* Relation Match Table
 * For every relation r: tp1 -> .. -> tpn -> rel @ W, 
 * MatchTab r = [ pathtree1, ..., pathtreeN ], which describes all the ways
 * a declared atomic proposition (r t1 ... tn) may need to be matched against
 * a premise. *)
structure RelMatchTab = Symtab (type entrytp = Path.tree list
val name = "MatchTab")

(* Compiled Premise Table 
 * Stores instructions for running each premise in isolation. *)
structure CompiledPremTab:> sig
   type entry = int * int * Symbol.symbol list * Rule.compiledPrem * string
   val reset: unit -> unit
   val bind: entry -> unit
   val lookup: unit -> entry list
end = struct

   type entry = int * int * Symbol.symbol list * Rule.compiledPrem * string

   val db: entry list ref = ref []

   fun reset () = db := []

   fun bind entry = db := entry :: !db

   fun lookup () = !db
                            
end

structure CompilerState:> sig

   val reset: unit -> unit
   val load: unit -> unit 

end = 
struct
   fun reset () = 
      (Reset.reset ()
       ; IndexTab.reset ()
       ; CompiledPremTab.reset ()
       ; RelMatchTab.reset ())

   fun mapi' n [] = []
     | mapi' n (x :: xs) = (n, x) :: mapi' (n+1) xs

   fun mapi xs = mapi' 0 xs


   (* Load index map *)

   fun fail _ = raise Fail "Invariant"

   fun unionP ms = MapP.unionWith fail ms

   fun modedVars mode path term = 
      case term of    
         Ast.Var (mode', typ) => 
         if mode = mode' then MapP.singleton (path, typ) else MapP.empty
       | Ast.Structured (f, terms) =>
         List.foldl unionP MapP.empty (map (modedVars' mode path) (mapi terms))
       | _ => MapP.empty 
   and modedVars' mode path (i, term) = modedVars mode (path @ [ i ]) term

   fun loadDefaultIndex a = 
      let 
         val typs = map #2 (#1 (RelTab.lookup a))
         val terms = map (fn typ => Ast.Var (true, typ)) typs
      in
         IndexTab.bind (a, {(* id = 0, *)
                            terms = terms,
                            input = 
                            modedVars true [] (Ast.Structured (a, terms)),
                            output = MapP.empty})
         ; (a, terms)
      end

   fun knownIndex [] index = SOME index
     | knownIndex (index' :: indexes) index = 
       if index = index' then NONE else knownIndex indexes index

   fun getPremIndex prem = 
      case prem of 
         Rule.Normal {index, ...} => SOME index
       | Rule.Negated {index, ...} => SOME index
       | _ => NONE
                                      
   fun loadIndex (prem, (i, indexes)) = 
      case Option.mapPartial (knownIndex indexes) (getPremIndex prem) of
         NONE => (i, indexes)
       | SOME (index as (a, terms)) => 
         (print ("   * New index recorded: " ^ Symbol.name a ^ " " 
                 ^ String.concatWith " " (map Ast.strModedTerm terms) ^ "\n")
          ; IndexTab.bind 
               (a, {(* id = i, *)
                    terms = terms,
                    input = modedVars true [] (Ast.Structured index),
                    output = modedVars false [] (Ast.Structured index)})
          ; (i+1, index :: indexes))


   (* Load path tree *)

   fun loadPathtree a = 
      let 
         val pathtree = 
            map Path.Unsplit (map #2 (#1 (RelTab.lookup a)))
         val indexes = map #terms (IndexTab.lookup a)
         val newPathtree = 
            List.foldr (Path.extendpaths #2) pathtree indexes
      in
         print (Int.toString (length indexes) ^ " index(es) for relation " 
                ^ Symbol.name a ^ "\n")
         ; RelMatchTab.bind (a, newPathtree)
      end

 
   (* Compiling and loading *)

   fun compileRule (rule_n, world, rule) = 
      let in
         print ("Compiling rule " ^ Int.toString rule_n ^ "\n")
         ; map (fn (a, (b, c, d)) => (rule_n, a, b, c, d)) 
              (mapi (Rule.compile (world, rule)))
      end

   fun load () =
      let 
         val rels = RelTab.list ()
         val rules = List.concat (map compileRule (RuleTab.list ()))
      in
         app CompiledPremTab.bind rules
         ; foldl loadIndex (0 (* XXX *), map loadDefaultIndex rels) 
             (map #4 rules)
         ; app loadPathtree rels
      end
end
