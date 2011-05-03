structure Indexing = 
struct

open IndexTerm

fun mapi' n [] = []
  | mapi' n (x :: xs) = (n, x) :: mapi' (n+1) xs

fun mapi xs = mapi' 0 xs

fun union ms = MapX.unionWith #1 ms
fun minus ms = MapX.mergeWith (fn (SOME x, NONE) => SOME x | _ => NONE) ms

fun knownIndex (index, []) = false
  | knownIndex (index, (index' :: indexes)) = 
    index = index' orelse knownIndex (index, indexes)

fun addIndex (a, index) = 
   if knownIndex (index, IndexTab.lookup a)
   then (print ("New index recorded: " ^ Symbol.name a ^ " " 
                ^ String.concatWith " " (map strIndex index) ^ "\n")
         ; IndexTab.bind (a, index))
   else ()

fun list fv = 
   String.concatWith ", " (map (Symbol.name o #1) (MapX.listItemsi fv))

(* Given a set of known variables, the path to the current term, and an 
 * Ast.term, indexTerm creates a IndexTerm.term, a term mapping from 
 * input Ast variables to paths (which encodes equational constraints), and a
 * mapping back from the output paths back to Ast variables. *)
fun indexTerm (known, path, term) = 
   case term of 
      Ast.Var NONE => 
      {term = Var OUTPUT, 
       input = MapX.empty,
       output = MapP.empty}
    | Ast.Var (SOME x) => 
      (case MapX.find (known, x) of
          NONE => 
          {term = Var OUTPUT, 
           input = MapX.empty,
           output = MapP.singleton (path, x)}
        | SOME typ =>
          {term = Var INPUT,
           input = MapX.singleton (x, [ path ]),
           output = MapP.empty})
    | Ast.Const c => 
      {term = Const c,
       input = MapX.empty, 
       output = MapP.empty}
    | Ast.NatConst i => 
      {term = NatConst i, 
       input = MapX.empty,
       output = MapP.empty}
    | Ast.StrConst s => 
      {term = StrConst s, 
       input = MapX.empty,
       output = MapP.empty}
    | Ast.Structured (f, terms) =>
      let val {terms, input, output} = indexTerms (known, 0, path, terms) 
      in 
         {term = Structured (f, terms), 
          input = input, 
          output = output} 
      end

and indexTerms (known, n, path, terms) = 
   case terms of 
      [] => {terms = [], input = MapX.empty, output = MapP.empty}
    | term :: terms =>
      let 
         val {term, input, output} = indexTerm (known, path @ [ n ], term)
         val {terms, input = input', output = output'} = 
             indexTerms (known, n+1, path, terms)
         fun fail _ = raise Fail "Invariant"
      in
         {terms = term :: terms,
          input = MapX.unionWith (op @) (input, input'),
          output = MapP.unionWith fail (output, output')}
      end

fun indexPat (known, pat) = 
   case pat of 
      Ast.One => raise Fail "Unimplemented"
    | Ast.Atomic (a, terms) =>
      let 
         val res = indexTerms (known, 0, [], terms)
      in
         addIndex (a, #terms res); res
      end
    | Ast.Conj _ => raise Fail "Unimplemented"
    | Ast.Exists (x, pat) =>
      if MapX.inDomain (known, x) 
      then indexPat (#1 (MapX.remove (known, x)), pat)
      else indexPat (known, pat)

fun indexRule' (rule_n, point, known, prems, concs) = 
   case prems of 
      [] => (print "\n"; [])

    | Ast.Normal pat :: prems =>
      let
         val fvpat = FV.fvPat pat
         val newknown = union (known, FV.fvPat pat) 
         val learned = minus (fvpat, known)
         val free = Ast.fvRule (prems, concs)
         val needed = MapX.filteri (fn (x, _) => SetX.member (free, x)) newknown
      in
         print (" - Normal point #" ^ Int.toString point 
                ^ ": " ^ Ast.strPrem (Ast.Normal pat) ^ "\n")
         ; print ("   - learned: " ^ list learned ^ "\n")
         ; print ("   - still needed: " ^ list needed ^ "\n")
         ; indexPat (known, pat)
         ; indexRule' (rule_n, point+1, newknown, prems, concs)
      end      

    | Ast.Negated pat :: prems =>
      let
         val free = Ast.fvRule (prems, concs)
         val needed = MapX.filteri (fn (x, _) => SetX.member (free, x)) known
      in
         print (" - Negated point #" ^ Int.toString point ^ "\n")
         ; print ("   - still needed: " ^ list needed ^ "\n")
         ; indexPat (known, pat)
         ; indexRule' (rule_n, point+1, known, prems, concs)
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
         ; indexRule' (rule_n, point+1, known, prems, concs)
      end
      

fun indexRule (rule_n, world: Ast.world, (prems, concs)) = 
   let
      val fvworld = FV.fvWorld world
      val () = print ("Binding intro for rule #" ^ Int.toString rule_n ^ "\n")
      val compiled = indexRule' (rule_n, 0, fvworld, prems, concs)
   in
      InterTab.bind (#1 world, (rule_n, 0, FV.fvWorld world))
   end

fun indexWorld w = 
   let
      val () = print ("Indexing for world " ^ Symbol.name w ^ "\n")
      val rules = rev (RuleTab.lookupw w)
      val () = print (Int.toString (length rules) ^ " applicable rule(s)\n")
   in
      app indexRule rules
      ; print "\n"
   end

fun index () = 
   app indexWorld (WorldTab.list ())

end
