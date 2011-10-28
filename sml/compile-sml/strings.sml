structure SMLStrings:> 
sig
   (* Given and a string representing an SML expression of that type, mediate
    * between the type and the standard view of that type. *)
   val prj: Type.t -> string -> string (* prj: type -> view *)
   val inj: Type.t -> string -> string (* inj: view -> type *)

   (* Given a constructor, return the pattern destructor (a view). *)
   (* Given a constructor, return the pattern constructor (an injection). *)
   val pattern: Symbol.symbol -> string
   val builder: Symbol.symbol -> string 
end =
struct

fun embiggen x = 
let 
   val s = Symbol.toValue x
   val len = size s
   val fst = if len = 0 then raise Domain else String.sub (s, 0)
   val rest = String.substring (s, 1, len - 1)
in
   if not (Char.isLower fst) 
   then raise Fail ("Function 'embiggen' called on string with " 
                    ^ "first character '" ^ str fst ^ "'")
   else str (Char.toUpper fst) ^ rest
end

fun prjOrInj which t s = 
   case Tab.lookup Tab.types t of 
      Class.Type => 
        (case Tab.find Tab.representations t of 
            SOME Type.Transparent => s 
          | SOME Type.HashConsed => raise Fail "Don't know how to hashcons yet"
          | SOME Type.External => s
          | SOME Type.Sealed =>
              "(" ^ embiggen t ^ "." ^ which ^ " " ^ s ^ ")"
          | NONE =>
              "(" ^ embiggen t ^ "." ^ which ^ " " ^ s ^ ")")
    | Class.Extensible => "(Symbol.toValue " ^ s ^ ")"
    | Class.Builtin => s 

val prj = prjOrInj "prj"
val inj = prjOrInj "inj"

fun patternOrBuilder isBuilder c = 
let 
   val t = Class.base (Tab.lookup Tab.consts c)
   val base = embiggen t ^ "." ^ embiggen c
in
   case Tab.lookup Tab.types t of
      Class.Type =>
        (case Tab.find Tab.representations t of 
            SOME Type.Transparent => base
          | SOME Type.HashConsed => raise Fail "Don't know how to hashcons yet"
          | SOME Type.External => base
          | SOME Type.Sealed => base ^ "'"
          | NONE => base ^ "'")
    | Class.Extensible => "(Symbol.fromValue \"" ^ Symbol.toValue c ^ "\")" 
    | Class.Builtin => 
         if not isBuilder 
         then raise Fail ("Builtin pattern `" ^ Symbol.toValue c ^ "`?") 
         else if Symbol.eq (Term.plus, c) then "IntInf.+"
         else raise Fail ("Builtin builder `" ^ Symbol.toValue c ^ "`?") 
end

val pattern = patternOrBuilder false
val builder = patternOrBuilder true

end
