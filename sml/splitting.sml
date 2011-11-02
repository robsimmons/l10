(* A splitting represents a covering set of patterns over a datatype *)

structure Splitting:>
sig
   datatype t = 
      Sym of Type.t * SetX.set
    | Nat of IntInfSplaySet.set
    | Str of StringSplaySet.set
    | Root of {t: Type.t, covered: t list DictX.dict, uncovered: SetX.set}
    | Unsplit of Type.t

   val unsplit: t -> bool

   (*[ val singleton: Term.term_t -> t ]*)
   val singleton: Term.t -> t

   (*[ val insert: t -> Term.term_t -> t ]*)
   (*[ val insertList: t list -> Term.term_t list -> t list ]*)
   val insert: t -> Term.t -> t
   val insertList: t list -> Term.t list -> t list
end = 
struct

datatype t = 
   Sym of Type.t * SetX.set
 | Nat of IntInfSplaySet.set
 | Str of StringSplaySet.set
 | Root of {t: Type.t, covered: t list DictX.dict, uncovered: SetX.set}
 | Unsplit of Type.t

(*[ sortdef split = 
       {t: Type.t, covered: t list DictX.dict, uncovered: SetX.set} ]*)

fun unsplit (Unsplit _) = true
  | unsplit _ = false

(*[ val singleton: Term.term_t -> t ]*)
(*[ val singletonList: Term.term_t list -> t list ]*)
fun singleton term = 
let 
   (*[ val split: Type.t -> (Symbol.symbol * Term.term_t list) -> split ]*)
   fun split t (f, terms) = 
   let val cons = Tab.lookup Tab.typecon t 
   in
     ( if SetX.member cons f then () else raise Fail "Splitting.singleton"
     ; { t = t
       , covered = DictX.singleton f (singletonList terms)
       , uncovered = SetX.remove cons f})
   end
in case term of 
      Term.SymConst c => 
      let val t = Class.base (Tab.lookup Tab.consts c)
      in case Tab.lookup Tab.types t of
            Class.Extensible => Sym (t, SetX.singleton c)
          | Class.Type => Root (split t (c, []))
          | _ => raise Fail "Splitting.singleton"
      end
    | Term.NatConst i => Nat (IntInfSplaySet.singleton i)
    | Term.StrConst s => Str (StringSplaySet.singleton s)
    | Term.Root (f, terms) => 
      let val t = Class.base (Tab.lookup Tab.consts f)
      in Root (split t (f, terms)) 
      end
    | Term.Var (_, SOME t) => Unsplit t
end

and singletonList terms = 
   (map (*[ <: (Term.term_t -> t) -> Term.term_t conslist -> t conslist
             & (Term.term_t -> t) -> Term.term_t list -> t list ]*)) 
       singleton terms

(*[ val insert: t -> Term.term_t -> t ]*)
(*[ val insertList: t list -> Term.term_t list -> t list ]*)
fun insert splitting term =
   case (splitting, term) of
      (_, Term.Var _) => splitting
    | (Unsplit _, _) => singleton term
    | (Sym (t, set), Term.SymConst c) => 
         Sym (t, SetX.insert set c)
    | (Nat set, Term.NatConst i) => 
         Nat (IntInfSplaySet.insert set i)
    | (Str set, Term.StrConst s) => 
         Str (StringSplaySet.insert set s)
    | (Root {t, covered, uncovered}, Term.SymConst c) =>
         (case DictX.find covered c of 
             NONE => 
                Root 
                   { t = t
                   , covered = DictX.insert covered c []
                   , uncovered = SetX.remove uncovered c}
           | SOME [] => splitting
           | _ => raise Fail "Splitting.insert")
    | (Root {t, covered, uncovered}, Term.Root (f, terms)) =>
         (case DictX.find covered f of 
             NONE => 
                Root 
                   { t = t
                   , covered = DictX.insert covered f (singletonList terms)
                   , uncovered = SetX.remove uncovered f}
           | SOME trees => 
                Root 
                   { t = t 
                   , covered = DictX.insert covered f (insertList trees terms)
                   , uncovered = uncovered})
    | _ => raise Fail "Splitting.insert (coverage)"

and insertList [] [] = []
  | insertList (splitting :: splittings) (term :: terms) = 
       (insert splitting term :: insertList splittings terms)
  | insertList _ _ = raise Fail "Splitting.insertList"

end
