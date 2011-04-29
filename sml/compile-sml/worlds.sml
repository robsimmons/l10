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
   in    
      if null args
      then emit ("val seek" ^ Name ^ ": unit -> unit") 
      else emit ("val seek" ^ Name ^ ": " ^ strargs ^ " -> unit")
   end

fun seekWorld (world, args) =
   let 
      val Name = embiggen (Symbol.name world)
      val strargs = 
          if null args then " ()"
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
       val pats = List.filter (genTerms terms o #1) (SearchTab.lookup w)
       fun strEq (x, y) = Symbol.name x ^ " = " ^ Symbol.name y
       fun handleArg subst (w, terms) = 
          let val terms' = valOf (Ast.subTerms (subst, terms)) in  
             emit ("; " ^ seekWorld (w, terms'))
          end

       fun handlePat (pat, args) = 
          let val (term, subst, eqs) = pathTerms pat in
             emit ("; if true (* andalso " 
                   ^ String.concatWith " andalso " (map strEq eqs) 
                   ^ " *) then (()")
             ; incr ()
             ; app (handleArg subst) args
             ; emit ") else ()"
             ; decr ()
          end
    in 
       emit ("print \"" ^ Int.toString (length pats) ^ " matching\\n\"")
       ; app handlePat pats
    end 
    (* emit ("(" ^ String.concatWith ", " (map buildTerm terms) ^ ")") *)
  | emitCase world (pathTreeVars: pathTreeVar list) = 
    let
    in
       emit ("case ("
             ^ String.concatWith ", " (map strprj pathTreeVars) ^ ") of")
       ; emitMatches "  " world pathTreeVars [] 
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
       emit (prefix ^ "(" ^ String.concatWith ", " patterns ^ ") => (")
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
                       emitMatches ")|" world pathvars ((is, match) :: matches))
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

      (* Outputs code for saying "I am here" *)
      fun reportworld () = 
        (incr ()
         ; if null args 
           then emit ("val () = print (\"Visiting " ^ name ^ "\\n\")")
           else emit ("val () = print (\"Visiting (" ^ name ^ "\"")
         ; incr ()
         ; app (fn (i, typ) => 
                emit ("^ \" \" ^ " ^ nameOfStr typ ^ " x_" ^ Int.toString i)) args
         ; if null args then () else emit "^ \")\\n\")"
         ; decr ()
         ; decr ())
   in
      emit ("and seek" ^ Name ^ " (" 
            ^ String.concatWith ", " (map nameOfVar pathTreeVars) ^ ") =")
      ; incr ()
      ; emit ("let")
      ; reportworld ()
      ; emit ("in")
      ; incr ()
      ; emitCase (world, startingTerms) (filterUnsplit pathTreeVars)
      ; decr ()
      ; emit ("end\n")
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
      ; emit ("open " ^ getPrefix true "" ^ "Terms\n")
      ; emit "fun fake () = ()\n"
      ; app emitWorld worlds
      ; decr ()
      ; emit "end"
   end

end
