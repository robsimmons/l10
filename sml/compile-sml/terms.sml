(* Copyright (C) 2011 Robert J. Simmons *)

structure SMLCompileTerms:> sig

val termsSig: unit -> unit
val terms: unit -> unit

end = 
struct

open SMLCompileUtil
open SMLCompileTypes


(* The fundamental view datatype *)
fun emitView isRec x = 
   let
      val () = emit ""
      val name = nameOfType x
      val view = nameOfView x
      fun keyword isRec = if isRec then "and" else "datatype"
      fun args NONE = raise Domain
        | args (SOME ([], _)) = ""
        | args (SOME (types, _)) =
          " of " ^ String.concatWith " * " (map nameOfType types)
      fun emitCases [] = 
          (emit (keyword isRec ^ " " ^ view ^ " =")
           ; emit ("   Void_" ^ embiggen name ^ " of " ^ view))
        | emitCases [ constructor ] = 
          (emit (keyword isRec ^ " " ^ view ^ " =")
           ; emit ("   " ^ embiggen (Symbol.name constructor) 
                   ^ args (ConTab.lookup constructor)))
        | emitCases (constructor :: constructors) = 
          (emitCases constructors
           ; emit (" | " ^ embiggen (Symbol.name constructor)
                   ^ args (ConTab.lookup constructor)))
   in
      emitCases (rev (TypeConTab.lookup x))
   end


(* SML doesn't handle empty types well, so we write an abort function *)
fun emitAbortSig x = 
   if null (TypeConTab.lookup x) 
   then emit ("val abort" ^ NameOfType x ^ ": "
              ^ nameOfView x ^ " -> 'a")
   else ()

fun emitAbort x = 
   if null (TypeConTab.lookup x)
   then (emit ("fun abort" ^ NameOfType x ^ " (Void_" ^ NameOfType x ^ " x) = "
               ^ "abort" ^ NameOfType x ^ " x"))
   else ()


(* Projection functions: quite simple in this implementation *)
fun emitPrj x = 
   let 
      val Name = embiggen (nameOfType x)
   in
      emit ("fun prj" ^ Name ^ " (inj" ^ Name ^ " x) = x")
   end

(* Injecting versions of each of the constructors *)
fun emitInjSig x = 
   let
      val name = nameOfType x
      fun emitSingle constructor = 
         let 
            val args = map nameOfType (#1 (valOf (ConTab.lookup constructor)))
            val constructor = embiggen (Symbol.name constructor) 
         in
            if null args 
            then emit ("val " ^ constructor ^ "': " ^ name)
            else emit ("val " ^ constructor ^ "': " 
                       ^ String.concatWith " * " args ^ " -> " ^ name)
         end
   in
      app emitSingle (TypeConTab.lookup x)
   end

fun emitInj x = 
   let
      val Name = embiggen (nameOfType x)
      fun emitSingle constructor = 
         let 
            val args = map nameOfType (#1 (valOf (ConTab.lookup constructor)))
            val constructor = embiggen (Symbol.name constructor) 
         in
            if null args 
            then emit ("val " ^ constructor ^ "' = " 
                       ^ "inj" ^ Name ^ " " ^ constructor)
            else emit ("val " ^ constructor ^ "' = "
                       ^ "inj" ^ Name ^ " o " ^ constructor)
         end
   in
      app emitSingle (TypeConTab.lookup x)
   end


(* Emit the toString function *)
fun emitStr x = 
   let 
      val name = nameOfType x
      val Name = embiggen name
                         
      fun emitCase prefix constructor =
         case valOf (ConTab.lookup constructor) of
            ([], _) => 
            emit (prefix ^ (embiggen (Symbol.name constructor)) 
                  ^ " => \"" ^ Symbol.name constructor ^ "\"")
          | (types, _) => 
            let 
               val pat = pattern types
               fun emitSingle (typ, var) = 
                  emit (" ^ " ^ nameOfStr typ ^ " " ^ var)
            in 
               emit (prefix ^ (embiggen (Symbol.name constructor)) 
                     ^ " (" ^ String.concatWith ", " (map #2 pat) ^ ") => ")
               ; incr ()
               ; emit "(\"(\""
               ; emit (" ^ \"" ^ Symbol.name constructor ^ " \"")
               ; app emitSingle pat
               ; emit " ^ \")\")"
               ; decr ()
            end

      fun emitCases [] = (emit ("   x => abort" ^ Name ^ " x"))
        | emitCases [ constructor ] = emitCase "   " constructor
        | emitCases (constructor :: constructors) = 
          (emitCases constructors; emitCase " | " constructor)
           
   in
      emit ""
      ; emit ("and str" ^ Name ^ " x = ")
      ; incr ()
      ; emit ("case prj" ^ Name ^ " x of")
      ; emitCases (rev (TypeConTab.lookup x))
      ; decr ()
   end

(* Emit the equality function (relies on the fact that we've got data) *)
fun emitEq x = 
   let 
      val name = nameOfType x
      val Name = NameOfType x
   in
      emit ("fun eq" ^ Name ^ "(x: " ^ name ^ ") (y: " ^ name ^ ") = x = y")
   end

(* Emit the signature parts associated with a type *)
fun emitSig x = 
   let
      val name = nameOfType x
      val view = nameOfView x
      val Name = NameOfType x
   in
      emit ("val str" ^ Name ^ ": " ^ name ^ " -> String.string")
      (* ; emit ("val layout" ^ Name ^ ": " ^ name ^ " -> Layout.t") *)
      ; emit ("val inj" ^ Name ^ ": " ^ view ^ " -> " ^ name)
      ; emit ("val prj" ^ Name ^ ": " ^ name ^ " -> " ^ view)
      ; emit ("val eq" ^ Name ^ ": " ^ name ^ " -> " ^ name ^ " -> bool") 
      ; emitAbortSig x 
(*      ; emit ("structure Set" ^ Name 
              ^ ": ORD_SET where type Key.ord_key = " ^ name)
      ; emit ("structure Map" ^ Name 
              ^ ": ORD_MAP where type Key.ord_key = " ^ name) *)
   end

fun termsSig () = 
   let
      val types = TypeTab.list ()
      val encodedTypes = List.filter encoded types
   in 
      emit ("signature " ^ getPrefix true "_" ^ "TERMS = ")
      ; emit "sig"
      ; incr ()
      ; app (fn x => emit ("type " ^ nameOfType x)) 
           encodedTypes
      ; app (fn x => (emitView false x
                      ; emitSig x 
                      ; emitInjSig x)) 
           encodedTypes
      ; decr ()
      ; emit "end"
   end

fun terms () = 
   let
      val types = TypeTab.list ()
      val encodedTypes = List.filter encoded types
   in
      emit ("structure " ^ getPrefix true "" ^ "Terms:> " 
            ^ getPrefix true "_" ^ "TERMS = ")
      ; emit "struct"
      ; incr ()
      ; emit "(* Datatype views *)\n"
      ; emit "datatype Fake = fake"
      ; app (fn x => 
               (emitView true x
                ; emit ("and " ^ nameOfType x 
                        ^ " = inj" ^ NameOfType x
                        ^ " of " ^ nameOfView x)))
           encodedTypes
      ; emit "\n"
      ; emit "(* Constructor-specific projections, injections, and aborts *)\n"
      ; app emitPrj encodedTypes
      ; app emitInj encodedTypes
      ; app emitAbort encodedTypes
      ; emit "\n"
      ; emit "(* String encoding functions *)\n"
      ; emit "fun strfake () = raise Match"
      ; app emitStr encodedTypes
      ; emit "\n"
      ; emit "(* Equality *)\n"
      ; app emitEq encodedTypes
      ; decr ()
      ; emit "end"
   end

end
