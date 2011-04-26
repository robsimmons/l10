(* Robert J. Simmons *)

structure SMLCompileWorlds:> sig

   val worldsSig: unit -> unit 
   val worlds: unit -> unit 

end = 
struct

open SMLCompileUtil
open SMLCompileTypes
open SMLCompileTerms

fun mapi' n [] = []
  | mapi' n (x :: xs) = (n, x) :: mapi' (n+1) xs

fun mapi xs = mapi' 1 xs

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

(* Specal case for when *)

fun emitWorld world =
   let 
      val name = Symbol.name world
      val Name = embiggen (Symbol.name world)
      val typs = valOf (WorldTab.lookup world)
      val args = mapi typs
      val pathargs = map (fn (x, y) => ([ x ], y)) args
      fun strarg (is, typ) = "x_" ^ String.concatWith "_" (map Int.toString is)

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
            ^ String.concatWith ", " (map strarg pathargs) ^ ")")
      ; incr ()
      ; emit ("let")
      ; reportworld ()
      ; emit ("in")
      ; incr ()
      ; emit "()"
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
      emit ("struct " ^ getPrefix true "" ^ "Search:> "
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
