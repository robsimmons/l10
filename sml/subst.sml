(* Tinybot grounding substitutions 
 * Robert J. Simmons 
 * Essentially just maps from strings to terms  *)

structure Subst :> sig

   type subst

   (* Empty substitution *)
   val empty : subst

   (* Returns true iff the substitution has a given member *)
   val member : subst -> Symbol.symbol -> bool

   (* Extends a substitution with a given binding *)
   val extend : subst -> Symbol.symbol * Term.term -> subst

   (* Find a term in a substitution *)
   val find : subst -> Symbol.symbol -> Term.term option

   (* Apply a grounding substitution to a term with free variables. *)
   val apply : subst -> Ast.term -> Term.term

   (* Merges two substitutions (must be identical on the intersection!) *)
   val merge : subst * subst -> subst

   (* Takes only elements of the substitution that appear in a given set.
    * filter ({"X" ↦ a, "Y" ↦ b, "Z" ↦ c},{"X","W","Q"}) = {"X" ↦ a}   *)
   val filter : SetX.set -> subst -> subst 
  
   val compare : subst * subst -> order
   val to_string : subst -> string

end = 
struct

open Ast

type subst = Term.term MapX.map

fun to_string subst = 
   let 
      fun elem_to_str (x, tm) = (Symbol.name x ^ "=" ^ Term.to_string tm)
      val elems = map elem_to_str (MapX.listItemsi subst)
   in
      "{" ^ String.concatWith ", " elems ^ "}"
   end

val empty = MapX.empty
val member = fn subst => fn x => MapX.inDomain(subst, x)
val extend = fn subst => fn (x, tm) => MapX.insert(subst, x, tm)
val find = fn subst => fn x => MapX.find(subst, x)
val merge =
   MapX.unionWith 
       (fn (tm1, tm2) => 
           if Term.eq(tm1, tm2) then tm1 
           else raise Fail "Invariant")

fun apply subst term = 
   case term of 
      Var (SOME x) =>
      (MapX.lookup(subst, x)
       handle exn => 
         (print ("Could not find " ^ Symbol.name x 
                 ^ " in " ^ to_string subst ^ "\n")
          ; raise exn))
    | Var NONE => raise Fail "Can't apply to underscores"
    | Const x => Term.Structured' (x, [])
    | Structured (x, tms) => Term.Structured' (x, map (apply subst) tms)
    | NatConst n => Term.NatConst' n
    | StrConst s => Term.StrConst' s

fun filter set = MapX.filteri (fn (x,tm) => SetX.member(set,x)) 

val compare = MapX.collate Term.compare

end

