structure Mode = 
struct

structure A = Ast
open Symbol

fun eqTerm (term1, term2) = 
   case (term1, term2) of
      (A.Const c1, A.Const c2) => c1 = c2
    | (A.NatConst n1, A.NatConst n2) => n1 = n2
    | (A.StrConst s1, A.StrConst s2) => s1 = s2
    | (A.Structured (f1, terms1), A.Structured (f2, terms2)) => 
      f1 = f2 andalso List.all eqTerm (ListPair.zip (terms1, terms2))
    | (Var v1, Var v2) => v1 = v2

fun eqWorld ((w1, terms1), (w2, terms2)) = 
   w1 = w2 andalso List.all eqTerm (ListPair.zip (terms1, terms2))
  
(* pullWorld uses RelTab; takes an atomic proposition and gets a world *)
fun pullWorld (a, terms) = 
   case RelTab.lookup a of
      NONE => raise Fail "Invariant"
    | SOME (args, (w, worldterms)) =>
      let 
         fun folder ((arg, _), term, map) =
            case arg of 
               NONE => map
             | SOME x => MapX.insert (map, x, term)
         val map = ListPair.foldl folder MapX.empty (args, terms)
      in
         (w, valOf (A.subTerm (map, worldterms)))
      end

(* pullConcs checks that all conclusions are at the same world
 * and returns that world. *)
fun pullConcs [] = raise Fail "Invariant"
  | pullConcs [ conc ] = pullWorld conc
  | pullConcs (conc :: concs) = 
    let val world = pullConcs concs in
       if eqWorld (pullWorld conc, world) then world
       else raise Fail ("Conclusion " ^ A.strAtomic conc ^ " at world " 
                        ^ A.strWorld (pullWorld conc) 
                        ^ ", but earlier conclusions were at world " 
                        ^ A.strWorld world)
    end

(* Input: a set of symbols, a term (which may include Var NONE) *)
(* Output: *)
fun fvTerm (set, term) =
   case term of 
      Var NONE => 
      let val s = unique set "_" 
      in (SetX.insert (set, s), Var (SOME s)) end
    | Var (SOME s) => (SetX.insert (set, s), 


fun pullDependency (prems, concs) = 
   case 

end
