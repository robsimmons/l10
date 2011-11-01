(* Copyright (C) 2011 Robert J. Simmons *)

structure EmitTerms:>
sig
   type subterm = {t: Symbol.symbol, ts: string, mutual: bool, n: int}
   datatype dtype =
      DT of 
       { ts: string 
       , tS: string
       , arms: (string * int * subterm list) list
       , rep: Type.representation}
   val dtype: Type.t -> dtype
   val emit: unit -> unit
end =
struct

open Util

(* A representation of the initial datatype *)
type subterm = {t: Symbol.symbol, ts: string, mutual: bool, n: int}
datatype dtype =
   DT of 
    { ts: string 
    , tS: string
    , arms: (string * int * subterm list) list
    , rep: Type.representation}
fun makeDatatype mutually_defined (t, rep): dtype = 
    let 
       (*[ subterms: Class.typ -> int -> subterm list -> subterm list ]*)
       fun subterms (Class.Base _) n accum: subterm list = rev accum
         | subterms (Class.Arrow (t, class)) n accum = 
           let 
              val mutual = mutually_defined t
              val subterm =
                 {t = t, ts = Symbol.toValue t, mutual = mutual, n=n}
           in subterms class (n+1) (subterm :: accum)
           end

       fun armfolder (c, (n, constrs)) =
          (n+1
           , ((Strings.symbol c, n, subterms (Tab.lookup Tab.consts c) 0 []) 
              :: constrs))

       val (_, arms) = SetX.foldl armfolder (0, []) (Tab.lookup Tab.typecon t)
    in 
       DT {ts = Symbol.toValue t
           , tS = Strings.symbol t
           , arms = rev arms
           , rep = rep}
    end

fun dtype t = 
let 
   val rep = 
      case Tab.find Tab.representations t of NONE => Type.Sealed | SOME r => r
in makeDatatype (fn _ => false) (t, rep)
end

(* Emit the "datatype" portion *)
fun isPrj rep = 
   case rep of 
      Type.Transparent => false
    | Type.Sealed => true
    | Type.HashConsed => true
    | Type.External => false

exception Skip
fun emitDatatype (isAnd, (t, DT {ts, tS, arms, rep})) =
let
   val () = if rep = Type.External then raise Skip else ()

   val ty = (if isPrj rep then "view_" else "t_") ^ ts
   val prelude = 
      (if isAnd then "and" else "datatype")
      ^ " " ^ ty ^ " = "
      ^ (if not (null arms) then ""
         else ("Fake" ^ tS ^ " of " ^ ty))
   fun typ {t, ts, mutual, n}= 
      if mutual then ("t_" ^ ts) else Strings.typ t
in
 ( emit [ prelude ]
 ; appFirst (fn () => ())
      (fn (str', (constructor, _, [])) => emit [str' ^ constructor]
        | (str', (constructor, _, subterms)) =>
             emit [str' ^ constructor ^ " of " 
                   ^ String.concatWith " * " (map typ subterms)])
      ("   ", " | ")
      arms
 ; if isPrj rep 
   then emit ["and t_" ^ ts ^ " = inj_" ^ ts ^ " of view_" ^ ts, ""]
   else emit [""])
end 
handle Skip => (emit ["datatype t_" ^ ts ^ " = datatype " ^ tS ^ ".t", ""])

fun emitEq (isAnd, (t, DT {ts, tS, arms, rep})) =
let
   fun emitCase pre post (c, _, (xs: subterm list)) =
   let 
      fun geteq {t, ts, mutual, n} = 
      let val n = Int.toString n 
      in
         if mutual then "eq_" ^ ts ^ " (x_" ^ n ^ ", y_" ^ n ^ ")" 
         else Strings.eq t ("x_" ^ n) ("y_" ^ n)
      end
   in
    ( emit [pre ^ "(" ^ c 
            ^ Strings.optTuple (map (fn x => "x_" ^ Int.toString (#n x)) xs)
            ^ ", " ^ c
            ^ Strings.optTuple (map (fn x => "y_" ^ Int.toString (#n x)) xs)
            ^ ") => " ]
    ; incr ()
    ; appSuper
         (fn () => emit ["   true" ^ post])
         (fn x => emit ["   " ^ geteq x ^ post])
         ((fn x => (incr (); emit [geteq x]))
          , (fn x => emit ["andalso " ^ geteq x])
          , (fn x => (emit ["andalso " ^ geteq x ^ post]; decr ())))
         xs
    ; decr ())
   end
 
   val prefix = 
      (if isAnd then "and" else "fun")  
      ^ " eq_" ^ ts ^ " "
      ^ (if isPrj rep then ("(inj_" ^ ts ^ " x, inj_" ^ ts ^ " y) =") 
         else "(x, y) =")
in
   appSuper
      (fn () => emit [prefix ^ " raise Match (* Impossible *)"])
      (fn x => (emit [prefix ^ " true"]))
      ((fn x => 
         ( emit [prefix, "  (case (x, y) of"]
         ; incr ()
         ; emitCase "   " "" x))
       , (fn x => (emitCase " | " "" x))
       , (fn x => (emitCase " | " "" x; emit [" | _ => false)"]; decr ())))
      arms
end

fun emitStr (isAnd, (t, DT {ts, tS, arms, rep})) = 
let
   fun emitCase pre post (c, _, (xs: subterm list)) =
   let 
      fun getstr {t, ts, mutual, n} = 
         if mutual then "str_" ^ ts ^ " x_" ^ Int.toString n 
         else Strings.str t ("x_" ^ Int.toString n)
   in
    ( emit [pre ^ c 
            ^ Strings.optTuple (map (fn x => "x_" ^ Int.toString (#n x)) xs)
            ^ " => " ]
    ; incr ()
    ; appSuper
         (fn () => emit ["   \"" ^ c ^ "\"" ^ post])
         (fn x => emit ["   \"(" ^ c ^ " \" ^ " ^ getstr x ^ " ^ \")\"" ^ post])
         ((fn x => (incr (); emit ["\"(" ^ c ^ " \" ^ " ^ getstr x]))
          , (fn x => emit ["^ " ^ getstr x])
          , (fn x => (emit ["^ " ^ getstr x ^ " ^ \")\"" ^ post]; decr ())))
         xs
    ; decr ())
   end
 
   val prefix = 
      (if isAnd then "and" else "fun")  
      ^ " str_" ^ ts ^ " "
      ^ (if isPrj rep then ("(inj_" ^ ts ^ " x) =") else "x =")
in
   appSuper
      (fn () => emit [prefix ^ " raise Match (* Impossible *)"])
      (fn x => (emit [prefix]; emitCase "  (case x of " ")" x))
      ((fn x => 
         ( emit [prefix, "  (case x of"]
         ; incr ()
         ; emitCase "   " "" x))
       , (fn x => (emitCase " | " "" x))
       , (fn x => (emitCase " | " ")" x; decr ())))
      arms
end

fun emitZip isUn (isAnd, (t, DT {ts, tS, arms, rep})) = 
let
   val sub = if isUn then "unzip" else "sub"
   val len = Int.toString (length arms)
   fun emitCase pre post (c, ndx, (xs: subterm list)) =
   let 
      fun getzip {t, ts, mutual, n} = 
         if mutual then sub ^ "_" ^ ts ^ " x_" ^ Int.toString n 
         else "DiscDict." ^ sub ^ Strings.symbol t ^ " x_" ^ Int.toString n
      val uz = 
         if not isUn then "DiscDict.sub " ^ Int.toString ndx 
         else "DiscDict.unzip (" ^ Int.toString ndx ^ ", " ^ len ^")"
   in
    ( emit [pre ^ c 
            ^ Strings.optTuple (map (fn x => "x_" ^ Int.toString (#n x)) xs)
            ^ " => " ]
    ; incr ()
    ; appSuper
         (fn () => emit ["   " ^ uz ^ post])
         (fn x => emit ["   " ^ getzip x ^ " o", "   " ^ uz ^ post])
         ((fn x => (incr (); emit [getzip x ^ " o"]))
          , (fn x => emit [getzip x ^ " o"])
          , (fn x => (emit [getzip x ^ " o", uz ^ post]; decr ())))
         (rev xs)
    ; decr ())
   end
 
   val prefix = 
      (if isAnd then "and" else "fun")  
      ^ " " ^ sub ^ "_" ^ ts ^ " "
      ^ (if isPrj rep then ("(inj_" ^ ts ^ " x) =") else "x =")
in
   appSuper
      (fn () => emit [prefix ^ " raise Match (* Impossible *)"])
      (fn x => 
         ( emit [prefix, "  (case x of "]
         ; incr ()
         ; emitCase "   " ")" x
         ; decr ()))
      ((fn x => 
         ( emit [prefix, "  (case x of"]
         ; incr ()
         ; emitCase "   " "" x))
       , (fn x => (emitCase " | " "" x))
       , (fn x => (emitCase " | " ")" x; decr ())))
      arms
end

(* Emit the structure which will be externally viewable *)
fun emitDatastructure (t, DT {ts, tS, arms, rep}) = 
let 
   val sealed = 
      case rep of 
         Type.Transparent => false
       | Type.Sealed => true
       | Type.HashConsed => true
       | Type.External => false
in
 ( emit ["structure " ^ tS ^ " = ", "struct"]
 ; incr ()
    ; if sealed 
      then emit ["type t = L10_Terms.t_" ^ ts]
      else emit ["datatype t = datatype L10_Terms.t_" ^ ts]
    ; emit ["structure Dict:> DICT where type key = t = DiscDictFun", "(struct"]
    ; emit ["   type t = L10_Terms.t_" ^ ts]
    ; emit ["   val sub = L10_Terms.sub_" ^ ts]
    ; emit ["   val unzip = L10_Terms.unzip_" ^ ts, "end)"]
    ; if sealed 
      then emit ["datatype view = datatype L10_Terms.view_" ^ ts]
      else ()
    ; if sealed 
      then emit ["fun inj (x: view): t = L10_Terms.inj_" ^ ts ^ " x"]
      else ()
    ; if sealed
      then emit ["fun prj (L10_Terms.inj_" ^ ts ^ " x: t): view = x"]
      else ()
    ; emit ["val toString: t -> string = L10_Terms.str_" ^ ts]
    ; emit ["val eq: t * t -> bool = L10_Terms.eq_" ^ ts]
    ; if sealed
      then List.app 
              (fn (cstr, _, []) => 
                     emit ["val " ^ cstr ^ "': t = inj " ^ cstr]
                | (cstr, _, _) => 
                     emit ["fun " ^ cstr ^ "' x: t = inj (" ^ cstr ^ " x)"])
              arms
      else ()            
 ; decr ()
 ; emit ["end", ""])
end 


(* This function splits the datatypes into sections that aren't mutually
 * recursive. The only necessary property of this function, and indeed the
 * only property that this function currently has at all, is to make sure that
 * "external" types are all defined prior to other types, because otherwise
 * the datatype definitions won't refer to each other correctly. *)
fun partition_types (): ((Type.t * dtype) list * SetX.set) list = 
let
   fun folder ((t, Class.Type (* <: Class.knd *)), (dict1, dict2)) = 
         (case Tab.find Tab.representations t of 
             NONE => 
                (dict1, DictX.insert dict2 t (t, Type.Sealed))
           | SOME Type.Sealed => 
                (dict1, DictX.insert dict2 t (t, Type.Sealed))
           | SOME Type.Transparent => 
                (dict1, DictX.insert dict2 t (t, Type.Transparent))
           | SOME Type.HashConsed => raise Fail "Dunno about hashconsing"
           | SOME Type.External => 
                (DictX.insert dict1 t (t, Type.External), dict2))
     | folder (_, x) = x

   val (dict1, dict2) = 
      List.foldr folder (DictX.empty, DictX.empty) (Tab.list Tab.types)

   fun mapper dict = 
      DictX.toList (DictX.map (makeDatatype (DictX.member dict)) dict)

   fun dependency (dtypes: (Type.t * dtype) list) = 
   let 
      val defs = 
         foldr (fn ((t, _), set) => SetX.insert set t) SetX.empty dtypes
      val uses = 
         foldr (fn ((_, DT {arms, ...}), set) =>
                   foldr (fn ((_, _, subterms), set) => 
                             foldr (fn ({t, ...}, set) => SetX.insert set t)
                                set subterms)
                      set arms)
            SetX.empty dtypes
   in
      (dtypes, SetX.difference uses defs)
   end
in
   map (dependency o mapper) [dict1, dict2]
end

fun terms () = 
let
   val datatypes = partition_types ()
   fun body ((dtypes, dependencies): ((Type.t * dtype) list * SetX.set)) = 
    ( emit (DiscTree.discCore dependencies)
    ; emit ["structure L10_Terms = ", "struct"]
    ; incr ()
       ; appFirst (fn () => ()) emitDatatype (false, true) dtypes
       ; appFirst (fn () => ()) emitEq (false, true) dtypes
       ; emit [""]
       ; appFirst (fn () => ()) emitStr (false, true) dtypes
       ; emit [""]
       ; appFirst (fn () => ()) (emitZip false) (false, true) dtypes
       ; emit [""]
       ; appFirst (fn () => ()) (emitZip true) (false, true) dtypes
    ; decr ()
    ; emit ["end", ""]
    ; app emitDatastructure dtypes)
in
 ( emit ["","(* L10 Generated Terms (terms.sml) *)", ""]
 ; app body datatypes
 ; emit ["structure L10_Terms = struct end (* Protect *)"]
 ; emit ["structure DiscDict = struct end (* Protect *)"]
 ; emit ["structure DiscDictFun = struct end (* Protect *)"]
)
end

fun emit () = terms ()
(*

      emit ("structure " ^ getPrefix true "" ^ "Terms:> " 
              ^ String.map Char.toUpper (getPrefix true "_") ^ "TERMS =")
      ; emit "struct"
      ; incr ()
      ; emit "(* Datatype views *)\n"
      ; emit "datatype fake_ = Fake_ of fake_"
      ; app (fn x => 
               (emitView true x
                ; emit ("and " ^ nameOfType x 
                        ^ " = inj" ^ NameOfType x
                        ^ " of " ^ nameOfView x)))
           encodedTypes
      ; emit "\n"
      ; emit "(* Constructor-specific projections, injections, and aborts *)\n"
      ; app emitPrj encodedTypes
      ; app emitInj encodedTypes
      ; app emitAbort encodedTypes

      ; emit "\n"
      ; emit "(* String encoding functions *)\n"
      ; emit "fun strFake_ (Fake_ x) = strFake_ x"
      ; app emitStr encodedTypes

      ; emit "\n"
      ; emit "(* Equality *)\n"
      ; app emitEq encodedTypes
      ; emit ""
      ; emitMapHeader "sub"

      ; app (emitMapHelper "sub") encodedTypes
      ; emitMapHeader "unzip"
      ; app (emitMapHelper "unzip") encodedTypes

      ; emit ""
      ; emit ("(* Maps *)\n")
      ; app emitMap encodedTypes
      ; decr ()
      ; emit "end\n"
   end
*)

end

(*
structure SMLCompileTerms:> 
sig
   val termsSig: unit -> unit (* signature FOO_TERMS *)
   val terms: unit -> unit    (* structure FooTerms *) 

   (* Give a constructing-ready SML term corresponding to an AST term *)
   val buildTerm: Ast.term -> string

   (* Given a term, returns a pathvar-based substitution along with 
    * equality constraints *)
   type constraint = Ast.typ * Symbol.symbol * Symbol.symbol
   val pathTerm: Ast.term * Ast.typ
      -> Ast.term * Ast.subst * constraint list  
   val pathTerms: (Ast.term * Ast.typ) list 
      -> Ast.term list * Ast.subst * constraint list  


   (* A pathvar is an annotated list of how-you-got-to-this-term *)
   type 'a pathvar = int list * 'a 
   val nameOfVar: 'a pathvar -> string

   (* Builds a depth-1 pattern match, extending paths and data *)
   val constructorPattern: 
      (int * Ast.typ -> 'b)                 (* Extension function *)
      -> 'a pathvar                         (* Current path *)
      -> Symbol.symbol                      (* New constructor *)
      -> (String.string * 'b pathvar list) 
end = 
struct

open SMLCompileUtil
open SMLCompileTypes

type 'a pathvar = int list * 'a 

fun nameOfVar (is, _) = "x_" ^ String.concatWith "_" (map Int.toString is)

fun constructorPattern f (pathvar: 'a pathvar) constructor = 
   case ConTab.lookup constructor of
      ([], _) => (embiggen (Symbol.name constructor), [])
    | (typs, _) => 
      let
         fun extend (n, typ) = (#1 pathvar @ [ n ], f (n, typ))
         val pathvars = map extend (mapi typs)
         val strpat = 
            embiggen (Symbol.name constructor) 
            ^ (if null (tl typs) then " " else " (")
            ^ String.concatWith ", " (map nameOfVar pathvars) 
            ^ (if null (tl typs) then "" else ")")
      in 
         (strpat, pathvars)
      end

fun buildTerm term = 
   case term of
      Ast.Const x => embiggen (Symbol.name x) ^ "'"
    | Ast.NatConst i => IntInf.toString i
    | Ast.StrConst s => "\"" ^ String.toCString s ^ "\""
    | Ast.Structured (f, terms) => 
      if f = ConTab.plus 
      then "(" ^ buildTerm (hd terms) ^ " + " ^ buildTerm (hd (tl terms)) ^ ")"
      else 
        "(" ^ embiggen (Symbol.name f)  ^ "'" ^ optTuple buildTerm terms ^ ")"
    | Ast.Var NONE => raise Fail "Building term with unknown part"
    | Ast.Var (SOME x) => Symbol.name x

fun pathTerm (term: Ast.term * Ast.typ, path, subst, eqs) = 
   case #1 term of
      Ast.Var NONE => (Ast.Var NONE, (subst, eqs))
    | Ast.Var (SOME x) => 
      let 
         val pathvar = Symbol.symbol (nameOfVar (path, ()))
      in
         (Ast.Var (SOME pathvar),
          case MapX.find (subst, x) of
             NONE => (MapX.insert (subst, x, pathvar), eqs)
           | SOME pathvar' => (subst, (#2 term, pathvar, pathvar') :: eqs))
      end
    | Ast.Structured (f, terms) => 
      let 
         val (typs, _) = ConTab.lookup f
         val (terms', subst', eqs') = 
            pathTerms (ListPair.zipEq (terms, typs), path, 0, subst, eqs)
      in
         (Ast.Structured (f, terms'), (subst', eqs'))
      end
    | term => (term, (subst, eqs))

and pathTerms ([], path, n, subst, eqs) = ([], subst, eqs)
  | pathTerms (term :: terms, path, n, subst, eqs) = 
    let 
       val (term', (subst', eqs')) = pathTerm (term, path @ [ n ], subst, eqs)
       val (terms', subst'', eqs'') = pathTerms (terms, path, n+1, subst', eqs')
    in
       (term' :: terms', subst'', eqs'')
    end     

type constraint = Ast.typ * Symbol.symbol * Symbol.symbol

val pathTerm = fn term =>
   let 
      val (term, (subst, eqs)) = pathTerm (term, [], MapX.empty, [])
   in
      (term, MapX.map (Ast.Var o SOME) subst, eqs)
   end

val pathTerms = fn terms =>
   let
      val (terms, subst, eqs) = pathTerms (terms, [], 0, MapX.empty, [])
   in
      (terms, MapX.map (Ast.Var o SOME) subst, eqs) 
   end



(* The fundamental view datatype *)

fun emitView isRec x = 
   let
      val () = emit ""
      val name = nameOfType x
      val view = nameOfView x
      fun keyword isRec = if isRec then "and" else "datatype"
      fun args ([], _) = ""
        | args (types, _) =
          " of " ^ String.concatWith " * " (map nameOfType types)
      fun emitVoid () = 
          emit ("   Void_" ^ embiggen name ^ " of " ^ view)
      fun emitCase prefix constructor = 
          emit (prefix ^ embiggen (Symbol.name constructor) 
                ^ args (ConTab.lookup constructor))
   in
      emit (keyword isRec ^ " " ^ view ^ " =")
      ; appFirst emitVoid emitCase ("   ", " | ") (rev (TypeConTab.lookup x))
   end



(* SML doesn't handle empty types well, so we write an abort function *)

fun emitAbortSig x = 
   if null (TypeConTab.lookup x) 
   then emit ("val abort" ^ bigName x ^ ": "^ nameOfView x ^ " -> 'a")
   else ()

fun emitAbort x = 
   if null (TypeConTab.lookup x)
   then (emit ("fun abort" ^ bigName x ^ " (Void_" ^ bigName x ^ " x) = "
               ^ "abort" ^ bigName x ^ " x"))
   else ()


(* Projection functions: quite simple in this implementation *)

fun emitPrj x = 
   emit ("fun prj" ^ bigName x ^ " (inj" ^ bigName x ^ " x) = x")


(* Injecting versions of each of the constructors *)

fun emitInjSig x = 
   let
      val name = nameOfType x
      fun emitSingle constructor = 
         let 
            val args = map nameOfType (#1 (ConTab.lookup constructor))
         in
            if null args 
            then emit ("val " ^ bigName constructor ^ "': " ^ name)
            else emit ("val " ^ bigName constructor ^ "': " 
                       ^ String.concatWith " * " args ^ " -> " ^ name)
         end
   in
      app emitSingle (rev (TypeConTab.lookup x))
   end

fun emitInj x = 
   let
      fun emitSingle constructor = 
         let 
            val args = map nameOfType (#1 (ConTab.lookup constructor))
         in
            if null args 
            then emit ("val " ^ bigName constructor ^ "' = " 
                       ^ "inj" ^ bigName x ^ " " ^ bigName constructor)
            else emit ("val " ^ bigName constructor ^ "' = "
                       ^ "inj" ^ bigName x ^ " o " ^ bigName constructor)
         end
   in
      app emitSingle (rev (TypeConTab.lookup x))
   end


(* The toString function *)

fun emitStr x = 
   let 
      val name = nameOfType x
      val Name = embiggen name
                         
      exception Brk
      fun emitCase prefix constructor =
         let 
            val (match, pathvars) = 
               constructorPattern (fn (_, typ) => typ)
                  ([], ()) constructor
            fun emitSingle (pathvar as (_, typ)) = 
               emit (" ^ \" \" ^ " ^ nameOfStr typ ^ " " ^ nameOfVar pathvar)
         in
            emit (prefix ^ match ^ " =>")
            ; if null pathvars
              then (emit ("   \"" ^ Symbol.name constructor ^ "\""); raise Brk)
              else (emit ("   (\"(" ^ Symbol.name constructor ^ "\""))
            ; incr ()
            ; app emitSingle pathvars
            ; emit " ^ \")\")"
            ; decr ()
         end handle Brk => ()

   in
      emit ""
      ; emit ("and str" ^ Name ^ " x_ = ")
      ; incr ()
      ; emit ("case prj" ^ Name ^ " x_ of")
      ; appFirst (fn () => emit ("   x => abort" ^ Name ^ " x")) emitCase
           ("   ", " | ") (rev (TypeConTab.lookup x))
      ; decr ()
   end


(* The unzip/sub functions *)

fun emitMapHeader kind = 
   let in
      emit ""
      ; emit ("(* Map helpers: " ^ kind ^ " *)\n")
      ; emit ("fun " ^ kind ^ "T x_ = DiscMap." ^ kind ^ "X x_\n")
      ; emit ("fun " ^ kind ^ "Nat x_ = DiscMap." ^ kind ^ "II x_\n")
      ; emit ("fun " ^ kind ^ "String x_ = DiscMap." ^ kind ^ "S x_\n")
   end


fun emitMapHelper kind x = 
   let
      val Name = NameOfType x
      val constructors = mapi (TypeConTab.lookup x)
      val width = length constructors

      exception Brk
      fun emitCase prefix (consnum, constructor) =
         let
            val (match, pathvars) = 
               constructorPattern (fn (_, typ) => typ) 
                  ([], ()) constructor
            fun emitSingle (pathvar as (_, typ)) =
               emit (nameOfTree kind typ ^ nameOfVar pathvar ^ " o")
         in
            emit (prefix ^ match ^ " =>")
            ; incr ()
            ; app emitSingle (rev pathvars)
            ; if width = 1 then (emit "(fn x => x)"; raise Brk) else ()
            ; if kind = "unzip" 
              then emit ("DiscMap.unzip (" ^ Int.toString consnum ^ ", " 
                         ^ Int.toString width ^ ")")
              else emit ("DiscMap.sub " ^ Int.toString consnum)
            ; decr ()
         end handle Brk => decr ()

      fun emitCases [] = emit ("   x => abort" ^ Name ^ " x")
        | emitCases [ cons ] = emitCase "   " cons
        | emitCases (cons :: conses) = (emitCases conses; emitCase " | " cons)
   in 
      emit ("and " ^ kind ^ Name ^ " x_ = ")
      ; incr ()
      ; emit ("case " ^ nameOfPrj x ^ "x_ of")
      ; emitCases (rev constructors)
      ; decr ()
      ; emit ""
   end


(* Use the unzip/sub functions to implement maps *)

fun emitMap x = 
   let
      val name = nameOfType x
      val Name = NameOfType x
   in
      emit ("structure Map" ^ Name ^ " = DiscMapFn")
      ; emit ("(struct")
      ; emit ("   type key = " ^ name)
      ; emit ("   val unzip = unzip" ^ Name)
      ; emit ("   val sub = sub" ^ Name)
      ; emit ("end)\n")
   end


(* Emit the equality function (warning: calling polyequal) *)

fun emitEq x = 
   let 
      val name = nameOfType x
      val Name = NameOfType x
   in
      emit ("fun eq" ^ Name ^ " (x: " ^ name ^ ") (y: " ^ name ^ ") = x = y")
   end


(* Emit the signature parts associated with a type *)

fun emitSig x = 
   let
      val name = nameOfType x
      val view = nameOfView x
      val Name = NameOfType x
   in
      emit ("structure Map" ^ Name ^ ": DISC_MAP where type key = " ^ name)
      ; emit ("val str" ^ Name ^ ": " ^ name ^ " -> String.string")
      (* ; emit ("val layout" ^ Name ^ ": " ^ name ^ " -> Layout.t") *)
      ; emit ("val inj" ^ Name ^ ": " ^ view ^ " -> " ^ name)
      ; emit ("val prj" ^ Name ^ ": " ^ name ^ " -> " ^ view)
      ; emit ("val eq" ^ Name ^ ": " ^ name ^ " -> " ^ name ^ " -> bool") 
      ; emitAbortSig x 
      (* ; emit ("structure Set" ^ Name 
              ^ ": ORD_SET where type Key.ord_key = " ^ name)
      ; emit ("structure Map" ^ Name 
              ^ ": ORD_MAP where type Key.ord_key = " ^ name) *)
   end


(* SIGNATURE FOO_TERMS *)

fun termsSig () = 
   let
      val types = TypeTab.list ()
      val encodedTypes = List.filter encoded types
   in 
      emit ("signature " ^ String.map Char.toUpper (getPrefix true "_")
            ^ "TERMS = ")
      ; emit "sig"
      ; incr ()
      ; app (fn x => emit ("type " ^ nameOfType x)) 
           encodedTypes
      ; app (fn x => (emitView false x
                      ; emitSig x 
                      ; emitInjSig x)) 
           encodedTypes
      ; decr ()
      ; emit "end"
   end


(* Structure FooTerms *)

fun terms () = 
   let
      val types = TypeTab.list ()
      val encodedTypes = List.filter encoded types
   in
      emit ("structure " ^ getPrefix true "" ^ "Terms:> " 
              ^ String.map Char.toUpper (getPrefix true "_") ^ "TERMS =")
      ; emit "struct"
      ; incr ()
      ; emit "(* Datatype views *)\n"
      ; emit "datatype fake_ = Fake_ of fake_"
      ; app (fn x => 
               (emitView true x
                ; emit ("and " ^ nameOfType x 
                        ^ " = inj" ^ NameOfType x
                        ^ " of " ^ nameOfView x)))
           encodedTypes
      ; emit "\n"
      ; emit "(* Constructor-specific projections, injections, and aborts *)\n"
      ; app emitPrj encodedTypes
      ; app emitInj encodedTypes
      ; app emitAbort encodedTypes

      ; emit "\n"
      ; emit "(* String encoding functions *)\n"
      ; emit "fun strFake_ (Fake_ x) = strFake_ x"
      ; app emitStr encodedTypes

      ; emit "\n"
      ; emit "(* Equality *)\n"
      ; app emitEq encodedTypes
      ; emit ""
      ; emitMapHeader "sub"

      ; app (emitMapHelper "sub") encodedTypes
      ; emitMapHeader "unzip"
      ; app (emitMapHelper "unzip") encodedTypes

      ; emit ""
      ; emit ("(* Maps *)\n")
      ; app emitMap encodedTypes
      ; decr ()
      ; emit "end\n"
   end

end
*)
