structure SMLCompileDeduce = 
struct

open SMLCompileUtil
open SMLCompileTypes
open SMLCompileTerms

fun nameSaturate (w, rule, point) = 
   "saturate" ^ embiggen (Symbol.name w) 
   ^ "_" ^ Int.toString rule
   ^ (if point = 0 then "" else ("_" ^ Int.toString point))

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
      ; emit "(* Index types *)\n"
      (* ; emit ("open " ^ getPrefix true "" ^ "Terms\n") *)
      ; emit "(* Eager run-saturation functions for the McAllester loop *)\n"
      ; emit "fun fake () = ()"
      ; app emitSaturates worlds
      ; decr ()
      ; emit "end"
   end

end
