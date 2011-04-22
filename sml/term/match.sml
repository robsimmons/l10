structure Match = 
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
