(* Tinybot grounding substitutions 
 * Robert J. Simmons 
 * Essentially just maps from strings to terms  *)

structure Subst :> sig

   type subst

   (* Empty substitution *)
   val empty: subst

   (* Returns true iff the substitution has a given member *)
   val member: subst -> Symbol.symbol -> bool

   (* Extends a substitution with a given binding *)
   val extend: subst -> Symbol.symbol * Term.term -> subst

   (* Find a term in a substitution *)
   val find: subst -> Symbol.symbol -> Term.term option

   (* Apply a grounding substitution to a term with free variables. *)
   val apply: subst -> Ast.term -> Term.term
   val applyWorld: subst -> Ast.world -> Term.world
   val applyAtomic: subst -> Ast.atomic -> Term.atomic

   (* val compare: subst * subst -> order *)
   val to_string: subst -> string

   (* push subst x **removes** any existing term bound to x from the 
    * substitution, and pop subst restores that term binding to what it was
    * before. This is used to handle existential quantification.
    * If you pop more times than you push, exception Pop is raised. *)
   exception Pop
   val push: Symbol.symbol -> subst -> subst
   val pop: subst -> subst

end = 
struct

open Ast

type subst = (Symbol.symbol * Term.term option) list * Term.term MapX.map

fun to_string (_, subst) = 
   let 
      fun elem_to_str (x, tm) = (Symbol.name x ^ "=" ^ Term.strTerm tm)
      val elems = map elem_to_str (MapX.listItemsi subst)
   in
      "{" ^ String.concatWith ", " elems ^ "}"
   end

val empty = ([], MapX.empty)
fun member (_, active) x = MapX.inDomain(active, x)
fun extend (stack, active) (x, tm) = (stack, MapX.insert(active, x, tm))
fun find (_, active) x = MapX.find(active, x)

fun apply (subst as (stack, active)) term = 
   case term of 
      Var (SOME x) =>
      (MapX.lookup(active, x)
       handle exn => 
         (print ("Could not find " ^ Symbol.name x 
                 ^ " in " ^ to_string subst ^ "\n")
          ; raise exn))
    | Var NONE => raise Fail "Can't apply to underscores"
    | Const x => Term.Structured' (x, [])
    | Structured (x, tms) => Term.Structured' (x, map (apply subst) tms)
    | NatConst n => Term.NatConst' n
    | StrConst s => Term.StrConst' s

fun applyWorld subst (w, terms) = (w, map (apply subst) terms)
val applyAtomic = applyWorld

(* fun compare ( = MapX.collate Term.compare *)

exception Pop
fun push x (stack, active) = 
   if MapX.inDomain (active, x)
   then let val (active', term) = MapX.remove (active, x)
        in ((x, SOME term) :: stack, active') end
   else ((x, NONE) :: stack, active)

fun pop ([], active) = raise Pop
  | pop ((x, NONE) :: stack, active) = 
    if MapX.inDomain (active, x) 
    then (stack, #1 (MapX.remove (active, x)))
    else (stack, active)
  | pop ((x, SOME term) :: stack, active) = 
    (stack, MapX.insert (active, x, term))

end

