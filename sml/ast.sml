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

datatype world = 
   WConst of Symbol.symbol
 | WStructured of Symbol.symbol * term

datatype pattern = 
   Atomic of atomic
 | Exists of Symbol.symbol * pattern

datatype prem = 
   Normal of pattern
 | Negated of pattern
 | Count of pattern * term

datatype decl = 
   DeclConst of Symbol.symbol * arg list * string
 | DeclDatabase of Symbol.symbol * atomic list * world
 | DeclDepends of Symbol.symbol * Symbol.symbol
 | DeclRelation of Symbol.symbol * arg list * world
 | DeclRule of prem list * atomic list
 | DeclType of Symbol.symbol 
 | DeclWorld of Symbol.symbol * arg list

end
