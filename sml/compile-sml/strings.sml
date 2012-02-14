structure Strings:> 
sig
   (* Get the name of the type *)
   val typ: Type.t -> string

   (* Given and a string representing an SML expression of that type, mediate
    * between the type and the standard view of that type. *)
   val prj: Type.t -> string -> string (* prj: type -> view *)
   val inj: Type.t -> string -> string (* inj: view -> type *)

   (* Given a constructor, return the pattern destructor (a view). *)
   (* Given a constructor, return the pattern constructor (an injection). *)
   val pattern: Symbol.symbol -> string
   val builder: Symbol.symbol -> string 

   (* Gives a string comparing two things for equality *)
   val eq: Type.t -> string -> string -> string
   val eqpath: Type.t * Path.t * Path.t -> string

   (* Gives a toString function *)
   val str: Type.t -> string -> string

   (* Names the dictionary for this type *)
   val dict: Type.t -> string 

   (* Create a tuple: optTuple emits nothing on unit *)
   val tuple: string list -> string
   val optTuple: string list -> string

   (* Outputs a first-letter-capitalized version of the symbol *)
   val symbol: Symbol.symbol -> string

   (*[ val build: Term.term_t -> string
                & Term.shape -> string ]*)
   val build: Term.t -> string

   (*[ val match: Term.term_t -> string
                & Term.shape -> string ]*)
   val match: Term.t -> string
end =
struct

fun embiggen x = 
let 
   val s = Symbol.toValue x
   val len = size s
   val fst = if len = 0 then raise Domain else String.sub (s, 0)
   val rest = String.substring (s, 1, len - 1)
in
   if not (Char.isLower fst) 
   then raise Fail ("Function 'embiggen' called on string `"^s^"' with " 
                    ^ "first character '" ^ str fst ^ "'") 
   else str (Char.toUpper fst) ^ rest
end

val symbol = embiggen

fun typ t = 
   case Tab.lookup Tab.types t of
      Class.Type => embiggen t ^ ".t"
    | Class.Extensible => "Symbol.symbol"
    | Class.Builtin =>
         if Symbol.eq (t, Type.nat)
         then "IntInf.int"
         else if Symbol.eq (t, Type.string)
         then "String.string"
         else raise Fail ("Dunno about builtin `" ^ Symbol.toValue t ^ "`")

fun dict t = 
   case Tab.lookup Tab.types t of
      Class.Type => embiggen t ^ ".Dict"
    | Class.Extensible => "SymbolSplayDict"
    | Class.Builtin =>
         if Symbol.eq (t, Type.nat)
         then "IntInfSplayDict"
         else if Symbol.eq (t, Type.string)
         then "StringSplayDict"
         else raise Fail ("Dunno about builtin `" ^ Symbol.toValue t ^ "`")

fun prjOrInj which t s = 
   case Tab.lookup Tab.types t of 
      Class.Type => 
        (case Tab.find Tab.representations t of 
            SOME Type.Transparent => s 
          | SOME Type.HashConsed => raise Fail "Don't know how to hashcons yet"
          | SOME Type.External => s
          | SOME Type.Sealed =>
              "(" ^ embiggen t ^ "." ^ which ^ " " ^ s ^ ")"
          | NONE =>
              "(" ^ embiggen t ^ "." ^ which ^ " " ^ s ^ ")")
    | Class.Extensible => (* ugh *)
         if which = "inj" 
         then "(Symbol.toValue " ^ s ^ ")"
         else "(Symbol.fromValue " ^ s ^ ")"
    | Class.Builtin => s 

val prj = prjOrInj "prj"
val inj = prjOrInj "inj"

fun patternOrBuilder isBuilder c = 
let 
   val t = Class.base (Tab.lookup Tab.consts c)
   fun base () = embiggen t ^ "." ^ embiggen c
in
   case Tab.lookup Tab.types t of
      Class.Type =>
        (case Tab.find Tab.representations t of 
            SOME Type.Transparent => base()
          | SOME Type.HashConsed => raise Fail "Don't know how to hashcons yet"
          | SOME Type.External => base()
          | SOME Type.Sealed => base() ^ (if isBuilder then "'" else "")
          | NONE => base() ^ (if isBuilder then "'" else ""))
    | Class.Extensible => 
         if isBuilder 
         then "(Symbol.fromValue \"" ^ Symbol.toValue c ^ "\")" 
         else "\"" ^ Symbol.toValue c ^ "\""
    | Class.Builtin => 
         if not isBuilder 
         then raise Fail ("Builtin pattern `" ^ Symbol.toValue c ^ "`?") 
         else if Symbol.eq (Term.plus, c) then "IntInf.+"
         else raise Fail ("Builtin builder `" ^ Symbol.toValue c ^ "`?") 
end

val pattern = patternOrBuilder false
val builder = patternOrBuilder true

fun eq t thing1 thing2 =
   case Tab.lookup Tab.types t of
      Class.Type => "(" ^ embiggen t ^ ".eq (" ^ thing1 ^ ", " ^ thing2 ^ "))"
    | Class.Extensible => "(Symbol.eq (" ^ thing1 ^ ", " ^ thing2 ^ "))"
    | Class.Builtin => 
         if Symbol.eq (t, Type.nat)
         then "(EQUAL = IntInf.compare (" ^ thing1 ^ ", " ^ thing2 ^ "))"
         else if Symbol.eq (t, Type.string)
         then "(EQUAL = String.compare (" ^ thing1 ^ ", " ^ thing2 ^ "))"
         else raise Fail ("Dunno about builtin `" ^ Symbol.toValue t ^ "`")
fun eqpath (t, path1, path2) = eq t (Path.toVar path1) (Path.toVar path2)

fun str t thing = 
   case Tab.lookup Tab.types t of
      Class.Type => "(" ^ embiggen t ^ ".toString " ^ thing ^ ")"
    | Class.Extensible => "(Symbol.toValue " ^ thing ^ ")"
    | Class.Builtin => 
         if Symbol.eq (t, Type.nat)
         then "(IntInf.toString " ^ thing ^ ")"
         else if Symbol.eq (t, Type.string)
         then "(\"\\\"\" ^ " ^ thing ^ " ^ \"\\\"\")"
         else raise Fail ("Dunno about builtin `" ^ Symbol.toValue t ^ "`")

fun tuple [ x ] = x
  | tuple xs = "(" ^ String.concatWith ", " xs ^ ")"

fun optTuple [] = ""
  | optTuple xs = " " ^ tuple xs

(*[ val build: Term.term_t -> string
             & Term.shape -> string ]*)
fun build t = 
   case t of 
      Term.SymConst c => builder c
    | Term.NatConst i => IntInf.toString i
    | Term.StrConst s => "\"" ^ s ^ "\""
    | Term.Root (f, ts) => 
         "(" ^ builder f ^ " "
         ^ tuple (map build ts) ^ ")"
    | Term.Var (NONE, _) => "_"
    | Term.Var (SOME x, _) => Symbol.toValue x
    | Term.Path (path, _) => Path.toVar path

(*[ val match: Term.term_t -> string
             & Term.shape -> string ]*)
fun match t = 
   case t of 
      Term.SymConst c => pattern c 
    | Term.NatConst i => IntInf.toString i
    | Term.StrConst s => "\"" ^ s ^ "\""
    | Term.Root (f, ts) => pattern f ^ " " ^ tuple (map build ts)
    | Term.Var (NONE, _) => "_"
    | Term.Var (SOME x, _) => Symbol.toValue x
    | Term.Path (path, _) => Path.toVar path
end
