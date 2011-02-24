structure Ast = 
struct

datatype term = 
   Const of Symbol.symbol
 | NatConst of IntInf.int
 | StrConst of string
 | Structured of Symbol.symbol * term list
 | Var of Symbol.symbol option

type typ = Symbol.symbol
type arg = Symbol.symbol option * typ
type atomic = Symbol.symbol * term list
type world = Symbol.symbol * term list

datatype pattern = 
   Atomic of atomic
 | Exists of Symbol.symbol * pattern
 | Conj of pattern * pattern
 | One

datatype prem = 
   Normal of pattern
 | Negated of pattern
 | Count of pattern * term

datatype decl = 
   DeclConst of Symbol.symbol * arg list * string
 | DeclDatabase of Symbol.symbol * atomic list * world
 | DeclDepends of world * world list
 | DeclRelation of Symbol.symbol * arg list * world
 | DeclRule of prem list * atomic list
 | DeclType of Symbol.symbol 
 | DeclWorld of Symbol.symbol * arg list

fun lp parens = if parens then "(" else ""
fun rp parens = if parens then ")" else ""

fun strTerm' parens term = 
   case term of 
      Const c => Symbol.name c
    | NatConst i => IntInf.toString i
    | StrConst s => "\"" ^ s ^ "\""
    | Structured (f, terms) => 
      lp parens 
      ^ Symbol.name f 
      ^ String.concat (map (fn term => " " ^ strTerm' true term) terms)
      ^ rp parens
    | Var NONE => "_"
    | Var (SOME x) => Symbol.name x

fun strTerm term = strTerm' false term

fun termFV t =
   case t of 
      Var (SOME x) => SetX.singleton x
    | Structured (_, tms) => termsFV tms
    | _ => SetX.empty

and termsFV ts = 
   List.foldr (fn (t, set) => SetX.union (termFV t, set)) SetX.empty ts

end
