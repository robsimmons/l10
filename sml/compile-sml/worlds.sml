(* Robert J. Simmons *)

structure SMLCompileWorlds:> sig

   val worldsSig: unit -> unit 
   val worlds: unit -> unit 

end = 
struct

open SMLCompileUtil
open SMLCompileTypes
open SMLCompileTerms

(* Emit the correct seek functions for a world in the signature *) 

fun emitWorldSig world = 
   let
      val Name = embiggen (Symbol.name world)
      val args = WorldTab.lookup world
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


(* Tabled backwards search *)

fun emitChildSearches w terms = 
   let
      val typs = WorldTab.lookup w
      fun handleArg prefix subst (w, terms) = 
         let val terms' = valOf (Ast.subTerms (subst, terms)) in  
            emit (prefix ^ "seek" ^ embiggen (Symbol.name w) 
                  ^ optTuple buildTerm terms') 
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
            val pattyp = ListPair.zipEq (pat, typs)
            val (terms, subst, eqs) = pathTerms pattyp
            val eqs =
               map (fn (a, b, c) => (a, Symbol.name b, Symbol.name c)) eqs
         in
            if null eqs 
            then (handleArgs prefix subst args)
            else (emit (prefix ^ "(if " 
                        ^ String.concatWith " andalso " (map nameOfEq eqs))
                  ; incr ()
                  ; handleArgsIf subst args
                  ; emit ") else (fn x => x))"
                  ; decr ())
         end
       
      fun handlePats [] = emit "((fn x => x)"
        | handlePats [ (pat, args) ] = handlePat "(" (pat, args)
        | handlePats ((pat, args) :: pats) = 
          (handlePats pats; handlePat " o " (pat, args))

      val pats = List.filter (Path.genTerms terms o #1) (SearchTab.lookup w)
   in
      handlePats pats
   end

fun emitInitialInters w terms = 
   let
      val typs = WorldTab.lookup w

      fun handleSubst' prefix postfix (w, n, subst) = 
         emit (prefix ^ nameOfExec (n, 0) 
               ^ optTuple buildTerm (MapX.listItems subst) ^ postfix)

      fun handleRule prefix (n, (w, pat), _) =
         let
            val pattyp = ListPair.zipEq (pat, typs)
            val (terms, subst, eqs) = pathTerms pattyp
            val eqs =
               map (fn (a, b, c) => (a, Symbol.name b, Symbol.name c)) eqs
         in
            if null eqs
            then handleSubst' prefix " ::" (w, n, subst)
            else (emit (prefix ^ "(if "
                        ^ String.concatWith " andalso " (map nameOfEq eqs))
                  ; handleSubst' "   then [ " " ] else []) @" (w, n, subst))
         end

      fun handleRules [] = false
        | handleRules [ rule ] = (handleRule ", " rule; true)
        | handleRules (rule :: rules) = 
          (handleRules rules before handleRule "  " rule)

      val rules = List.filter (Path.genTerms terms o #2 o #2) (RuleTab.lookup w)
   in
      if handleRules rules
      then emit "  [])"
      else emit ", [])"
   end  

fun emitWorld w =
   let 
      val name = Symbol.name w
      val Name = embiggen (Symbol.name w)
      val typs = WorldTab.lookup w
      val pathtree = WorldMatchTab.lookup w
      val tuple = optTuple (fn (i, _) => Path.var [ i ]) (mapi pathtree)
(*
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
*)

   in
      emit ("and seek" ^ Name ^ tuple ^ " worldmap =")
      ; incr (); emit ("let"); incr ()

      ; emit ("val w = " ^ embiggen (Symbol.name w) ^ "'" ^ tuple)
      ; emit ("val () = if isSome (MapWorld.find (worldmap, w))")
      ; emit ("         then raise Revisit else ()")
      ; emit ("val worldmap = MapWorld.insert (worldmap, w, ())" )
      ; emit ("val (child_searches, rulefns) = ")
      ; incr ()
      ; caseConstructor 
           (fn shapes => 
              (emitChildSearches w shapes; emitInitialInters w shapes))
           pathtree
      ; decr ()
      ; emit ("val worldmap' = child_searches worldmap")
      ; emit ("val () = print (\"Visiting \" ^ strWorld w ^ \"\\n\")")
      ; emit ("val () = loop rulefns")
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
      emit ("signature " ^ String.map Char.toUpper (getPrefix true "_")
            ^ "SEARCH =")
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
            ^ ":> " ^ String.map Char.toUpper (getPrefix true "_")
            ^ "SEARCH" ^ " =")
      ; emit "struct"
      ; incr ()
      ; emit ("open " ^ getPrefix true "" ^ "Terms")
      ; emit ("open " ^ getPrefix true "" ^ "Tables\n")

      ; emit ("fun loop fs = if !cnt = (app (fn f => f ()) fs; !cnt) " 
              ^ "then () else loop fs")

      ; emit ("exception Revisit\n")
      ; emit "fun fake () = ()\n"
      ; app emitWorld worlds
      ; decr ()
      ; emit "end"
   end

end
