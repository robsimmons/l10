(* I would do this differently now. As it is, "root" takes a conslist and
 * SymConst does not. I'd rather have SymConst not be parsed from the syntax,
 * but to be introduced in typechecking for things that are, it turns out,
 * symbolic constants (contstants whose classifer has kind "extensible" and
 * not kind "type". *)

structure Term = 
struct
   datatype t = 
      SymConst of Symbol.symbol 
    | NatConst of IntInf.int
    | StrConst of string
    | Root of Symbol.symbol * t list
    | Var of Symbol.symbol option * Type.t option
    | Mode of Mode.t * Type.t option
    | Path of int list * Type.t 
(*[
   datasort term = 
      SymConst of Symbol.symbol 
    | NatConst of IntInf.int
    | StrConst of string
    | Var of Symbol.symbol option * Type.t none
    | Root of Symbol.symbol * term conslist

   datasort term_t = 
      SymConst of Symbol.symbol 
    | NatConst of IntInf.int
    | StrConst of string
    | Var of Symbol.symbol option * Type.t some
    | Root of Symbol.symbol * term_t conslist

   datasort ground = 
      SymConst of Symbol.symbol 
    | NatConst of IntInf.int
    | StrConst of string
    | Root of Symbol.symbol * ground conslist
  
   datasort shape = 
      SymConst of Symbol.symbol 
    | NatConst of IntInf.int
    | StrConst of string
    | Path of int list * Type.t
    | Root of Symbol.symbol * shape conslist

   datasort moded = 
      SymConst of Symbol.symbol 
    | NatConst of IntInf.int
    | StrConst of string
    | Mode of Mode.t * Type.t none
    | Root of Symbol.symbol * moded conslist

   datasort moded_t = 
      SymConst of Symbol.symbol 
    | NatConst of IntInf.int
    | StrConst of string
    | Mode of Mode.t * Type.t some
    | Root of Symbol.symbol * moded_t conslist

   datasort path = Path of int list * Type.t
   datasort sym = SymConst of Symbol.symbol
   datasort nat = NatConst of IntInf.int
   datasort str = StrConst of string
   datasort pat = 
      SymConst of Symbol.symbol
    | NatConst of IntInf.int
    | StrConst of string
    | Root of Symbol.symbol * path conslist
]*)

   fun eq (term1, term2) = 
      case (term1, term2) of
         (SymConst c1, SymConst c2) => Symbol.eq (c1, c2)
       | (NatConst n1, NatConst n2) => n1 = n2
       | (StrConst s1, StrConst s2) => s1 = s2
       | (Var (NONE, _), (Var (NONE, _))) => true
       | (Var (SOME v1, _), Var (SOME v2, _)) => Symbol.eq (v1, v2)
       | (Mode (m1, _), Mode (m2, _)) => m1 = m2
       | (Root (f1, terms1), Root (f2, terms2)) => 
            Symbol.eq(f1, f2)
            andalso List.all eq (ListPair.zip (terms1, terms2))
       | (_, _) => false

   fun fv term =
      case term of 
         Var (SOME x, _) => SetX.singleton x
       | Root (_, terms) => fvs terms
       | _ => SetX.empty

   and fvs terms = 
      List.foldr (fn (t, set) => SetX.union (fv t) set) SetX.empty terms

   fun toString term = 
      case term of 
         SymConst c => Symbol.toValue c
       | NatConst i => IntInf.toString i
       | StrConst s => "\"" ^ s ^ "\""
       | Var (NONE, _) => "_"
       | Var (SOME x, _) => Symbol.toValue x
       | Mode (m, _) => Mode.toString m
       | Root (f, terms) => 
         if Symbol.eq (f, Symbol.fromValue "_plus") andalso length terms = 2
         then ( "(" ^ toString (hd terms) 
              ^ " + " ^ toString (hd (tl terms)) ^ ")")
         else ( "(" 
              ^ Symbol.toValue f 
              ^ String.concat (map (fn term => " " ^ toString term) terms)
              ^ ")")
       | Path (path, _) => "x_" ^ String.concatWith "_" (map Int.toString path)

   (*[ sortdef subst = term_t DictX.dict ]*)
   (*[ sortdef pathsubst = path DictX.dict ]*)
   (*[ sortdef eqssubst = (Type.t * (int list * shape) list) DictX.dict ]*)

   (* Total substitution *)
   (*[ val subst: subst * term_t -> term_t option 
                & pathsubst * term_t -> shape option ]*)
   (*[ val substs: subst * term_t list -> term_t list option
                 & subst * term_t conslist -> term_t conslist option
                 & pathsubst * term_t list -> shape list option
                 & pathsubst * term_t conslist -> shape conslist option ]*)
   fun subst (map, term) =
      case term of 
         SymConst c => SOME (SymConst c)
       | NatConst n => SOME (NatConst n)
       | StrConst s => SOME (StrConst s)
       | Var (NONE, _) => NONE
       | Var (SOME x, _) => DictX.find map x
       | Root (f, terms) =>  
           (case substs (map, terms) of
               NONE => NONE
             | SOME terms => SOME (Root (f, terms)))
   and substs (map, []) = SOME []
     | substs (map, term :: terms) = 
          case (subst (map, term), substs (map, terms)) of 
             (SOME term, SOME terms) => SOME (term :: terms) 
           | _ => NONE

   (* Partial substition *)
   (*[ val sub: (term * Symbol.symbol) -> term -> term ]*)
   fun sub (term', x) term = 
      case term of
         SymConst c => SymConst c
       | NatConst n => NatConst n
       | StrConst s => StrConst s
       | Var (NONE, ty) => Var (NONE, ty)
       | Var (SOME y, ty) => 
         if Symbol.eq (x, y) then term' else Var (SOME y, ty)
       | Root (f, terms) => 
         Root (f, map (sub (term', x)) terms)

   fun hasUscore term = 
      case term of 
         Var (NONE, _) => true  
       | Root (_, terms) => List.exists hasUscore terms
       | _ => false

   val plus = Symbol.fromValue "_plus"

   (* Generalization:
    *
    * genTerm (s (s x_0_0)) (s N)        = SOME { N |-> [ (s x_0) ] }
    * genTerm (s (s x_0_0)) (s (s N))    = SOME { N |-> [ x_0_0 ] }
    * genTerm (s (s x_0_0)) (s z)        = NONE (clash)
    * genTerm (s (s x_0_0)) (s (s (s N)) = NONE (not more general)
    * genTerm (f x_0 (s x_2_0)) (f X X)  = SOME { X |-> [ x_0, (s x_2_0) ]} *)
 
   local 
   exception Gen'

   (*[ val gen': int list -> eqssubst -> (shape * term_t) -> eqssubst ]*)
   (*[ val gens': int list -> int -> eqssubst -> (shape list * term_t list) 
                     -> eqssubst ]*)
   fun gen' path subst (shape, term) = 
      case (shape, term) of 
         (shape, Var (NONE, SOME _)) => subst
       | (shape, Var (SOME x, SOME t)) =>
            DictX.insertMerge subst x (t, [ (path, shape) ])
               (fn (t', pathshapes) =>
                   if not (Symbol.eq (t, t'))
                   then raise Fail "inconsistent types in gen'"
                   else (t', pathshapes @ [(path, shape)]))
       | (SymConst c, SymConst c') =>
            if Symbol.eq (c, c') then subst else raise Gen' (* clash *)
       | (NatConst n, NatConst n') =>
            if n = n' then subst else raise Gen' (* clash *)
       | (StrConst s, StrConst s') =>
            if s = s' then subst else raise Gen' (* clash *)
       | (Root _, SymConst _) => raise Gen' (* clash *)
       | (SymConst _, Root _) => raise Gen' (* clash *)
       | (Root (f, shapes), Root (f', terms)) =>
            if Symbol.eq (f, f') then gens' path 0 subst (shapes, terms) 
            else raise Gen' (* clash *)
       | (Path _, _) => raise Gen' (* shape is not more general than term! *)
       | _ => raise Fail "typing in gen'"

   and gens' path n subst (shapes, terms) =
      case (shapes, terms) of 
         ([], []) => subst
       | (shape :: shapes, term :: terms) =>
            gens' path (n+1)
               (gen' (path @ [ n ]) subst (shape, term))
               (shapes, terms)
       | _ => raise Fail "arity in gens'"
   in

   (*[ val gen: (shape * term_t) -> eqssubst option ]*)
   fun gen (shape, term) = 
      SOME (gen' [] DictX.empty (shape, term)) handle Gen' => NONE

   (*[ val gens: (shape list * term_t list) -> eqssubst option ]*)
   fun gens (shapes, terms) = 
      SOME (gens' [] 0 DictX.empty (shapes, terms)) handle Gen' => NONE

   end
end
