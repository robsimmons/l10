(* A splitting represents a covering set of patterns over a datatype *)

structure Splitting:>
sig
   datatype t = 
      Sym of Type.t * SetX.set
    | Nat of IntInfSplaySet.set
    | Str of StringSplaySet.set
    | Root of 
       { t: Type.t
       , covered: (int * t) list DictX.dict
       , uncovered: SetX.set}
    | Unsplit of Type.t

   val typ: t -> Type.t

   val isUnsplit: t -> bool

   (*[ val unsplit: Class.rel_t -> (int * t) list
                  & Class.world -> (int * t) list ]*)
   val unsplit: Class.t -> (int * t) list

   (*[ val singleton: Term.term_t -> t
                    & Term.moded_t -> t ]*)
   val singleton: Term.t -> t

   (*[ val insert: t -> ( Term.term_t -> t
                        & Term.moded_t -> t) ]*)
   (*[ val insertList: 
          (int * t) list -> ( Term.term_t list -> (int * t) list
                            & Term.moded_t list -> (int * t) list) ]*)
   val insert: t -> Term.t -> t
   val insertList: (int * t) list -> Term.t list -> (int * t) list
end = 
struct

datatype t = 
   Sym of Type.t * SetX.set
 | Nat of IntInfSplaySet.set
 | Str of StringSplaySet.set
 | Root of 
    { t: Type.t
    , covered: (int * t) list DictX.dict
    , uncovered: SetX.set}
 | Unsplit of Type.t

(*[ sortdef split = 
       {t: Type.t, covered: (int * t) list DictX.dict, uncovered: SetX.set} ]*)

fun typ (Sym (t, _)) = t
  | typ (Nat _) = Type.nat
  | typ (Str _) = Type.string
  | typ (Root {t, ...}) = t
  | typ (Unsplit t) = t

fun isUnsplit (Unsplit _) = true
  | isUnsplit _ = false

(*[ val unsplit': int -> ( Class.rel_t -> (int * t) list
                        & Class.world -> (int * t) list) ]*)
fun unsplit' n class = 
   case class of 
      Class.Arrow (t, class) => (n, Unsplit t) :: unsplit' (n+1) class
    | Class.Pi (t, SOME _, class) => (n, Unsplit t) :: unsplit' (n+1) class
    | _ => []

val unsplit = unsplit' 0

(*[ val singleton: Term.term_t -> t 
                 & Term.moded_t -> t ]*)
(*[ val singletonList: Term.term_t list -> (int * t) list
                     & Term.moded_t list -> (int * t) list ]*)
(*[ val singletonList': int -> ( Term.term_t list -> (int * t) list
                               & Term.moded_t list -> (int * t) list) ]*)
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
    | Term.Mode (_, SOME t) => Unsplit t
end

and singletonList' n [] = []
  | singletonList' n (term :: terms) = 
       (n, singleton term) :: singletonList' (n+1) terms

and singletonList terms = singletonList' 0 terms

(*[ val insert: t -> ( Term.term_t -> t 
                     & Term.moded_t -> t)]*)
(*[ val insertList: (int * t) list -> ( Term.term_t list -> (int * t) list 
                                      & Term.moded_t list -> (int * t) list) ]*)
fun insert splitting term =
   case (splitting, term) of
      (_, Term.Var _) => splitting
    | (_, Term.Mode _) => splitting
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
           | SOME l => raise Fail ("Splitting.insert ("^Symbol.toValue c
                                   ^"/"^Int.toString (length l)^")"))
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
  | insertList ((n, splitting) :: splittings) (term :: terms) = 
       ((n, insert splitting term) :: insertList splittings terms)
  | insertList splittings terms = 
       raise Fail ("Splitting.insertList ("^Int.toString (length splittings)
                   ^" splittings, "^Int.toString (length terms)^" terms)")

end
