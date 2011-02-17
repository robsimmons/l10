structure Ast = 
struct

datatype term = 
   Const of string
 | IntConst of int
 | StrConst of string
 | Structured of string * term list
 | Var of string option

type typ = string
type arg = string option * typ
type atomic = string * term list
type world = string * term option

datatype pattern = 
   Atomic of atomic
 | Exists of string * pattern

datatype prem = 
   Normal of pattern
 | Negated of pattern
 | Count of pattern * term

datatype decl = 
   DeclConst of string * arg list * string
 | DeclDatabase of string * atomic list * world
 | DeclDepends of string * string
 | DeclRelation of string * arg list * world
 | DeclRule of prem list * atomic
 | DeclType of string 
 | DeclWorld of string * arg list

end
