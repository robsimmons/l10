(* Robert J. Simmons *)

structure Indexing:> sig

  (* Populates the InterTab, IndexTab, and MatchTab 
   * by analyzing the rules of the program in RuleTab. *)
  val index: unit -> unit

end = 
struct

open BasicTerm

fun mapi' n [] = []
  | mapi' n (x :: xs) = (n, x) :: mapi' (n+1) xs

fun mapi xs = mapi' 0 xs

fun fail _ = raise Fail "Invariant"

fun unionP ms = MapP.unionWith fail ms

fun union ms = MapX.unionWith #1 ms

fun minus ms = MapX.mergeWith (fn (SOME x, NONE) => SOME x | _ => NONE) ms

fun knownIndex (index, []) = false
  | knownIndex (index, (index' :: indexes)) = 
    index = index' orelse knownIndex (index, indexes)

fun modedVars mode path term = 
   case term of    
      Var (mode', typ) => 
      if mode = mode' then MapP.singleton (path, typ) else MapP.empty
    | Structured (f, terms) =>
      List.foldl unionP MapP.empty (map (modedVars' mode path) (mapi terms))
    | _ => MapP.empty 
and modedVars' mode path (i, term) = modedVars mode (path @ [ i ]) term

fun addIndex (a, terms) = 
   if knownIndex (terms, map #terms (IndexTab.lookup a)) then ()
   else (print ("   * New index recorded: " ^ Symbol.name a ^ " " 
                ^ String.concatWith " " (map strModedTerm terms) ^ "\n")
         ; IndexTab.bind (a,
           {terms = terms,
            input = modedVars true [] (Structured (a, terms)),
            output = modedVars false [] (Structured (a, terms))}))

fun list fv = 
   String.concatWith ", " (map (Symbol.name o #1) (MapX.listItemsi fv))

(* Given a set of known variables, the path to the current term, and an 
 * Ast.term, indexTerm creates a IndexTerm.term, a term mapping from 
 * input Ast variables to paths (which encodes equational constraints), and a
 * mapping back from the output paths back to Ast variables. *)
fun indexTerm (known, path, (typ, term)) = 
   case term of 
      Ast.Var NONE => 
      {term = Var (false, typ), 
       outputs = MapX.empty,
       paths = MapP.singleton (path, NONE)}
    | Ast.Var (SOME x) => 
      (case MapX.find (known, x) of
          NONE => 
          {term = Var (false, typ), 
           outputs = MapX.singleton (x, (typ, [ path ])),
           paths = MapP.singleton (path, NONE)}
        | SOME typ =>
          {term = Var (true, typ),
           outputs = MapX.empty,
           paths = MapP.singleton (path, SOME x)})
    | Ast.Const c => 
      {term = Const c,
       outputs = MapX.empty, 
       paths = MapP.empty}
    | Ast.NatConst i => 
      {term = NatConst i, 
       outputs = MapX.empty,
       paths = MapP.empty}
    | Ast.StrConst s => 
      {term = StrConst s, 
       outputs = MapX.empty,
       paths = MapP.empty}
    | Ast.Structured (f, terms) =>
      let
         val (typs, typ) = valOf (ConTab.lookup f)
         val typterms = ListPair.zipEq (typs, terms)
         val {terms, outputs, paths} = indexTerms (known, 0, path, typterms) 
      in 
         {term = Structured (f, terms), 
          outputs = outputs, 
          paths = paths} 
      end

and indexTerms (known, n, path, typterms) = 
   case typterms of 
      [] => {terms = [], outputs = MapX.empty, paths = MapP.empty}
    | typterm :: typterms =>
      let 
         val {term, outputs, paths} = indexTerm (known, path @ [ n ], typterm)
         val {terms, outputs = outputs', paths = paths'} = 
             indexTerms (known, n+1, path, typterms)
      in
         {terms = term :: terms,
          outputs = MapX.unionWith (fn ((t1, p1), (t2, p2)) => (t1, p1 @ p2))
                                   (outputs, outputs'),
          paths = MapP.unionWith fail (paths, paths')}
      end

fun indexPat (known, pat) = 
   case pat of 
      Ast.One => raise Fail "Unimplemented"
    | Ast.Atomic (a, terms) =>
      let 
         val typs = map #2 (#1 (valOf (RelTab.lookup a))) 
         val {terms, outputs, paths} = 
            indexTerms (known, 0, [], ListPair.zipEq (typs, terms))
      in
         addIndex (a, terms)
         ; {index = (a, terms), outputs = outputs, paths = paths}
      end
    | Ast.Conj _ => raise Fail "Unimplemented"
    | Ast.Exists (x, pat) =>
      if MapX.inDomain (known, x) 
      then indexPat (#1 (MapX.remove (known, x)), pat)
      else indexPat (known, pat)

open Compiled

fun makeConstraints (typ, []) = []
  | makeConstraints (typ, [ _ ]) = []
  | makeConstraints (typ, a :: b :: c) = 
    (typ, a, b) :: makeConstraints (typ, b :: c)

fun indexRule' (w, rule_n, point, known, prems, concs) = 
   case prems of 
      [] => 
      let val compiled = Conclusion {knownBefore = MapX.listKeys known,
                                     facts = concs}
      in InterTab.bind (w, (rule_n, point, compiled)) end

    | Ast.Normal pat :: prems =>
      let
         val fvpat = FV.fvPat pat
         val newknown = union (known, FV.fvPat pat) 
         val learned = minus (fvpat, known)
         val free = Ast.fvRule (prems, concs)
         val needed = MapX.filteri (fn (x, _) => SetX.member (free, x)) newknown

         val () = print (" - Normal point #" ^ Int.toString point 
                         ^ ": " ^ Ast.strPrem (Ast.Normal pat) ^ "\n")
         val { index, outputs, paths } = indexPat (known, pat)

         val compiled = 
            Normal { knownBefore = MapX.listKeys known,
                     index = index,
                     inputPattern =
                     MapP.listItemsi (MapP.mapPartial (fn x => x) paths),
                     outputPattern =
                     MapP.listKeys (MapP.filter (not o Option.isSome) paths),
                     constraints =
                     MapX.foldl (fn (x, y) => makeConstraints x @ y) [] outputs,
                     knownAfterwards = 
                     MapX.listItemsi
                       (MapX.mapi (fn (x, _) =>
                                      (case MapX.find (outputs, x) of 
                                         SOME paths => SOME (hd (#2 paths))
                                       | NONE => NONE)) needed) } 
      in
         print ("   - learned: " ^ list learned ^ "\n")
         ; print ("   - still needed: " ^ list needed ^ "\n")
         ; InterTab.bind (w, (rule_n, point, compiled))
         ; indexRule' (w, rule_n, point+1, newknown, prems, concs)
      end      

    | Ast.Negated pat :: prems =>
      let
         val free = Ast.fvRule (prems, concs)
         val needed = MapX.filteri (fn (x, _) => SetX.member (free, x)) known
      in
         print (" - Negated point #" ^ Int.toString point ^ "\n")
         ; indexPat (known, pat)
         ; print ("   - still needed: " ^ list needed ^ "\n")
         ; InterTab.bind (w, (rule_n, point, Placeholder))
         ; indexRule' (w, rule_n, point+1, needed, prems, concs)
      end

    | Ast.Count _ :: _ => raise Fail "Unimplemented"
                           
    | Ast.Binrel (Ast.Eq, term1, term2) :: prems => raise Fail "Unimplemented"
      
    | Ast.Binrel (_, term1, term2) :: prems => 
      let
         val free = Ast.fvRule (prems, concs)
         val needed = MapX.filteri (fn (x, _) => SetX.member (free, x)) known
      in
         print (" - Comparison point #" ^ Int.toString point ^ "\n")
         ; print ("   - still needed: " ^ list needed ^ "\n")
         ; InterTab.bind (w, (rule_n, point, Placeholder))
         ; indexRule' (w, rule_n, point+1, needed, prems, concs)
      end
      
fun indexRule (rule_n, world: Ast.world, (prems, concs)) = 
   let
      val fvworld = FV.fvWorld world
      val () = print ("Analyzing rule #" ^ Int.toString rule_n ^ "\n")
   in
      indexRule' (#1 world, rule_n, 0, fvworld, prems, concs)
   end

fun indexDefault a = 
   let 
      val typs = map #2 (#1 (valOf (RelTab.lookup a)))
      val terms = map (fn typ => Var (true, typ)) typs
   in
      IndexTab.bind (a, {terms = terms,
                         input = modedVars true [] (Structured (a, terms)),
                         output = MapP.empty})
   end

fun indexWorld w = 
   let
      val () = print ("Indexing for world " ^ Symbol.name w ^ "\n")
      val rules = rev (RuleTab.lookup w)
      val () = print (Int.toString (length rules) ^ " applicable rule(s)\n")
   in
      app indexRule rules
      ; print "\n"
   end

fun createPathtree a = 
   let 
      val pathtree = 
         map Coverage'.Unsplit (map #2 (#1 (valOf (RelTab.lookup a))))
      val indexes = map #terms (IndexTab.lookup a)
      val newPathtree = 
         List.foldr (Coverage'.extendpaths #2) pathtree indexes
   in
      print (Int.toString (length indexes) ^ " index(es) for relation " 
             ^ Symbol.name a ^ "\n")
      ; MatchTab.bind (a, newPathtree)
   end

fun index () = 
   let 
      val rels = RelTab.list ()
      val worlds = WorldTab.list () 
   in
      print "=== INDEXING ===\n"
      ; app indexDefault rels
      ; app indexWorld worlds
      ; print "=== CREATING PATH TREE ===\n"
      ; app createPathtree rels
   end

end

(* Reset all tables *)
structure Reset = struct
   fun reset () = 
      (Reset.reset ()
       ; IndexTab.reset ()
       ; InterTab.reset ()
       ; MatchTab.reset ())
end
