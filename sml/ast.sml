structure Ast = 
struct

datatype term = 
   Const of string
 | IntConst of int
 | StrConst of string
 | Structured of string * term list
 | Var of string

type arg = string option * string
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
   DeclDatabase of string * atomic list * world
 | DeclDepends of string * string
 | DeclRelation of string * arg list * world
 | DeclRule of pattern list * atomic
 | DeclType of string * arg list
 | DeclWorld of string * arg list

end
