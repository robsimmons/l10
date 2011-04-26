(* Mediating between patterns (Ast terms), ground terms, and substitutions. *)
(* Robert J. Simmons *)

structure Match:> sig

   (* Map a substitution over an abstract syntax tree pattern *)
   val pullTerm: Subst.subst -> Ast.term -> Term.term
   val pullAtomic: Subst.subst -> Ast.atomic -> Term.atomic

   (* Match a pattern against a concrete term *)
   val matchTerm: Subst.subst -> Ast.term -> Term.term 
      -> Subst.subst option
   val matchTerms: Subst.subst -> Ast.term list -> Term.term list
      -> Subst.subst option
   val matchWorld: Subst.subst -> Ast.world -> Term.world 
      -> Subst.subst option
   val matchAtomic: Subst.subst -> Ast.atomic -> Term.atomic 
      -> Subst.subst option

end = 
struct

fun pullTerm subst term = 
   case term of 
      Ast.Const c => Term.Structured' (c, [])
    | Ast.Structured (f, terms) => 
      Term.Structured' (f, map (pullTerm subst) terms)
    | Ast.NatConst i => Term.NatConst' i
    | Ast.StrConst s => Term.StrConst' s
    | Ast.Var NONE => raise Fail "Invariant"
    | Ast.Var (SOME x) => valOf (Subst.find subst x)

fun pullAtomic subst (a, terms) = (a, map (pullTerm subst) terms)

fun matchTerm subst term term' = 
   case (term, Term.prj term') of
      (Ast.Const c, Term.Structured (c', [])) => 
      if c <> c' then NONE else SOME subst
    | (Ast.Const c, Term.Structured _) => NONE
    | (Ast.Structured (f, terms), Term.Structured (f', terms')) =>
      if f <> f' then NONE
      else (* assert: length terms = length terms' *) 
        matchTerms subst terms terms'
    | (Ast.NatConst i, Term.NatConst i') =>
      if i <> i' then NONE else SOME subst
    | (Ast.StrConst s, Term.StrConst s') =>
      if s <> s' then NONE else SOME subst
    | (Ast.Var NONE, _) => SOME subst
    | (Ast.Var (SOME x), _) => 
      (case Subst.find subst x of
          NONE => SOME (Subst.extend subst (x, term'))
        | SOME term => if not (Term.eq (term, term')) then NONE else SOME subst)
    | _ => raise Fail "Invariant"

and matchTerms subst terms terms' =
   case (terms, terms') of
      ([], []) => SOME subst
    | (term :: terms, term' :: terms') => 
      (case matchTerm subst term term' of
          NONE => NONE
        | SOME subst => matchTerms subst terms terms')
    | _ => raise Fail "Invariant"

fun matchWorld subst (w: Symbol.symbol, terms) (w', terms') =
   if w <> w' then NONE
   else matchTerms subst terms terms'

val matchAtomic = matchWorld

end
