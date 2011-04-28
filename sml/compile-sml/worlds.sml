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

type pathvar = Coverage.pathtree pathvar

(* Using SearchTab, come up with a sufficiently expanded set of pathtrees *)
fun makePaths world args =
   let 
      val seed: pathvar list = 
         map (fn (n, typ) => ([ n ], (typ, Coverage.Unsplit))) args

      fun mapper (term, (is, pathtree)) =
         (is, Coverage.extendpaths (term, pathtree))
      fun folder (terms, pathvars) = 
         map mapper (ListPair.zipEq (terms, pathvars))
   in
      List.foldr folder seed (map #1 (SearchTab.lookup world))
   end

fun strprj (pathvar as (_, (typ, _))) = nameOfPrj typ ^ nameOfVar pathvar

fun filterUnsplit (pathvars: pathvar list) = 
   List.filter (not o Coverage.isUnsplit o #2 o #2) pathvars

fun emitCase [] = emit "()"
  | emitCase (pathvars: pathvar list) = 
    let
    in
       emit ("case (" ^ String.concatWith ", " (map strprj pathvars) ^ ") of")
       ; emitMatches "  " pathvars [] 
       ; emit ")"
    end
    
and emitMatch prefix matches = 
    let 
       fun singlePathvar (is, (constructor, subpaths)) = 
          let 
             val pathvars: pathvar list = 
                map (fn (i, subpath) => (is @ [ i ], subpath)) (mapi subpaths)
          in 
             (filterUnsplit pathvars,
              (embiggen (Symbol.name constructor) 
               ^ (if null pathvars then ""
                  else (" (" ^ String.concatWith ", " (map nameOfVar pathvars) 
                        ^ ")"))))
          end
           
       val (pathvars, patterns) = ListPair.unzip (map singlePathvar matches)
    in
       emit (prefix ^ "(" ^ String.concatWith ", " patterns ^ ") => (")
       ; incr ()
       ; emitCase (List.concat pathvars)
       ; decr ()
    end

and emitMatches prefix [] matches = emitMatch prefix (rev matches)
  | emitMatches prefix ((is, (typ, pathtree)) :: pathvars) matches =
    (case pathtree of 
        Coverage.Unsplit => raise Fail "Invariant"
      | Coverage.Split subtrees => 
        let
           val newmatches = MapX.listItemsi subtrees
        in
           emitMatches prefix pathvars ((is, hd newmatches) :: matches)
           ; app (fn match =>
                     emitMatches ")|" pathvars ((is, match) :: matches))
                (tl newmatches)
        end
      | Coverage.StringSplit _ => 
        raise Fail "Splitting on strings unimplemented"
      | Coverage.NatSplit _ => 
        raise Fail "Splitting on naturals unimplemented"
      | Coverage.SymbolSplit _ => 
        raise Fail "Splitting on symbols unimplemented")

fun emitWorld world =
   let 
      val name = Symbol.name world
      val Name = embiggen (Symbol.name world)
      val typs = valOf (WorldTab.lookup world)
      val args = mapi typs
      val pathvars = makePaths world args

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
            ^ String.concatWith ", " (map nameOfVar pathvars) ^ ") =")
      ; incr ()
      ; emit ("let")
      ; reportworld ()
      ; emit ("in")
      ; incr ()
      ; emitCase (filterUnsplit pathvars)
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
      emit ("structure " ^ getPrefix true "" ^ "Search:> "
            ^ getPrefix true "_" ^ "SEARCH =")
      ; emit "struct"
      ; incr ()
      ; emit ("open " ^ getPrefix true "" ^ "Terms\n")
      ; emit "fun fake () = ()\n"
      ; app emitWorld worlds
      ; decr ()
      ; emit "end"
   end

end
