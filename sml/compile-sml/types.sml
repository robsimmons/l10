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
      
   (* The name of the to-string version of this type *)
   val nameOfStr: Symbol.symbol -> string

   (* Takes a list of types and annotates it with proper variable names *)
   val pattern: Symbol.symbol list -> (Symbol.symbol * string) list

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

fun nameOfStr x = 
   case valOf (TypeTab.lookup x) of
      TypeTab.CONSTANTS => "Symbol.name"
    | TypeTab.SPECIAL =>
      if x = nattyp then "IntInf.toString"
      else if x = stringtyp then 
        "(fn x => \"\\\"\" ^ String.toCString x ^ \"\\\"\")"
      else raise Domain
    | _ => "str" ^ (embiggen (Symbol.name x))

fun pattern types = 
   rev (#2 (List.foldl 
              (fn (typ, (n, pat)) => 
                 (n+1, (typ, Symbol.name typ ^ "_" ^ Int.toString n) :: pat))
              (1, []) 
              types))


end
