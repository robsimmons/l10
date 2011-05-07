(* Abstract syntax tree for L10 *)
(* Robert J. Simmons *)

signature AST = 
sig

type typ = Symbol.symbol 
val strTyps: typ list -> string

datatype 'a term' = 
   Const of Symbol.symbol (* TODO: Rename this "SymConst" - fp 5/6/11 *)
 | NatConst of IntInf.int
 | StrConst of string
 | Structured of Symbol.symbol * 'a term' list
 | Var of 'a

val strTerm': ('a -> string) -> 'a term' -> string

type term = Symbol.symbol option term'
type subst = term MapX.map
val eqTerm:   term * term -> bool
val fvTerm:   term -> SetX.set
val fvTerms:  term list -> SetX.set
val strTerm:  term -> string
val subTerm:  subst * term -> term option             (* total substitution  *)
val subTerms: subst * term list -> (term list) option (* total substitution  *)
val subTerm': (term * Symbol.symbol) -> term -> term  (* substitution [M/x]N *)
val uscoresInTerm: term -> bool
val uscoresInTerms: term list -> bool

type shapeTerm = unit term'
type modedTerm = (bool * typ) term'
val strModedTerm: modedTerm -> string

(* (NONE, t) is "t ->", (SOME x, t) is {x:t} *)
type arg = Symbol.symbol option * typ 
val strArgs: arg list -> string

type world = Symbol.symbol * term list
val eqWorld:   world -> world -> bool
val fvWorld:   world -> SetX.set
val fvWorlds:  world list -> SetX.set
val strWorld': bool -> world -> string
val strWorld:  world -> string
val uscoresInWorld: world -> bool

type atomic = Symbol.symbol * term list
val fvAtomic: atomic -> SetX.set
val fvAtomics: atomic list -> SetX.set
val strAtomic': bool -> world -> string
val strAtomic:  world -> string
val uscoresInAtomic: atomic -> bool

datatype pattern = 
   Atomic of atomic
 | Exists of Symbol.symbol * pattern
 | Conj of pattern * pattern (* Not implemented *)
 | One (* Not implemented *)
val fvPattern: pattern -> SetX.set
val fvPatterns: pattern list -> SetX.set
val strPattern: pattern -> string

datatype binrel = Eq | Neq | Gt | Geq 
val strBinrel: binrel -> string 

datatype prem = 
   Normal of pattern
 | Negated of pattern
 | Count of pattern * term (* Not implemented *)
 | Binrel of binrel * term * term
val strPrem: prem -> string

type dependency = world * world list  (* W <- W1, ..., Wn *)
type rule = prem list * atomic list   (* P1, ..., Pn -> A1, ... An *)
val fvRule: rule -> SetX.set

datatype decl = 
   DeclConst of Symbol.symbol * arg list * Symbol.symbol
 | DeclDatabase of Symbol.symbol * atomic list * world
 | DeclDepends of dependency
 | DeclRelation of Symbol.symbol * arg list * world
 | DeclRule of rule
 | DeclType of Symbol.symbol 
 | DeclWorld of Symbol.symbol * arg list

end
