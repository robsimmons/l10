(* Robert J. Simmons *)

structure SMLCompileWorlds (* :> sig

   val worldsSig: unit -> unit 
   val worlds: unit -> unit 

end *) = 
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
   in Name ^ strargs end

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

fun strprj (pathvar as (_, (typ, _))) = nameOfPrj typ ^ nameOfVar pathvar

fun filterUnsplit (pathTreeVars: pathTreeVar list) = 
   List.filter (not o Coverage.isUnsplit o #2 o #2) pathTreeVars

fun emitCase terms [] = 
    emit ("(" ^ String.concatWith ", " (map buildTerm terms) ^ ")")
  | emitCase terms (pathTreeVars: pathTreeVar list) = 
    let
    in
       emit ("case ("
             ^ String.concatWith ", " (map strprj pathTreeVars) ^ ") of")
       ; emitMatches "  " terms pathTreeVars [] 
       ; emit ")"
    end
    
and emitMatch prefix terms (matches: pathConstructorVar list) = 
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
       ; emitCase terms (filterUnsplit (List.concat pathvars))
       ; decr ()
    end

(* Somewhat complex to avoid making an intermediate data structure. 
 * Given n treevars with O(m) constructors, calls emitMatch on the O(m*n) 
 * possible patterns. *)
(*[ emitMatches: string 
       -> Ast.term
       -> pathTreeVar list <--- input
       -> pathConstructorVar list <--- kind of output
       -> unit *)
and emitMatches prefix terms [] matches = emitMatch prefix terms (rev matches)
  | emitMatches prefix terms (pathvar :: pathvars) matches =
    let val (is, (typ, pathtree)) = pathvar in 
       case pathtree of 
          Coverage.Unsplit => raise Fail "Invariant"
        | Coverage.Split subtrees => 
          let
(*
             fun replacement (c, []) = 
                 Ast.Const c
               | replacement (f, pathtrees) = 
                 Ast.Structured 
                 (f, map (fn i => nameOfVar (is @ [ i ], ()))
                         (mapi pathtrees))
*)
             val newmatches = MapX.listItemsi subtrees
          in
             emitMatches prefix terms pathvars ((is, hd newmatches) :: matches)
             ; app (fn match =>
                       emitMatches ")|" terms pathvars ((is, match) :: matches))
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
      Ast.term list
      -> pathTreeVar list 
      -> unit = emitCase
val emitMatch:
      string 
      -> Ast.term list
      -> pathConstructorVar list 
      -> unit = emitMatch
val emitMatches: 
      string 
      -> Ast.term list
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
           else emit ("val () = print (\"Visiting " ^ name ^ " \"")
         ; incr ()
         ; app (fn (i, typ) => 
                emit ("^ " ^ nameOfStr typ ^ " x_" ^ Int.toString i)) args
         ; if null args then () else emit "^ \"\\n\")"
         ; decr ()
         ; decr ())
   in
      emit ("fun seek" ^ Name ^ " (" 
            ^ String.concatWith ", " (map nameOfVar pathTreeVars) ^ ") =")
      ; incr ()
      ; emit ("let")
      ; reportworld ()
      ; emit ("in")
      ; incr ()
      ; emitCase startingTerms (filterUnsplit pathTreeVars)
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
            ^(* ":> " ^ getPrefix true "_" ^ "SEARCH" ^ *)" =")
      ; emit "struct"
      ; incr ()
      ; emit ("open " ^ getPrefix true "" ^ "Terms\n")
      ; emit "fun fake () = ()\n"
      ; app emitWorld worlds
      ; decr ()
      ; emit "end"
   end

end
