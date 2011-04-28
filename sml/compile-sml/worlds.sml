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

type patharg = int list * Coverage.pathtree

(* Using SearchTab, come up with a sufficiently expanded set of pathtrees *)
fun makePaths world args =
   let 
      val seed: patharg list = 
         map (fn (n, typ) => ([ n ], (typ, Coverage.Unsplit))) args

      fun mapper (term, (is, pathtree)) =
         (is, Coverage.extendpaths (term, pathtree))
      fun folder (terms, pathargs) = 
         map mapper (ListPair.zipEq (terms, pathargs))
   in
      List.foldr folder seed (map #1 (SearchTab.lookup world))
   end

fun strprj (pathvar as (_, (typ, _))) = nameOfPrj typ ^ nameOfVar pathvar

fun filterUnsplit (pathargs: patharg list) = 
   List.filter (not o Coverage.isUnsplit o #2 o #2) pathargs

fun emitCase [] = emit "()"
  | emitCase (pathargs: patharg list) = 
    let
    in
       emit ("case (" ^ String.concatWith ", " (map strprj pathargs) ^ ") of")
       ; emitMatches "  " pathargs [] 
       ; emit ")"
    end
    
and emitMatch prefix matches = 
    let 
       fun singlePatharg (is, (constructor, subpaths)) = 
          let 
             val pathargs: patharg list = 
                map (fn (i, subpath) => (is @ [ i ], subpath)) (mapi subpaths)
          in 
             (filterUnsplit pathargs,
              (embiggen (Symbol.name constructor) 
               ^ (if null pathargs then ""
                  else (" (" ^ String.concatWith ", " (map nameOfVar pathargs) 
                        ^ ")"))))
          end
           
       val (pathargs, patterns) = ListPair.unzip (map singlePatharg matches)
    in
       emit (prefix ^ "(" ^ String.concatWith ", " patterns ^ ") => (")
       ; incr ()
       ; emitCase (List.concat pathargs)
       ; decr ()
    end

and emitMatches prefix [] matches = emitMatch prefix (rev matches)
  | emitMatches prefix ((is, (typ, pathtree)) :: pathargs) matches =
    (case pathtree of 
        Coverage.Unsplit => raise Fail "Invariant"
      | Coverage.Split subtrees => 
        let
           val newmatches = MapX.listItemsi subtrees
        in
           emitMatches prefix pathargs ((is, hd newmatches) :: matches)
           ; app (fn match =>
                     emitMatches ")|" pathargs ((is, match) :: matches))
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
      val pathargs = makePaths world args

      (* Outputs code for saying "I am here" *)
      fun reportworld () = 
        (incr ()
         ; if null args 
           then emit ("val () = print (\"Visiting " ^ name ^ "\\n\")")
           else emit ("val () = print (\"Visiting " ^ name ^ " (\"")
         ; incr ()
         ; app (fn (i, typ) => 
                emit ("^ " ^ nameOfStr typ ^ " x_" ^ Int.toString i)) args
         ; if null args then () else emit "^ \")\\n\")"
         ; decr ()
         ; decr ())
   in
      emit ("fun seek" ^ Name ^ " (" 
            ^ String.concatWith ", " (map nameOfVar pathargs) ^ ") =")
      ; incr ()
      ; emit ("let")
      ; reportworld ()
      ; emit ("in")
      ; incr ()
      ; emitCase (filterUnsplit pathargs)
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
