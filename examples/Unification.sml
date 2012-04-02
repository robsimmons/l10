CM.make "$SMACKAGE/cmlib/v1/cmlib.cm";
structure SetX = SymbolRedBlackSet;
use "Unification.l10.sml";


(* Printing terms *)
fun toStr (Term.V x) = Symbol.toValue x
  | toStr (Term.F (c, Terms.Nil)) = Symbol.toValue c
  | toStr (Term.F (f, ts)) = Symbol.toValue f^"("^toStrs ts

and toStrs Terms.Nil = raise Fail "Cannot print"
  | toStrs (Terms.Cons (t, Terms.Nil)) = toStr t^")"
  | toStrs (Terms.Cons (t, ts)) = toStr t^", "^toStrs ts


(* Parsing terms *)
datatype stack = OPEN | CLOSE | VAR of Symbol.symbol | CONST of Symbol.symbol
 | TERM of Term.t  

fun shift stack [] = 
     (case reduce stack of
         [ TERM term ] => term
       | _ => raise Fail "Could not parse (end of file)")
  | shift stack (#" " :: toks) = shift stack toks
  | shift stack (#"(" :: toks) = shift (OPEN :: stack) toks
  | shift stack (#"," :: toks) = shift (reduce stack) toks
  | shift stack (#")" :: toks) = shift (CLOSE :: reduce stack) toks
  | shift stack (a :: toks) = 
       if Char.isUpper a 
       then shift (VAR (Symbol.fromValue (str a)) :: stack) toks
       else shift (CONST (Symbol.fromValue (str a)) :: stack) toks

and reduce' (OPEN :: CONST f :: stack) ts = TERM (Term.F (f, ts)) :: stack
  | reduce' (TERM t :: stack) ts = reduce' stack (Terms.Cons (t, ts))
  | reduce' _ _ = raise Fail "Could not parse (reduce')"

and reduce (CONST f :: stack) = TERM (Term.F (f, Terms.Nil)) :: stack
  | reduce (VAR x :: stack) = TERM (Term.V x) :: stack
  | reduce (CLOSE :: stack) = reduce' stack Terms.Nil
  | reduce _ = raise Fail "Could not parse (reduce)"


(* Unification of terms *)
fun unify input = 
let
   (* Parse an equation from a string t = s *)
   fun getEq str = 
      case String.fields (fn x => x = #"=") str of
         [ t, s ] => (shift [] (explode t), shift [] (explode s))
       | _ => raise Fail "Wrong number of things being equated"

   (* Print out the unification instance for a given variable *)
   fun printunif db (x, seen) = 
      (* Variable has already been seen *)
      if SetX.member seen x then seen 

      (* Variable hasn't been seen yet *)
      (* Print the other vars in this equivalence class; add to seen set *)
      else let 
         fun folder (y, seen') = 
            if Symbol.eq (x, y) 
            then seen'
            else (print (Symbol.toValue y^"="); SetX.insert seen' y)
         val () = print "  {"
         val seen = Unification.Query.equiv folder (SetX.insert seen x) db x
      in
       ( print (Symbol.toValue x^"}")
       ; case Unification.Query.binding (fn (x,_) => SOME x) NONE db x of
            NONE => print "\n"
          | SOME t => print (" <- "^toStr t^"\n")
       ; seen)
      end

   (* Seed the database with all the potentially unifiable terms. *)
   val unif_db = 
      foldr Unification.Assert.unify Unification.empty
         (map getEq (String.fields (fn x => x = #";") input))

in 
   (* Test the database for success or failure *)
   case Unification.Query.failuresList unif_db of 
      [] => 
       ( print "Unification success!\n"
       ; ignore (Unification.Query.vars (printunif unif_db) SetX.empty unif_db))
    | errmsg :: _ => print ("Unification failure: "^ errmsg ^"\n")
end;


(* A couple of tests *)

(* Success *)
unify "f(g(h(X),X),X)=f(g(Y,Z),Z) ; Z = a";

(* Constant clash *)
unify "f(a, X) = f(X, h(Y))";

(* Occurs check *)
unify "Y = X; h(X)=Z ; X = Z;Z = W";

(* Examples from Wikipedia, and Wikipedia's unifying substitutions *)
unify "a = a";              (* {} *)
unify "a = b";              (* fail *)
unify "X = X";              (* {} *)
unify "a = X";              (* {X |-> a} *)
unify "X = Y";              (* {X |-> Y} *)
unify "f(a,X) = f(a,b)";    (* fail *)
unify "f(X) = f(Y)";        (* {X |-> Y} *)
unify "f(X) = g(Y)";        (* fail *)
unify "f(X) = f(Y,Z)";      (* fail, also type error *) 
unify "f(g(X)) = f(Y)";     (* {Y |-> g(X)} *)
unify "f(g(X),X) = f(Y,a)"; (* {X |-> a, Y |-> g(a)} *)
unify "X = f(X)";           (* fail *)
unify "X = Y; Y = a";       (* {X |-> a, Y |-> a} *)
unify "a = Y; X = Y";       (* {X |-> a, Y |-> a} *)
unify "X = a; b = X";       (* fail *)

