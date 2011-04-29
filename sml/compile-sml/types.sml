(* Compilation *)

structure SMLCompileTypes:> sig
   
   (* Symbols corresponding to built-in types *)
   val ttyp: Symbol.symbol      (* built-in type t      *)
   val nattyp: Symbol.symbol    (* built-in type nat    *)
   val stringtyp: Symbol.symbol (* built-in type string *)

   (* Returns true if a type will be encoded as a datatype *)
   val encoded: Symbol.symbol -> bool

   (* Get various SML types associated with a symbol *)
   val nameOfType: Symbol.symbol -> string (* All types in TypeTab *)
   val nameOfView: Symbol.symbol -> string (* requires encoded x = true *)
   val NameOfType: Symbol.symbol -> string (* requires encoded x = true *)
      
   (* The name of the <whatever> function associated with this type *)
   val nameOfStr: Symbol.symbol -> string
   val nameOfPrj: Symbol.symbol -> string
   val nameOfTree: string -> Symbol.symbol -> string
   val nameOfEq: Symbol.symbol -> string -> string -> string

end = 
struct

open SMLCompileUtil

val ttyp = Symbol.symbol "t"
val nattyp = Symbol.symbol "nat"
val stringtyp = Symbol.symbol "string"

fun encoded x = 
   let val extensible = valOf (TypeTab.lookup x) 
   in extensible = TypeTab.YES orelse extensible = TypeTab.NO end

fun nameOfType x = 
   case valOf (TypeTab.lookup x) of 
      TypeTab.CONSTANTS => "Symbol.symbol"
    | TypeTab.SPECIAL => 
      if x = nattyp then "IntInf.int"
      else if x = stringtyp then "String.string"
      else raise Fail "nameOfType called on unknown special type"
    | _ => Symbol.name x

fun NameOfType x = 
   if encoded x then embiggen (Symbol.name x) else raise Fail "Invariant"
fun nameOfView x = 
   if encoded x then Symbol.name x ^ "_view" else raise Fail "Invariant"


fun nameOfPrj x = 
   case valOf (TypeTab.lookup x) of
      TypeTab.YES => "prj" ^ NameOfType x ^ " "
    | TypeTab.NO => "prj" ^ NameOfType x ^ " "
    | _ => ""

(* We don't have to special case this, the emitted code emits for built-ins *)
fun nameOfTree prefix x = 
   prefix ^ embiggen (Symbol.name x) ^ " " 


fun nameOfStr x = 
   case valOf (TypeTab.lookup x) of
      TypeTab.CONSTANTS => "Symbol.name"
    | TypeTab.SPECIAL =>
      if x = nattyp then "IntInf.toString"
      else if x = stringtyp then 
        "(fn x => \"\\\"\" ^ String.toCString x ^ \"\\\"\")"
      else raise Domain
    | _ => "str" ^ (embiggen (Symbol.name x))

fun nameOfEq x arg1 arg2 =
   case valOf (TypeTab.lookup x) of
      TypeTab.YES => "eq" ^ (embiggen (Symbol.name x)) ^ " " ^ arg1 ^ " " ^ arg2
    | TypeTab.NO => "eq" ^ (embiggen (Symbol.name x)) ^ " " ^ arg1 ^ " " ^ arg2
    | _ => arg1 ^ " = " ^ arg2

end
