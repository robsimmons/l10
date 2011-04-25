structure SMLCompiler = struct

val preface = "L10"

local val ind = ref 0 
in
fun emit s = print (implode (List.tabulate (!ind, fn _ => #" ")) ^ s ^ "\n")
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
      val () = emit ""
      fun constructorArgs NONE = raise Domain
        | constructorArgs (SOME ([], _)) = ""
        | constructorArgs (SOME (types, _)) =
          " of " ^ String.concatWith " * " (map nameOfType types)
      fun emitView [] = 
          (emit (emitDatatype isRec ^ " " ^ name ^ "View =")
           ; emit ("   Void" ^ embiggen name ^ " of " ^ name ^ "View"))
        | emitView [ constructor ] = 
          (emit (emitDatatype isRec ^ " " ^ name ^ "View =")
           ; emit ("   " ^ embiggen (Symbol.name constructor) 
                   ^ constructorArgs (ConTab.lookup constructor)))
        | emitView (constructor :: constructors) = 
          (emitView constructors
           ; emit (" | " ^ embiggen (Symbol.name constructor)
                   ^ constructorArgs (ConTab.lookup constructor)))
   in
      emitView (rev (TypeConTab.lookup x))
   end

(* Emit the signature parts associated with a type *)
fun emitEncodedSigParts x = 
   let
      val name = nameOfType x
      val Name = embiggen name
   in
      emit ("val str" ^ Name ^ " = " ^ name ^ " -> String.string")
      ; emit ("val inj" ^ Name ^ " = " ^ name ^ "View -> " ^ name)
      ; emit ("val prj" ^ Name ^ " = " ^ name ^ " -> " ^ name ^ "View")
   end

fun types () = 
   let
      val types = TypeTab.list ()
      val encodedTypes = List.filter encoded types
   in 
      emit ("signature " ^ preface ^ "TERMS = ")
      ; emit "sig"
      ; incr ()
      ; app (fn x => emit ("type " ^ nameOfType x)) 
           encodedTypes
      ; app (fn x => (emitEncodedTypeView false x; emitEncodedSigParts x)) 
           encodedTypes
      ; decr ()
      ; emit "end"
   end

end
