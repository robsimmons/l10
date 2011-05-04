structure SMLCompileDeduce = 
struct

open SMLCompileUtil
open SMLCompileTypes
open SMLCompileTerms

fun nameSaturate (w, rule, point) = 
   "saturate" ^ embiggen (Symbol.name w) 
   ^ "_" ^ Int.toString rule
   ^ (if point = 0 then "" else ("_" ^ Int.toString point))

fun nameIndex (a, n) = Symbol.name a ^ "_" ^ Int.toString n

fun pathStr path = "x_" ^ String.concatWith "_" (map Int.toString path)

fun emitIndexType a (n, {terms, input, output}) = 
   let
      val input = rev (MapP.listItemsi input)
      val output = rev (MapP.listItemsi output)
      val input' = String.concatWith " " (map (nameOfMap "map" o #2) input)
      val output' = 
         if length output = 0 then "unit"
         else if length output = 1 then nameOfType (#2 (hd output))
         else "(" ^ String.concatWith " * " (map (nameOfType o #2) output) ^ ")"
      val name = nameIndex (a, n)

      fun inputPattern [] = "()"
        | inputPattern [ path ] = pathStr path
        | inputPattern paths = 
          "(" ^ String.concatWith ", " (map pathStr paths) ^ ")"

      fun emitLookupCases (n, []) = emit ("x" ^ repeat (n, #")"))
        | emitLookupCases (n, (path, typ) :: pathtyps) = 
          (emit ("(case " ^ nameOfMap "find" typ 
                 ^ " (x, " ^ pathStr path ^ ") of") 
           ; emit ("   NONE => []")
           ; emit (" | SOME x => ")
           ; incr ()
           ; emitLookupCases (n+1, pathtyps)
           ; decr ())

      fun emitLookup () = 
        (emit ("fun " ^ name ^ "_lookup (x: " ^ name ^ ") " 
               ^ inputPattern (rev (map #1 input)) ^ " = ")
         ; incr ()
         ; emitLookupCases (0, rev input)
         ; decr ())

      fun next [] = "[]"
        | next ((path, typ) :: pathtyps) = nameOfMap "empty" typ

      fun emitInsertLets (n, []) = ()
        | emitInsertLets (n, (path, typ) :: pathtyps) = 
          (emit ("val y_" ^ Int.toString n ^ " = ")
           ; emit ("   case " ^ nameOfMap "find" typ ^ " (y_" 
                   ^ Int.toString (n-1) ^ ", " ^ pathStr path ^ ") of")
           ; emit ("      NONE => " ^ next pathtyps)
           ; emit ("    | SOME y => y")
           ; emitInsertLets (n+1, pathtyps))

      fun emitInsertInserts (n, []) = 
          emit (inputPattern (rev (map #1 output)) 
                ^ " :: y_" ^ Int.toString n
                ^ repeat (n, #")"))
        | emitInsertInserts (n, (path, typ) :: pathtyps) = 
          (emit (nameOfMap "insert" typ ^ " (y_" ^ Int.toString n ^ ", "
                 ^ pathStr path ^ ",")
           ; emitInsertInserts (n+1, pathtyps))

      fun emitInsert () = 
        (emit ("fun " ^ name ^ "_insert (y_0: " ^ name ^ ") "
               ^ inputPattern (rev (map #1 input)) ^ " "
               ^ inputPattern (rev (map #1 output)) ^ " = ")
         ; incr ()
         ; emit "let"
         ; incr ()
         ; emitInsertLets (1, (rev input))
         ; decr ()
         ; emit "in"
         ; incr ()
         ; emitInsertInserts (0, (rev input))
         ; decr ()
         ; emit "end"
         ; decr ())
   in 
      emit ("type " ^ name ^ " = " ^ output' ^ " list " ^ input')
      ; emit ("val " ^ name ^ ": " ^ name ^ " ref = ref " ^ 
              (if length input = 0 then "[]" 
               else nameOfMap "empty" (#2 (hd (rev input)))))
      ; emitLookup ()
      ; emitInsert ()
      ; emit ""
   end

fun emitIndexTypes a = app (emitIndexType a) (mapi (rev (IndexTab.lookup a)))

fun emitSaturate w (rule, point, fv) = 
   let in
      emit ""
      ; emit ("and " ^ nameSaturate (w, rule, point)
              ^ " { " 
              ^ String.concatWith ", " 
                 (map (Symbol.name o #1) (MapX.listItemsi fv))
              ^ " } () = ()")
   end

fun emitSaturates w = app (emitSaturate w) (rev (InterTab.lookup w))

fun deduce () = 
   let 
      val worlds = WorldTab.list ()
   in 
      emit ("structure " ^ getPrefix true "" ^ "Deduce =")
      ; emit "struct"
      ; incr ()
      ; emit ("open " ^ getPrefix true "" ^ "Terms\n") 
      ; emit "(* Index types *)\n"
      ; app emitIndexTypes (IndexTab.list ())
      ; emit "(* Eager run-saturation functions for the McAllester loop *)\n"
      ; emit "fun fake () = ()"
      ; app emitSaturates worlds
      ; decr ()
      ; emit "end"
   end

end
