(* Internal term representation
 * Robert J. Simmons
 * 
 * NOTE: This does not satisfy the McAllester complexity result! 
 * If we have recursive terms (like natural numbers) that can be arbitrarily
 * large, then equality is not a constant-time operation as the McAllester
 * result requires. The signature is written with inj/prj so that the 
 * implementation could be swapped out for a hash-consing implementation
 * that does satisfy the complexity result. *)

structure Term :> sig

   type term 
   datatype term_rep = 
      Structured of Symbol.symbol * term list
    | StrConst of string
    | NatConst of IntInf.int 
   val inj:         term_rep -> term
   val prj:         term -> term_rep
   val Structured': Symbol.symbol * term list -> term
   val StrConst':   string -> term
   val NatConst':   IntInf.int -> term
   val eq:          term * term -> bool
   val eqs:         term list * term list -> bool
   val compare:     term * term -> order
   val strTerm':    bool -> term -> string
   val strTerm:     term -> string

   type world = Symbol.symbol * term list
   val eqWorld:     world * world -> bool
   val strWorld:    world -> string

   type atomic = Symbol.symbol * term list
   val eqAtomic:    atomic * atomic -> bool
   val strAtomic:   atomic -> string

end = 
struct
 
datatype term_rep = 
   Structured of Symbol.symbol * term list
 | StrConst of string
 | NatConst of IntInf.int 
and term = R of term_rep

type world = Symbol.symbol * term list

val plussymb = Symbol.symbol "_plus"
fun inj (x as Structured (f, [ R (NatConst i), R (NatConst j) ])) =
    if f = plussymb then R (NatConst (i + j)) else R x
  | inj x = R x

val prj = fn (R x) => x
val Structured' = inj o Structured
val StrConst' = inj o StrConst
val NatConst' = inj o NatConst

fun eq (tm1, tm2) = 
   case (prj tm1, prj tm2) of 
      (Structured (x, tms1), Structured (y, tms2)) => 
      if x = y then eqs (tms1, tms2) else false
    | (StrConst s1, StrConst s2) => s1 = s2
    | (NatConst n1, NatConst n2) => n1 = n2
    | _ => false (* type error *)

and eqs (tms1, tms2) = 
   case (tms1, tms2) of
      ([], []) => true
    | (tm1 :: tms1, tm2 :: tms2) => 
      if eq(tm1,tm2) then eqs(tms1, tms2) else false
    | _ => false (* type error? *)

fun compare (tm1, tm2) = 
   case (prj tm1, prj tm2) of
      (Structured (x, tms1), Structured (y, tms2)) =>
      (case Symbol.compare (x, y) of 
          EQUAL => compares (tms1, tms2) 
        | ord => ord)
    | (StrConst s1, StrConst s2) => String.compare (s1, s2)
    | (NatConst n1, NatConst n2) => IntInf.compare (n1, n2)
    (* type errors? *)
    | (Structured _, _) => LESS
    | (_, Structured _) => GREATER
    | (StrConst _, _) => LESS
    | (_, StrConst _) => GREATER

and compares (tms1, tms2) = 
   case (tms1, tms2) of
      ([], []) => EQUAL
    | (tm1 :: tms1, tm2 :: tms2) =>
      (case compare (tm1, tm2) of EQUAL => compares(tms1,tms2) | ord => ord)
    | ([], _) => LESS    (* type error? *)
    | (_, []) => GREATER (* type error? *)

fun to_string term = 
   case prj term of 
      Structured (x, []) => Symbol.name x
    | Structured (x, tms) => 
      Symbol.name x ^ "(" ^ String.concatWith ", " (map to_string tms) ^ ")"
    | StrConst s => "\"" ^ s ^ "\""
    | NatConst n => IntInf.toString n

fun lp parens = if parens then "(" else ""
fun rp parens = if parens then ")" else ""

fun strTerm' parens term = 
   case prj term of 
      Structured (x, []) => Symbol.name x
    | Structured (x, terms) => 
      lp parens ^ Symbol.name x 
      ^ String.concat (map (fn term => " " ^ strTerm' true term) terms) 
      ^ rp parens
    | StrConst s => "\"" ^ s ^ "\""
    | NatConst n => IntInf.toString n

val strTerm = strTerm' false
 
fun eqWorld ((w1, terms1) : world, (w2, terms2)) = 
   w1 = w2 andalso ListPair.all eq (terms1, terms2)

fun strWorld (w, terms) = 
  case terms of 
     [] => Symbol.name w
   | _ => 
     Symbol.name w
     ^ String.concat (map (fn term => " " ^ strTerm' true term) terms)

type atomic = world
val eqAtomic = eqWorld
val strAtomic = strWorld

end
