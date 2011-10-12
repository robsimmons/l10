(* Abstract syntax tree for L10 *)
(* Robert J. Simmons *)

structure Mode = 
struct
   datatype t = Input | Output | Ignore
   fun toString Input = "+"
     | toString Output = "-"
     | toString Ignore = "_"
end

structure Term = 
struct
   datatype t = 
      SymConst of Symbol.symbol 
    | NatConst of int
    | StrConst of string
    | Structured of Symbol.symbol * t list
    | Var of Symbol.symbol option
    | Mode of Mode.t * Symbol.symbol option
(*[
   datasort term = 
      SymConst of Symbol.symbol 
    | NatConst of int
    | StrConst of string
    | Structured of Symbol.symbol * term list
    | Var of Symbol.symbol option

   datasort ground = 
      SymConst of Symbol.symbol 
    | NatConst of int
    | StrConst of string
    | Structured of Symbol.symbol * ground list
  
   datasort 'a none = NONE
   datasort shape = 
      SymConst of Symbol.symbol 
    | NatConst of int
    | StrConst of string
    | Structured of Symbol.symbol * shape list
    | Var of Symbol.symbol none 

   datasort moded = 
      SymConst of Symbol.symbol 
    | NatConst of int
    | StrConst of string
    | Structured of Symbol.symbol * moded list
    | Mode of Mode.t * Symbol.symbol none

   datasort 'a some = NONE
   datasort modety = 
      SymConst of Symbol.symbol 
    | NatConst of int
    | StrConst of string
    | Structured of Symbol.symbol * moded list
    | Mode of Mode.t * Symbol.symbol some
]*)

   fun eq (term1, term2) = 
      case (term1, term2) of
         (SymConst c1, SymConst c2) => Symbol.eq (c1, c2)
       | (NatConst n1, NatConst n2) => n1 = n2
       | (StrConst s1, StrConst s2) => s1 = s2
       | (Structured (f1, terms1), Structured (f2, terms2)) => 
         Symbol.eq(f1, f2)
         andalso List.all eq (ListPair.zip (terms1, terms2))
       | (Var NONE, Var NONE) => true
       | (Var (SOME v1), Var (SOME v2)) => Symbol.eq (v1, v2)
       | (Mode (m1, _), Mode (m2, _)) => m1 = m2
       | (_, _) => false

   fun fv term =
      case term of 
         Var (SOME x) => SetX.singleton x
       | Structured (_, terms) => fvs terms
       | _ => SetX.empty

   and fvs terms = 
      List.foldr (fn (t, set) => SetX.union (fv t) set) SetX.empty terms

   fun toString term = 
      case term of 
         SymConst c => Symbol.toValue c
       | NatConst i => Int.toString i
       | StrConst s => "\"" ^ s ^ "\""
       | Structured (f, terms) => 
         if Symbol.eq (f, Symbol.fromValue "_plus") andalso length terms = 2
         then ("(" ^ toString (hd terms) 
               ^ " + " ^ toString (hd (tl terms)) ^ ")")
         else ("(" 
               ^ Symbol.toValue f 
               ^ String.concat (map (fn term => " " ^ toString term) terms)
               ^ ")")
       | Var NONE => "_"
       | Var (SOME x) => Symbol.toValue x
       | Mode (m, _) => Mode.toString m

   (*[ sortdef subst = term DictX.dict ]*)
   
   (* Total substitution *)
   (*[ val subst: subst * term -> term option ]*)
   (*[ val substs: subst * term list -> term list option ]*)
   fun subst (map, term) =
      case term of 
         SymConst c => SOME (SymConst c)
       | NatConst n => SOME (NatConst n)
       | StrConst s => SOME (StrConst s)
       | Structured (f, terms) =>  
         (case substs (map, terms) of
             NONE => NONE
           | SOME terms => SOME (Structured (f, terms)))
       | Var NONE => NONE
       | Var (SOME x) => DictX.find map x
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
       | Structured (f, terms) => 
         Structured (f, map (sub (term', x)) terms)
       | Var NONE => Var NONE
       | Var (SOME y) => if Symbol.eq (x, y) then term' else Var (SOME y)

   (*[ val hasUscore: term -> bool ]*)
   fun hasUscore term = 
      case term of 
         Var NONE => true  
       | Structured (_, terms) => List.exists hasUscore terms
       | _ => false
end

structure Atom = struct
   type t = Symbol.symbol * Term.t list
   (*[ sortdef world = Symbol.symbol * Term.term list ]*)
   (*[ sortdef prop = Symbol.symbol * Term.term list ]*) 
   (*[ sortdef ground_world = Symbol.symbol * Term.ground list ]*) 
   (*[ sortdef ground_prop = Symbol.symbol * Term.ground list ]*) 
   (*[ sortdef moded = Symbol.symbol * Term.moded list ]*) 

   (*[ val fv: (world & prop) -> SetX.set ]*)
   fun fv (_, terms) = Term.fvs terms

   (*[ val fvs: (world & prop) list -> SetX.set ]*)
   fun fvs atoms = 
      List.foldr (fn (atom, set) => SetX.union (fv atom) set) SetX.empty atoms

   (*[ val hasUscore: (world & prop) -> bool ]*)
   fun hasUscore (_, terms) = List.exists Term.hasUscore terms

   (*[ val eq: (t * t) -> bool ]*)
   fun eq ((a1, terms1), (a2, terms2)) =
     Symbol.eq (a1, a2) andalso List.all Term.eq (ListPair.zip (terms1, terms2))

   (*[ val toString': bool -> t -> string ]*) 
   (*[ val toString: t -> string ]*) 
   fun toString' parens (w, []) = Symbol.toValue w
     | toString' parens (w, terms) =
       (if parens then "(" else "")
       ^ Symbol.toValue w 
       ^ String.concat (map (fn term => " " ^ Term.toString term) terms)
       ^ (if parens then ")" else "")
   val toString = toString' false
end

structure Pat = struct
   datatype t =
      Atomic of Atom.t
    | Exists of Symbol.symbol * t
    | Conj of t * t
    | One
(*[
   datasort pat = 
      Atomic of Atom.prop
    | Exists of Symbol.symbol * pat
]*)

   (*[ val fv: pat -> SetX.set ]*)
   fun fv pat = 
      case pat of 
         Atomic atomic => Atom.fv atomic
       | Exists (x, pat) => 
         let val vars = fv pat 
         in if SetX.member vars x then SetX.remove vars x else vars end

   (*[ val fvs: pat list -> SetX.set ]*)
   fun fvs pats = 
      foldl (fn (x, y) => SetX.union x y) SetX.empty (map fv pats)

   fun toString pat = 
      case pat of
         Atomic atm => Atom.toString' false atm
       | Exists (x, pat0) => 
         "(Ex " ^ Symbol.toValue x ^ ". " ^ toString pat0 ^ ")"
       | Conj (pat1, pat2) => toString pat1 ^ ", " ^ toString pat2
       | One => "<<one>>"
end

structure Binrel = struct
   datatype t = Eq | Neq | Gt | Geq 

   fun toString Eq = "=="
     | toString Neq = "!="
     | toString Gt = ">"
     | toString Geq = ">="
end

structure Prem = struct
   datatype t = 
      Normal of Pat.t
    | Negated of Pat.t
    | Binrel of Binrel.t * Term.t * Term.t
(*[ 
   datasort prem = 
      Normal of Pat.pat
    | Negated of Pat.pat
    | Binrel of Binrel.t * Term.term * Term.term
]*)

   (*[ val fv: prem -> SetX.set ]*)
   fun fv prem = 
      case prem of 
         Normal pat => Pat.fv pat
       | Negated pat => Pat.fv pat
       | Binrel (_, term1, term2) => SetX.union (Term.fv term1) (Term.fv term2)

   fun toString prem =  
      case prem of 
         Normal pat => Pat.toString pat
       | Negated pat => "not (" ^ Pat.toString pat ^ ")"
       | Binrel (br, term1, term2) => 
         Term.toString term1 ^ " "
         ^ Binrel.toString br ^ " "
         ^ Term.toString term2
end

structure Rule = struct
   type t = (Pos.t * Prem.t) list * (Pos.t * Atom.t) list   
   (*[ sortdef rule = (Pos.t * Prem.prem) list * (Pos.t * Atom.prop) list ]*)

   (*[ val fv: rule -> SetX.set ]*)
   fun fv ((prems, concs): t) =
      SetX.union 
         (List.foldl (fn (x, y) => SetX.union x y)
            SetX.empty (map (Prem.fv o #2) prems))
         (List.foldl (fn (x, y) => SetX.union x y) 
            SetX.empty (map (Atom.fv o #2) concs))   
end

structure Class = 
struct
   datatype t = 
      Base of Symbol.symbol 
    | Rel of Pos.t * Atom.t
    | World
    | Type
    | Arrow of Symbol.symbol * t
    | Pi of Symbol.symbol * Symbol.symbol * t
(*[
   datasort world = 
      World
    | Arrow of Symbol.symbol * world

   datasort typ =
      Base of Symbol.symbol
    | Arrow of Symbol.symbol * typ

   datasort rel = 
      Rel of Pos.t * Atom.world
    | Arrow of Symbol.symbol * rel
    | Pi of Symbol.symbol * Symbol.symbol * rel

   datasort knd = 
      Type
]*)

   fun toString typ = 
      case typ of 
         Base t => Symbol.toValue t
       | Rel (_, world) => "rel @ " ^ Atom.toString' false world
       | World => "world"
       | Type => "type"
       | Arrow (t, typ) => Symbol.toValue t ^ " -> " ^ toString typ
       | Pi (x, t, typ) => 
         "{" ^ Symbol.toValue x ^ ": " ^ Symbol.toValue t ^ "} " ^ toString typ
end

structure Decl = struct
   datatype t = 
      World of Pos.t * Symbol.symbol * Class.t
    | Const of Pos.t * Symbol.symbol * Class.t
    | Rel of Pos.t * Symbol.symbol * Class.t
    | Type of Pos.t * Symbol.symbol * Class.t
    | DB of Pos.t * Symbol.symbol * (Pos.t * Atom.t) list * (Pos.t * Atom.t)
    | Depends of Pos.t * (Pos.t * Atom.t) * (Pos.t * Atom.t) list
    | Rule of Pos.t * Rule.t
    | Query of Pos.t * Symbol.symbol * Atom.t
(*[
   datasort decl = 
      World of Pos.t * Symbol.symbol * Class.world
    | Const of Pos.t * Symbol.symbol * Class.typ
    | Rel of Pos.t * Symbol.symbol * Class.rel
    | Type of Pos.t * Symbol.symbol * Class.knd
    | DB of Pos.t 
            * Symbol.symbol 
            * (Pos.t * Atom.ground_prop) list 
            * (Pos.t * Atom.ground_world)
    | Depends of Pos.t * (Pos.t * Atom.world) * (Pos.t * Atom.world) list
    | Rule of Pos.t * Rule.rule
    | Query of Pos.t * Symbol.symbol * Atom.moded

   datasort class = 
      World of Pos.t * Symbol.symbol * Class.world
    | Const of Pos.t * Symbol.symbol * Class.typ
    | Rel of Pos.t * Symbol.symbol * Class.rel
    | Type of Pos.t * Symbol.symbol * Class.knd
]*)

end

