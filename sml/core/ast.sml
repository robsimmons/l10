structure Ast = 
struct

datatype term = 
   Const of Symbol.symbol
 | NatConst of IntInf.int
 | StrConst of string
 | Structured of Symbol.symbol * term list
 | Var of Symbol.symbol option

(* Total substitution *)
fun subTerm (map, term) =
   case term of 
      Const c => SOME (Const c)
    | NatConst n => SOME (NatConst n)
    | StrConst s => SOME (StrConst s)
    | Structured (f, terms) =>  
      (case subTerms (map, terms) of
          NONE => NONE
        | SOME terms => SOME (Structured (f, terms)))
    | Var NONE => NONE
    | Var (SOME x) =>
      (case MapX.lookup (map, x) of
          NONE => NONE
        | SOME term => SOME term)
and subTerms (map, []) = SOME []
  | subTerms (map, term :: terms) = 
    case (subTerm (map, term), subTerms (map, terms)) of 
       (SOME term, SOME terms) => SOME (term :: terms) 
     | _ => NONE

type typ = Symbol.symbol
type arg = Symbol.symbol option * typ
type atomic = Symbol.symbol * term list
type world = Symbol.symbol * term list

datatype pattern = 
   Atomic of atomic
 | Exists of Symbol.symbol * pattern
 | Conj of pattern * pattern
 | One

datatype binrel = Eq | Neq | Gt | Lt | Geq | Leq 

datatype prem = 
   Normal of pattern
 | Negated of pattern
 | Count of pattern * term
 | Binrel of binrel * term * term

datatype decl = 
   DeclConst of Symbol.symbol * arg list * Symbol.symbol
 | DeclDatabase of Symbol.symbol * atomic list * world
 | DeclDepends of world * world list
 | DeclRelation of Symbol.symbol * arg list * world
 | DeclRule of prem list * atomic list
 | DeclType of Symbol.symbol 
 | DeclWorld of Symbol.symbol * arg list

fun lp parens = if parens then "(" else ""
fun rp parens = if parens then ")" else ""

fun strBinrel binrel = 
   case binrel of 
      Eq => "==" | Neq => "!=" 
    | Gt => ">" | Lt => "<" | Geq => ">=" | Leq => "<="

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
val strTerm = strTerm' false 

fun strWorld' parens (w, []) = Symbol.name w
  | strWorld' parens (w, terms) =
    lp parens
    ^ Symbol.name w 
    ^ String.concat (map (fn term => " " ^ (strTerm' true) term) terms)
    ^ rp parens
val strWorld = strWorld' false

fun strAtomic' parens (a, []) = Symbol.name a
  | strAtomic' parens (a, terms) =
    lp parens
    ^ Symbol.name a
    ^ String.concat (map (fn term => " " ^ (strTerm' true) term) terms)
    ^ rp parens
val strAtomic = strAtomic' false

fun strPattern pat = 
   case pat of
      Atomic atm => strAtomic' false atm
    | Exists (x, pat0) => "(Ex " ^ Symbol.name x ^ ". " ^ strPattern pat0 ^ ")"
    | Conj (pat1, pat2) => strPattern pat1 ^ ", " ^ strPattern pat2
    | One => "<<one>>"

fun strPrem prem = 
   case prem of 
      Normal pattern => strPattern pattern
    | Negated pattern => "not (" ^ strPattern pattern ^ ")"
    | Count pattern => "countxxxx"
    | Binrel (br, term1, term2) => 
      strTerm term1 ^ " " ^ strBinrel br ^ " " ^ strTerm term2

val strTyps = 
   String.concat o map (fn typ => Symbol.name typ ^ " -> ")

val strArgs = 
   String.concat 
   o map (fn (NONE, typ) => Symbol.name typ ^ " -> "
           | (SOME x, typ) => 
             "{" ^ Symbol.name x ^ ": " ^ Symbol.name typ ^ "} ")

fun termFV t =
   case t of 
      Var (SOME x) => SetX.singleton x
    | Structured (_, tms) => termsFV tms
    | _ => SetX.empty

and termsFV ts = 
   List.foldr (fn (t, set) => SetX.union (termFV t, set)) SetX.empty ts

end
