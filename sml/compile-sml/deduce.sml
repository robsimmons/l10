structure SMLCompileDeduce = 
struct

open SMLCompileUtil
open SMLCompileTypes
open SMLCompileTerms

fun nameInter (w, rule, point) = 
   embiggen (Symbol.name w) ^ "_" ^ Int.toString rule ^ "_" ^ Int.toString point

fun emitSearchDatatype w = 
   let
      fun fvtype (x, typ) = 
         Symbol.name x ^ ": " ^ nameOfTypeExt typ

      fun emitCase prefix (rule, point, fv) = 
         emit (prefix ^ nameInter (w, rule, point) 
               ^ " of { " 
               ^ String.concatWith ", " (map fvtype (MapX.listItemsi fv))
               ^ " }")

      fun emitCases [] = () (* World with no rules attached, sure *)
        | emitCases [ inter ] =
          (emit ""
           ; emit ("datatype inter" ^ embiggen (Symbol.name w) ^ " = ")
           ; emitCase "   " inter)
        | emitCases (inter :: inters) = 
          (print ("Number of cases: " ^ Int.toString (length inters + 1) ^ "\n")
           ; emitCases inters
           ; emitCase " | " inter)

   in
      emitCases (InterTab.lookup w)
   end

fun deduce () = 
   let 
      val worlds = WorldTab.list ()
   in 
      emit ("structure " ^ getPrefix true "" ^ "Deduce =")
      ; emit "struct"
      ; incr ()
      (* ; emit ("open " ^ getPrefix true "" ^ "Terms\n") *)
      ; emit "(* Datatypes for intermediate stages in the McAllester loop *)"
      ; app emitSearchDatatype worlds
      ; decr ()
      ; emit "end"
   end

end
