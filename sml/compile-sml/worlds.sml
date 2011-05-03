(* Robert J. Simmons *)

structure SMLCompileWorlds:> sig

   val worldsSig: unit -> unit 
   val worlds: unit -> unit 

end = 
struct

open SMLCompileUtil
open SMLCompileTypes
open SMLCompileTerms

fun emitWorldSig world = 
   let
      val Name = embiggen (Symbol.name world)
      val args = valOf (WorldTab.lookup world)
      fun gettyp x = 
         if encoded x 
         then getPrefix true "" ^ "Terms." ^ Symbol.name x
         else nameOfType x
      val strargs = String.concatWith " * " (map gettyp args)
      val maptyp = "unit " ^ getPrefix true "" ^ "Terms.MapWorld.map"
   in    
      if null args
      then emit ("val seek" ^ Name ^ ": " ^ maptyp ^ " -> " ^ maptyp) 
      else emit ("val seek" ^ Name ^ ": " ^ strargs ^ " -> "
                 ^ maptyp ^ " -> " ^ maptyp) 
   end

fun seekWorld (world, args) =
   let 
      val Name = embiggen (Symbol.name world)
      val strargs = 
          if null args then ""
          else " (" ^ String.concatWith ", " (map buildTerm args) ^ ")"
   in "seek" ^ Name ^ strargs end

type pathConstructorVar = (Symbol.symbol * Coverage.pathtree list) pathvar
type pathTreeVar = Coverage.pathtree pathvar
(* type pathvar = Coverage.pathtree pathvar *)

(* Using SearchTab, come up with a sufficiently expanded set of pathtrees *)
fun makePaths world args =
   let 
      val seed: pathTreeVar list = 
         map (fn (n, typ) => ([ n ], (typ, Coverage.Unsplit))) args

      fun mapper (term, (is, pathtree)) =
         (is, Coverage.extendpaths (term, pathtree))
      fun folder (terms, pathTreeVars) = 
         map mapper (ListPair.zipEq (terms, pathTreeVars))
   in
      List.foldr folder seed (map #1 (SearchTab.lookup world))
   end

(* See if a term falls under a particular pattern *)
fun genTerm (generalTerm, term) = 
   case (generalTerm, term) of
      (_, Ast.Var _) => true
    | (Ast.Var _, _) => raise Fail "General term not sufficiently general"
    | (Ast.Const _, Ast.Structured _) => false
    | (Ast.Structured _, Ast.Const _) => false
    | (Ast.Const c, Ast.Const c') => c = c'
    | (Ast.Structured (f, terms), Ast.Structured (f', terms')) =>
      f = f' andalso genTerms terms terms'
    | (Ast.NatConst i, Ast.NatConst i') => i = i'
    | (Ast.StrConst s, Ast.StrConst s') => s = s'
    | _ => raise Fail "Typing invariant in general term"

and genTerms generalTerms terms = 
   List.all genTerm (ListPair.zipEq (generalTerms, terms))

fun strprj (pathvar as (_, (typ, _))) = nameOfPrj typ ^ nameOfVar pathvar

fun filterUnsplit (pathTreeVars: pathTreeVar list) = 
   List.filter (not o Coverage.isUnsplit o #2 o #2) pathTreeVars

fun emitCase (w, terms) [] = 
    let 
       val typs = valOf (WorldTab.lookup w)
       val pats = List.filter (genTerms terms o #1) (SearchTab.lookup w)
       fun strEq (typ, x, y) = nameOfEq typ (Symbol.name x) (Symbol.name y)
       fun handleArg prefix subst (w, terms) = 
          let val terms' = valOf (Ast.subTerms (subst, terms)) in  
             emit (prefix ^ seekWorld (w, terms'))
          end

       fun handleArgs prefix subst [] = emit (prefix ^ "(fn x => x)")
         | handleArgs prefix subst [ arg ] = handleArg prefix subst arg
         | handleArgs prefix subst (arg :: args) = 
           (handleArgs prefix subst args; handleArg " o " subst arg)

       fun handleArgsIf subst [] = emit "then (fn x => x"
         | handleArgsIf subst [ arg ] = handleArg "then (" subst arg
         | handleArgsIf subst (arg :: args) = 
           (handleArgsIf subst args; handleArg "      o " subst arg)

       fun handlePat prefix (pat, args) = 
          let 
             val pattyp = ListPair.zip (pat, typs)
             val (terms, subst, eqs) = pathTerms pattyp
          in
             if null eqs 
             then (handleArgs prefix subst args)
             else (emit (prefix ^ "(if " 
                         ^ String.concatWith " andalso " (map strEq eqs))
                   ; incr ()
                   ; handleArgsIf subst args
                   ; emit ") else (fn x => x))"
                   ; decr ())
          end
       
       fun handlePats [] = emit "((fn x => x)"
         | handlePats [ (pat, args) ] = handlePat "(" (pat, args)
         | handlePats ((pat, args) :: pats) = 
           (handlePats pats; handlePat " o " (pat, args))
    in 
       handlePats pats; emit ", [])"
    end 
    (* emit ("(" ^ String.concatWith ", " (map buildTerm terms) ^ ")") *)
  | emitCase world (pathTreeVars: pathTreeVar list) = 
    let
    in
       emit ("(case ("
             ^ String.concatWith ", " (map strprj pathTreeVars) ^ ") of")
       ; emitMatches "   " world pathTreeVars [] 
       ; emit ")"
    end
    
(* Base case of emitMatches *)
and emitMatch prefix (w, terms) (matches: pathConstructorVar list) = 
    let 
       fun constructorMap (is, (constructor, subpaths)) = 
          constructorPattern 
             (fn (n, _) => List.nth (subpaths, n-1)) 
             (is, ()) constructor
           
       val (patterns, pathvars) = ListPair.unzip (map constructorMap matches)

       fun constructorFold ((is, (constructor, subpaths)), terms) = 
          let 
             val symbOfVar = Symbol.symbol o nameOfVar

             fun makeVar (i, _) = 
                Ast.Var (SOME (symbOfVar (is @ [ i ], ())))

             val term = 
                if null subpaths then Ast.Const constructor
                else Ast.Structured (constructor, map makeVar (mapi subpaths))
          in map (Ast.subTerm' (term, symbOfVar (is, ()))) terms end

       val terms = List.foldl constructorFold terms matches
    in
       emit (prefix ^ "(" ^ String.concatWith ", " patterns ^ ") => ")
       ; incr ()
       ; emitCase (w, terms) (filterUnsplit (List.concat pathvars))
       ; decr ()
    end

(* Somewhat complex to avoid making an intermediate data structure. 
 * Given n treevars with O(m) constructors, calls emitMatch on the O(m*n) 
 * possible patterns. *)
and emitMatches prefix world [] matches = emitMatch prefix world (rev matches)
  | emitMatches prefix world (pathvar :: pathvars) matches =
    let val (is, (typ, pathtree)) = pathvar in 
       case pathtree of 
          Coverage.Unsplit => raise Fail "Invariant"
        | Coverage.Split subtrees => 
          let val newmatches = MapX.listItemsi subtrees in
             emitMatches prefix world pathvars ((is, hd newmatches) :: matches)
             ; app (fn match =>
                    emitMatches " | " world pathvars ((is, match) :: matches))
                   (tl newmatches)
          end
        | Coverage.StringSplit _ => 
          raise Fail "Splitting on strings unimplemented"
        | Coverage.NatSplit _ => 
          raise Fail "Splitting on naturals unimplemented"
        | Coverage.SymbolSplit _ => 
          raise Fail "Splitting on symbols unimplemented"
    end
val emitCase: 
      Ast.world
      -> pathTreeVar list 
      -> unit = emitCase
val emitMatch:
      string 
      -> Ast.world
      -> pathConstructorVar list 
      -> unit = emitMatch
val emitMatches: 
      string 
      -> Ast.world
      -> pathTreeVar list 
      -> pathConstructorVar list 
      -> unit = emitMatches

fun emitWorld world =
   let 
      val name = Symbol.name world
      val Name = embiggen (Symbol.name world)
      val typs = valOf (WorldTab.lookup world)
      val args = mapi typs
      val pathTreeVars = makePaths world args
      fun makeStartingTerm pathTreeVar = 
         Ast.Var (SOME (Symbol.symbol (nameOfVar pathTreeVar)))
      val startingTerms = map makeStartingTerm pathTreeVars
      val startingWorld = if null pathTreeVars 
                          then Ast.Const world
                          else Ast.Structured (world, startingTerms)

      (* Outputs code for saying "I am here" *)
      fun reportworld () = 
        (if null args 
         then emit ("val () = print (\"Visiting " ^ name ^ "\\n\")")
         else emit ("val () = print (\"Visiting (" ^ name ^ "\"")
         ; incr ()
         ; app (fn (i, typ) => 
                emit ("^ \" \" ^ " ^ nameOfStr typ ^ " x_" ^ Int.toString i)) 
              args
         ; if null args then () else emit "^ \")\\n\")"
         ; decr ())
   in
      emit ("and seek" ^ Name ^ 
            (if null pathTreeVars then "" 
             else (" (" 
                   ^ String.concatWith ", " (map nameOfVar pathTreeVars))
                  ^ ")")
            ^ " worldmap =")
      ; incr ()
      ; emit ("let")
      ; incr ()
      ; emit ("val w = " ^ buildTerm startingWorld)
      ; emit ("val () = if isSome (MapWorld.find (worldmap, w))")
      ; emit ("         then raise Revisit else ()")
      ; emit ("val worldmap = MapWorld.insert (worldmap, w, ())" )
      ; emit ("val (child_searches, inters0) = ")
      ; incr ()
      ; emitCase (world, startingTerms) (filterUnsplit pathTreeVars)
      ; decr ()
      ; emit ("val worldmap' = child_searches worldmap")
      ; reportworld ()
      ; decr ()
      ; emit ("in")
      ; incr ()
      ; emit "worldmap'"
      ; decr ()
      ; emit ("end handle Revisit => worldmap\n")
      ; decr ()
   end

fun worldsSig () = 
   let 
      val worlds = WorldTab.list ()
   in
      emit ("signature " ^ getPrefix true "_" ^ "SEARCH =")
      ; emit "sig" 
      ; incr ()
      ; app emitWorldSig worlds 
      ; decr ()
      ; emit "end"
   end

fun worlds () = 
   let
      val worlds = WorldTab.list ()
   in
      emit ("structure " ^ getPrefix true "" ^ "Search" 
            ^ ":> " ^ getPrefix true "_" ^ "SEARCH" ^ " =")
      ; emit "struct"
      ; incr ()
      ; emit ("open " ^ getPrefix true "" ^ "Terms")
      ; emit ("open " ^ getPrefix true "" ^ "Deduce\n")
      ; emit ("exception Revisit\n")
      ; emit "fun fake () = ()\n"
      ; app emitWorld worlds
      ; decr ()
      ; emit "end"
   end

end
