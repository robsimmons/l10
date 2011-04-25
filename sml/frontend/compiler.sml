structure SMLCompiler = struct

val preface = "L10"
val outstream = ref TextIO.stdOut

local val ind = ref 0 
in
fun emit s = 
   let val buffer = implode (List.tabulate (!ind, fn _ => #" "))
   in TextIO.output (!outstream, buffer ^ s ^ "\n") end
fun incr () = ind := !ind + 3
fun decr () = ind := !ind - 3
end

(* assumes: str has a first character, which is lowercase *)
(* returns: the same string, with the first character uppercased *)
fun embiggen s = 
   let 
      val len = size s
      val fst = if len = 0 then raise Domain else String.sub (s, 0)
      val rest = String.substring (s, 1, len - 1)
   in
      if not (Char.isLower fst) then raise Domain
      else str (Char.toUpper fst) ^ rest
   end

val nattyp = Symbol.symbol "nat"
val stringtyp = Symbol.symbol "string"

fun nameOfType x = 
   case valOf (TypeTab.lookup x) of 
      TypeTab.CONSTANTS => "Symbol.symbol"
    | TypeTab.SPECIAL => 
      if x = nattyp then "IntInf.int"
      else if x = stringtyp then "String.string"
      else raise Domain
    | _ => Symbol.name x

fun nameOfView x = nameOfType x ^ "_view"

fun NameOfType x = embiggen (nameOfType x)

fun nameOfStr x = 
   case valOf (TypeTab.lookup x) of
      TypeTab.CONSTANTS => "Symbol.name"
    | TypeTab.SPECIAL =>
      if x = nattyp then "IntInf.toString"
      else if x = stringtyp then 
        "(fn x => \"\\\"\" ^ String.toCString x ^ \"\\\"\")"
      else raise Domain
    | _ => "str" ^ (embiggen (Symbol.name x))

fun encoded x = 
   let val extensible = valOf (TypeTab.lookup x) 
   in extensible = TypeTab.YES orelse extensible = TypeTab.NO end

fun emitDatatype isRec = if isRec then "and" else "datatype"

(* emitEncoded* functions 
 * require that TypeTab.lookup x = TypeTab.YES or TypeTab.NO *)

(* Emit the datatype view *)
fun emitEncodedTypeView isRec x = 
   let
      val name = nameOfType x
      val view = nameOfView x
      val () = emit ""
      fun constructorArgs NONE = raise Domain
        | constructorArgs (SOME ([], _)) = ""
        | constructorArgs (SOME (types, _)) =
          " of " ^ String.concatWith " * " (map nameOfType types)
      fun emitView [] = 
          (emit (emitDatatype isRec ^ " " ^ view ^ " =")
           ; emit ("   Void_" ^ embiggen name ^ " of " ^ view))
        | emitView [ constructor ] = 
          (emit (emitDatatype isRec ^ " " ^ view ^ " =")
           ; emit ("   " ^ embiggen (Symbol.name constructor) 
                   ^ constructorArgs (ConTab.lookup constructor)))
        | emitView (constructor :: constructors) = 
          (emitView constructors
           ; emit (" | " ^ embiggen (Symbol.name constructor)
                   ^ constructorArgs (ConTab.lookup constructor)))
   in
      emitView (rev (TypeConTab.lookup x))
   end

(* Make an abort function for each empty type *)
fun emitEncodedAbortSig x = 
   if null (TypeConTab.lookup x) 
   then emit ("val abort" ^ NameOfType x ^ ": "
              ^ nameOfView x ^ " -> 'a")
   else ()

fun emitEncodedAbortStruct x = 
   if null (TypeConTab.lookup x)
   then (emit ("fun abort" ^ NameOfType x ^ " (Void_" ^ NameOfType x ^ " x) = "
               ^ "abort" ^ NameOfType x ^ " x"))
   else ()

(* Projection functions are quite simple in this implementation *)
fun emitEncodedPrj x = 
   let 
      val Name = embiggen (nameOfType x)
   in
      emit ("fun prj" ^ Name ^ " (inj" ^ Name ^ " x) = x")
   end

fun typesPat types = 
   rev (#2 (List.foldl 
              (fn (typ, (n, pat)) => 
                 (n+1, (typ, Symbol.name typ ^ "_" ^ Int.toString n) :: pat))
              (1, []) 
              types))

(* Injection constructors *)
fun emitEncodedInjConstructorsSig x = 
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

fun emitEncodedInjConstructors x = 
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
fun emitEncodedToString x = 
   let 
      val name = nameOfType x
      val Name = embiggen name
                         
      fun emitMatch prefix constructor =
         case valOf (ConTab.lookup constructor) of
            ([], _) => 
            emit (prefix ^ (embiggen (Symbol.name constructor)) 
                  ^ " => \"" ^ Symbol.name constructor ^ "\"")
          | (types, _) => 
            let 
               val pat = typesPat types
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

      fun emitView [] = (emit ("   x => abort" ^ Name ^ " x"))
        | emitView [ constructor ] = emitMatch "   " constructor
        | emitView (constructor :: constructors) = 
          (emitView constructors; emitMatch " | " constructor)
           
   in
      emit ""
      ; emit ("and str" ^ Name ^ " x = ")
      ; incr ()
      ; emit ("case prj" ^ Name ^ " x of")
      ; emitView (rev (TypeConTab.lookup x))
      ; decr ()
   end

(* Emit the signature parts associated with a type *)
fun emitEncodedSigParts x = 
   let
      val name = nameOfType x
      val view = nameOfView x
      val Name = embiggen name
   in
      emit ("val str" ^ Name ^ ": " ^ name ^ " -> String.string")
      (* ; emit ("val layout" ^ Name ^ ": " ^ name ^ " -> Layout.t") *)
      ; emit ("val inj" ^ Name ^ ": " ^ view ^ " -> " ^ name)
      ; emit ("val prj" ^ Name ^ ": " ^ name ^ " -> " ^ view)
      ; emitEncodedAbortSig x 
(*      ; emit ("structure Set" ^ Name 
              ^ ": ORD_SET where type Key.ord_key = " ^ name)
      ; emit ("structure Map" ^ Name 
              ^ ": ORD_MAP where type Key.ord_key = " ^ name) *)
   end

fun termSig () = 
   let
      val types = TypeTab.list ()
      val encodedTypes = List.filter encoded types
   in 
      emit ("signature " ^ preface ^ "TERMS = ")
      ; emit "sig"
      ; incr ()
      ; app (fn x => emit ("type " ^ nameOfType x)) 
           encodedTypes
      ; app (fn x => (emitEncodedTypeView false x
                      ; emitEncodedSigParts x 
                      ; emitEncodedInjConstructorsSig x)) 
           encodedTypes
      ; decr ()
      ; emit "end"
   end

fun termStruct () = 
   let
      val types = TypeTab.list ()
      val encodedTypes = List.filter encoded types
   in
      emit ("structure " ^ preface ^ "Terms:> " ^ preface ^ "TERMS = ")
      ; emit "struct"
      ; incr ()
      ; emit "(* Datatype views *)\n"
      ; emit "datatype Fake = fake"
      ; app (fn x => 
               (emitEncodedTypeView true x
                ; emit ("and " ^ nameOfType x 
                        ^ " = inj" ^ NameOfType x
                        ^ " of " ^ nameOfView x)))
           encodedTypes
      ; emit "\n"
      ; emit "(* Constructor-specific projections, injections, and aborts *)\n"
      ; app emitEncodedPrj encodedTypes
      ; app emitEncodedInjConstructors encodedTypes
      ; app emitEncodedAbortStruct encodedTypes
      ; emit "\n"
      ; emit "(* String encoding functions *)\n"
      ; emit "fun strfake () = raise Match"
      ; app emitEncodedToString encodedTypes
      ; decr ()
      ; emit "end"
   end

end
