(* Abstract syntax tree for L10 *)
(* Robert J. Simmons *)

signature AST = 
sig

datatype term = 
   Const of Symbol.symbol
 | NatConst of IntInf.int
 | StrConst of string
 | Structured of Symbol.symbol * term list
 | Var of Symbol.symbol option

type subst = term MapX.map
val eqTerm:   term * term -> bool
val fvTerm:   term -> SetX.set
val fvTerms:  term list -> SetX.set
val strTerm': bool -> term -> string
val strTerm:  term -> string
val subTerm:  subst * term -> term option             (* total substitution  *)
val subTerms: subst * term list -> (term list) option (* total substitution  *)
val subTerm': (term * Symbol.symbol) -> term -> term  (* substitution [M/x]N *)
val uscoresInTerm: term -> bool
val uscoresInTerms: term list -> bool

type typ = Symbol.symbol 
val strTyps: typ list -> string

type arg = Symbol.symbol option * typ
val strArgs: arg list -> string

type world = Symbol.symbol * term list
val eqWorld:   world -> world -> bool
val fvWorld:   world -> SetX.set
val fvWorlds:  world list -> SetX.set
val strWorld': bool -> world -> string
val strWorld:  world -> string

type atomic = Symbol.symbol * term list
val strAtomic': bool -> world -> string
val strAtomic:  world -> string
val uscoresInAtomic: atomic -> bool

datatype pattern = 
   Atomic of atomic
 | Exists of Symbol.symbol * pattern
 | Conj of pattern * pattern
 | One

datatype binrel = Eq | Neq | Gt | Geq 
val strBinrel: binrel -> string 

datatype prem = 
   Normal of pattern
 | Negated of pattern
 | Count of pattern * term
 | Binrel of binrel * term * term
val strPrem: prem -> string

type dependency = world * world list
type rule = prem list * atomic list

datatype decl = 
   DeclConst of Symbol.symbol * arg list * Symbol.symbol
 | DeclDatabase of Symbol.symbol * atomic list * world
 | DeclDepends of dependency
 | DeclRelation of Symbol.symbol * arg list * world
 | DeclRule of rule
 | DeclType of Symbol.symbol 
 | DeclWorld of Symbol.symbol * arg list

end
