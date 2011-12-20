(* Copyright (C) 2011 Robert J. Simmons *)

structure Datatypes:>
sig
   type subterm = {t: Type.t, ts: string, mutual: bool, n: int}
   datatype t =
      DT of 
       { ts: string 
       , tS: string
       , arms: (Symbol.symbol * string * int * subterm list) list
       , rep: Type.representation}
   val dtype: Type.t -> t
   val emit: unit -> unit
end =
struct

open Util

(* A representation of the initial datatype *)
type subterm = {t: Type.t, ts: string, mutual: bool, n: int}
datatype t =
   DT of 
    { ts: string 
    , tS: string
    , arms: (Symbol.symbol * string * int * subterm list) list
    , rep: Type.representation}
fun makeDatatype mutually_defined (t, rep) = 
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
           , ((c, Strings.symbol c, n, subterms (Tab.lookup Tab.consts c) 0 []) 
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
      (fn (str', (_, constructor, _, [])) => emit [str' ^ constructor]
        | (str', (_, constructor, _, subterms)) =>
             emit [str' ^ constructor ^ " of " 
                   ^ String.concatWith " * " (map typ subterms)])
      ("  ", "| ")
      arms
 ; if isPrj rep 
   then emit ["and t_" ^ ts ^ " = inj_" ^ ts ^ " of view_" ^ ts, ""]
   else emit [""])
end 
handle Skip => (emit ["datatype t_" ^ ts ^ " = datatype " ^ tS ^ ".t", ""])



(* Helper functions *)
(* These functions all have similar structure, it would be nice to reduce 
   the cutpasteness between them. *)

(* EQUALITY *)
fun emitEq (isAnd, (t, DT {ts, tS, arms, rep})) =
let
   fun emitCase pre post (_, c, _, (xs: subterm list)) =
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

(* TO STRING *)
fun emitStr (isAnd, (t, DT {ts, tS, arms, rep})) = 
let
   fun emitCase pre post (_, c, _, (xs: subterm list)) =
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

(* ZIP/UNZIP *)
fun emitZip isUn (isAnd, (t, DT {ts, tS, arms, rep})) = 
let
   val sub = if isUn then "unzip" else "sub"
   val len = Int.toString (length arms)
   fun emitCase pre post (_, c, ndx, (xs: subterm list)) =
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
    ; emit ["  type t = L10_Terms.t_" ^ ts]
    ; emit ["  val sub = L10_Terms.sub_" ^ ts]
    ; emit ["  val unzip = L10_Terms.unzip_" ^ ts, "end)"]
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
              (fn (_, cstr, _, []) => 
                     emit ["val " ^ cstr ^ "': t = inj " ^ cstr]
                | (_, cstr, _, _) => 
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
fun partition_types (): ((Type.t * t) list * SetX.set) list = 
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

   fun dependency (dtypes: (Type.t * t) list) = 
   let 
      val defs = 
         foldr (fn ((t, _), set) => SetX.insert set t) SetX.empty dtypes
      val uses = 
         foldr (fn ((_, DT {arms, ...}), set) =>
                   foldr (fn ((_, _, _, subterms), set) => 
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
   exception Skip

   fun body ((dtypes, dependencies): ((Type.t * t) list * SetX.set)) = 
   let in
    ( appSuper (fn () => (emit ["(* Empty set of datatypes *)"]; raise Skip)) 
         (fn (t, _) => emit ["(* Datatypes for " ^ Symbol.toValue t ^ " *)"])
         ((fn (t, _) => emit ["(* Datatypes for " ^ Symbol.toValue t]),
          (fn (t, _) => emit ["                 " ^ Symbol.toValue t]),
          (fn (t, _) => emit ["                 " ^ Symbol.toValue t ^ " *)"]))
      dtypes
    ; emit ["", "(* Part 1/3: Specialized discrimination tree structure *)", ""]
    ; emit (DiscTree.discCore dependencies)
    ; emit ["", "(* Part 2/3: Implementation (permits mutual recursion) *)", ""]
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
    ; emit ["", "(* Part 3/3: Exposed interfaces *)", ""]
    ; app emitDatastructure dtypes)
   end handle Skip => ()
in
 ( emit ["","(* L10 Generated Terms (datatypes.sml) *)", ""]
 ; app body datatypes
 ; emit ["structure L10_Terms = struct end (* Protect *)"]
 ; emit ["structure DiscDict = struct end (* Protect *)"]
 ; emit ["structure DiscDictFun = struct end (* Protect *)"]
)
end

fun emit () = terms ()

end

