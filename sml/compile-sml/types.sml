(* Compilation *)

struct Types = 
struct


end


(* 
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
   val nameOfTypeExt: Symbol.symbol -> string (* Adds Term*. prefix *)
      
   (* The name of the <whatever> function associated with this type *)
   val nameOfStr: Symbol.symbol -> string
   val nameOfPrj: Symbol.symbol -> string
   val nameOfTree: string -> Symbol.symbol -> string
   val nameOfEq: Symbol.symbol * string * string -> string
   val nameOfMap: string -> Symbol.symbol -> string

   (* Utility for doing arbitrary-depth matching over pathtrees *)
   val caseConstructor: 
      (Ast.shapeTerm list -> unit)      (* Act, given a general shape *)
      -> Path.tree list                 (* Initial list of pathtrees *)
      -> unit

end = 
struct

open SMLCompileUtil

val ttyp = Symbol.symbol "t"
val nattyp = Symbol.symbol "nat"
val stringtyp = Symbol.symbol "string"

fun encoded x = 
   let val extensible = TypeTab.lookup x
   in extensible = TypeTab.YES orelse extensible = TypeTab.NO end

fun nameOfType x = 
   case TypeTab.lookup x of 
      TypeTab.CONSTANTS => "Symbol.symbol"
    | TypeTab.SPECIAL => 
      if x = nattyp then "IntInf.int"
      else if x = stringtyp then "String.string"
      else raise Fail "nameOfType called on unknown special type"
    | _ => Symbol.name x

fun nameOfTypeExt x = 
   (if encoded x then (getPrefix true "" ^ "Terms.") else "") ^ nameOfType x

fun NameOfType x = 
   if encoded x then embiggen (Symbol.name x) 
   else raise Fail ("Invariant in NameOfType (" ^ Symbol.name x ^ ")")
fun nameOfView x = 
   if encoded x then Symbol.name x ^ "_view" 
   else raise Fail ("Invariant in nameOfView (" ^ Symbol.name x ^ ")")


fun nameOfPrj x = 
   case TypeTab.lookup x of
      TypeTab.YES => "prj" ^ NameOfType x ^ " "
    | TypeTab.NO => "prj" ^ NameOfType x ^ " "
    | _ => ""

(* We don't have to special case this, the emitted code emits for built-ins *)
fun nameOfTree prefix x = 
   prefix ^ embiggen (Symbol.name x) ^ " " 


fun nameOfStr x = 
   case TypeTab.lookup x of
      TypeTab.CONSTANTS => "Symbol.name"
    | TypeTab.SPECIAL =>
      if x = nattyp then "IntInf.toString"
      else if x = stringtyp then 
        "(fn x => \"\\\"\" ^ String.toCString x ^ \"\\\"\")"
      else raise Domain
    | _ => "str" ^ (embiggen (Symbol.name x))

fun nameOfEq (x, arg1, arg2) =
   case TypeTab.lookup x of
      TypeTab.YES => "eq" ^ (embiggen (Symbol.name x)) ^ " " ^ arg1 ^ " " ^ arg2
    | TypeTab.NO => "eq" ^ (embiggen (Symbol.name x)) ^ " " ^ arg1 ^ " " ^ arg2
    | _ => arg1 ^ " = " ^ arg2

fun nameOfMap thing x = 
   if x = TypeTab.t then ("MapX." ^ thing)
   else if x = TypeTab.nat then ("MapII." ^ thing)
   else if x = TypeTab.string then ("MapS." ^ thing)
   else ("Map" ^ embiggen (Symbol.name x) ^ "." ^ thing)

fun caseConstructor f pathtree = 
   let 
      fun emitSplits shapes pathtree = 
         case pathtree of 
            [] => f shapes
          | (path, Path.Unsplit _) :: pathtree => emitSplits shapes pathtree
          | (path, Path.Split (typ, subtrees)) :: pathtree => 
            let val constructors = TypeConTab.lookup typ in
               emit ("(case " ^ nameOfPrj typ ^ Path.var path ^ " of")
               ; appFirst 
                  (fn () => emit ("   Void_" ^ NameOfType typ 
                                  ^ " x = abort" ^ NameOfType typ ^ " x"))
                  (emitCases shapes path subtrees pathtree)
                  ("   ", " | ") constructors
               ; emit ")"
            end
          | _ => raise Fail "Unimplemented form of splitting"

      and emitCases shapes path subtrees pathtree prefix constructor = 
         let
            val typs = #1 (ConTab.lookup constructor)
            val shape =
               if null typs then Ast.Const constructor
               else Ast.Structured (constructor, map (fn _ => Ast.Var ()) typs)
            val new_shapes = Path.substs (path, shapes, shape)
            val new_pathtree = 
               map (fn (i, a) => (path @ [ i ], a))
                  (mapi (MapX.lookup (subtrees, constructor)))
         in
            emit (prefix ^ embiggen (Symbol.name constructor) 
                  ^ optTuple (Path.var o #1) new_pathtree ^ " => ")
            ; incr ()
            ; emitSplits new_shapes (new_pathtree @ pathtree)
            ; decr ()
         end
   in 
      emitSplits 
         (map (fn _ => Ast.Var ()) pathtree)
         (map (fn (i, a) => ([ i ], a)) (mapi pathtree))
   end


end
*)
