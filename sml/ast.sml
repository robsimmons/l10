(* Abstract syntax tree for L10 *)
(* Robert J. Simmons *)

structure Ast :> AST = 
struct

datatype 'a term' = 
   SymConst of Symbol.symbol
 | NatConst of IntInf.int
 | StrConst of string
 | Structured of Symbol.symbol * 'a term' list
 | Var of 'a

type term = Symbol.symbol option term'
type shapeTerm = unit term'
type modedTerm = (bool * Symbol.symbol) term'

(* Partial substitution *)
fun subTerm' (term', x) term = 
   case term of
      SymConst c => SymConst c
    | NatConst n => NatConst n
    | StrConst s => StrConst s
    | Structured (f, terms) => 
      Structured (f, map (subTerm' (term', x)) terms)
    | Var NONE => Var NONE
    | Var (SOME y) => if Symbol.eq (x, y) then term' else Var (SOME y)

(* Total substitution *)
fun subTerm (map, term) =
   case term of 
      SymConst c => SOME (SymConst c)
    | NatConst n => SOME (NatConst n)
    | StrConst s => SOME (StrConst s)
    | Structured (f, terms) =>  
      (case subTerms (map, terms) of
          NONE => NONE
        | SOME terms => SOME (Structured (f, terms)))
    | Var NONE => NONE
    | Var (SOME x) => DictX.find map x
and subTerms (map, []) = SOME []
  | subTerms (map, term :: terms) = 
    case (subTerm (map, term), subTerms (map, terms)) of 
       (SOME term, SOME terms) => SOME (term :: terms) 
     | _ => NONE

fun eqTerm (term1, term2) = 
   case (term1, term2) of
      (SymConst c1, SymConst c2) => Symbol.eq (c1, c2)
    | (NatConst n1, NatConst n2) => n1 = n2
    | (StrConst s1, StrConst s2) => s1 = s2
    | (Structured (f1, terms1), Structured (f2, terms2)) => 
      Symbol.eq(f1, f2) andalso List.all eqTerm (ListPair.zip (terms1, terms2))
    | (Var NONE, Var NONE) => true
    | (Var (SOME v1), Var (SOME v2)) => Symbol.eq (v1, v2)
    | (_, _) => false

type subst = term DictX.dict
type typ = Symbol.symbol
type arg = Symbol.symbol option * typ
type atomic = Symbol.symbol * term list
type world = Symbol.symbol * term list
type dependency = world * world list

fun eqWorld (w1, terms1) (w2, terms2) = 
   Symbol.eq (w1, w2) andalso List.all eqTerm (ListPair.zip (terms1, terms2))

datatype pattern = 
   Atomic of atomic
 | Exists of Symbol.symbol * pattern
 | Conj of pattern * pattern
 | One

datatype binrel = Eq | Neq | Gt | Geq

datatype prem = 
   Normal of pattern
 | Negated of pattern
 | Count of pattern * term
 | Binrel of binrel * term * term

type rule = prem list * atomic list

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
    | Gt => ">" | Geq => ">=" 

fun strTerm' str term = 
   case term of 
      SymConst c => Symbol.toValue c
    | NatConst i => IntInf.toString i
    | StrConst s => "\"" ^ s ^ "\""
    | Structured (f, terms) => 
      if Symbol.eq (f, Symbol.fromValue "_plus") andalso length terms = 2
      then ("(" ^ strTerm' str (hd terms) 
            ^ " + " ^ strTerm' str (hd (tl terms)) ^ ")")
      else ("(" 
            ^ Symbol.toValue f 
            ^ String.concat (map (fn term => " " ^ strTerm' str term) terms)
            ^ ")")
    | Var x => str x
val strTerm = strTerm' (fn NONE => "_" | SOME x => Symbol.toValue x)
val strModedTerm = strTerm' (fn (true, _:Symbol.symbol) => "++" | (false, _) => "--")

fun strWorld' parens (w, []) = Symbol.toValue w
  | strWorld' parens (w, terms) =
    lp parens
    ^ Symbol.toValue w 
    ^ String.concat (map (fn term => " " ^ strTerm term) terms)
    ^ rp parens
val strWorld = strWorld' false

fun strAtomic' parens (a, []) = Symbol.toValue a
  | strAtomic' parens (a, terms) =
    lp parens
    ^ Symbol.toValue a
    ^ String.concat (map (fn term => " " ^ strTerm term) terms)
    ^ rp parens
val strAtomic = strAtomic' false

fun strPattern pat = 
   case pat of
      Atomic atm => strAtomic' false atm
    | Exists (x, pat0) => "(Ex " ^ Symbol.toValue x ^ ". " ^ strPattern pat0 ^ ")"
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
   String.concat o map (fn typ => Symbol.toValue typ ^ " -> ")

val strArgs = 
   String.concat 
   o map (fn (NONE, typ) => Symbol.toValue typ ^ " -> "
           | (SOME x, typ) => 
             "{" ^ Symbol.toValue x ^ ": " ^ Symbol.toValue typ ^ "} ")

fun fvTerm term =
   case term of 
      Var (SOME x) => SetX.singleton x
    | Structured (_, terms) => fvTerms terms
    | _ => SetX.empty

and fvTerms terms = 
   List.foldr (fn (t, set) => SetX.union (fvTerm t) set) SetX.empty terms

fun fvWorld (a, terms) = fvTerms terms

fun fvWorlds worlds = 
   List.foldr (fn (t, set) => SetX.union (fvWorld t) set) SetX.empty worlds

fun uscoresInTerm term = 
   case term of 
      Var NONE => true
    | Structured (_, terms) => uscoresInTerms terms
    | _ => false

and uscoresInTerms terms = 
   List.foldr (fn (term, b) => b orelse uscoresInTerm term) false terms

fun uscoresInAtomic (_, terms) = uscoresInTerms terms
fun uscoresInWorld (_, terms) = uscoresInTerms terms

val fvAtomic = fvWorld
val fvAtomics = fvWorlds

fun fvPattern pat = 
   case pat of 
      Atomic atomic => fvAtomic atomic
    | Exists (x, pat) => 
      let val fv = fvPattern pat 
      in if SetX.member fv x then SetX.remove fv x else fv end
    | Conj (pat1, pat2) => SetX.union (fvPattern pat1) (fvPattern pat2)
    | One => SetX.empty

fun fvPatterns pats = 
   foldl (fn (x, y) => SetX.union x y) SetX.empty (map fvPattern pats)

fun fvPrem prem = 
   case prem of 
      Normal pat => fvPattern pat
    | Negated pat => fvPattern pat
    | Count _ => raise Fail "Unimplemented"
    | Binrel (_, term1, term2) => SetX.union (fvTerm term1) (fvTerm term2)

fun fvRule (prems, concs) =
   SetX.union 
      (List.foldl (fn (x, y) => SetX.union x y) SetX.empty (map fvPrem prems))
      (List.foldl (fn (x, y) => SetX.union x y) SetX.empty (map fvAtomic concs))

end
