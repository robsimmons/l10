(* An implementation of discrimination trees. My sins are many. *)

structure DiscTree = 
struct

(* Discrimination trees as used in the L10 compiler *)
(* Hopefully this won't wind up write-only; the invariants are
 * complicated. This is basically a hack to get around SML's lack of 
 * polymorphic recursion, which would enforce the shape invariants that
 * we're counting on. *)

fun discCore (deps: SetX.set) =
let
   fun info t = 
      {name = Strings.symbol t
       , ty = Strings.typ t
       , dict = Strings.dict t}
   val deps = map info (SetX.toList deps)
in
[
"structure DiscDict:>",
"sig",
"   type 'a dict",
"   exception NotThere",
"",
"   val empty: 'a dict",
"   val isEmpty: 'a dict -> bool",
"   val inj: 'a -> 'a dict (* Insert data *)",
"   val prj: 'a dict -> 'a (* Expect data, may raise NotThere *)",
"   val sub: int -> 'a dict -> 'a dict ",
"   val subSymbol: Symbol.symbol -> 'a dict -> 'a dict",
"   val subIntInf: IntInf.int -> 'a dict -> 'a dict",
"   val subString: String.string -> 'a dict -> 'a dict"
]
@
List.map 
   (fn {name, ty, ...} =>
       "   val sub" ^ name ^ ": " ^ ty ^ " -> 'a dict -> 'a dict")
   deps
@
[
"",
"   (* Combines the ORD_MAP intersectWith with a fold *)",
"   val intersect: ('a * 'b * 'c -> 'c) -> 'c -> ('a dict * 'b dict) -> 'c",
"",
"   type 'a zipdict ",
"   val id: 'a dict -> 'a zipdict",
"   val unzip: int * int -> 'a zipdict -> 'a zipdict",
"   val unzipSymbol: Symbol.symbol -> 'a zipdict -> 'a zipdict",
"   val unzipIntInf: IntInf.int -> 'a zipdict -> 'a zipdict",
"   val unzipString: String.string -> 'a zipdict -> 'a zipdict"
]
@
List.map 
   (fn {name, ty, ...} =>
       "   val unzip" ^ name ^ ": " ^ ty ^ " -> 'a zipdict -> 'a zipdict")
   deps
@
[
"",
"   val rezip: 'a zipdict -> 'a dict",
"   val replace: 'a zipdict * 'a dict -> 'a zipdict",
"end =",
"struct",
"   exception Invariant",
"",
"   datatype 'a dict' = ",
"      D of 'a ",
"    | D_ of 'a dict' option vector",
"    | DSymbol of 'a dict' SymbolSplayDict.dict",
"    | DIntInf of 'a dict' IntInfSplayDict.dict",
"    | DString of 'a dict' StringSplayDict.dict"
]
@
List.map
   (fn {name, dict, ...} =>
       "    | D" ^ name ^ " of 'a dict' " ^ dict ^ ".dict")
   deps
@
[
"",
"   fun intersect f a (NONE, _) = a",
"     | intersect f a (_, NONE) = a",
"     | intersect f a (SOME m1, SOME m2) = ",
"       case (m1, m2) of ",
"             (D data1, D data2) => f (data1, data2, a)",
"        | (D_ vec1, D_ vec2) => ",
"             if Vector.length vec1 <> Vector.length vec2",
"             then raise Invariant",
"             else Vector.foldri ",
"                (fn (i, d1, a) => ",
"                    intersect f a (d1, Vector.sub (vec2, i)))",
"                a vec1",
"        | (DSymbol dict1, DSymbol dict2) =>",
"             SymbolSplayDict.foldr",
"                (fn (x, d1, a) =>",
"                    intersect f a (SOME d1, SymbolSplayDict.find dict2 x))",
"                a dict1",
"        | (DIntInf dict1, DIntInf dict2) =>",
"             IntInfSplayDict.foldr",
"                (fn (i, d1, a) => ",
"                    intersect f a (SOME d1, IntInfSplayDict.find dict2 i))",
"                a dict1",
"        | (DString dict1, DString dict2) => ",
"             StringSplayDict.foldr",
"                (fn (s, d1, a) => ",
"                    intersect f a (SOME d1, StringSplayDict.find dict2 s))",
"                a dict1"
]
@
List.concat (List.map
   (fn {name, dict, ...} => 
       [
       "        | (D" ^ name ^ " dict1, D" ^ name ^ " dict2) => ",
       "             " ^ dict ^ ".foldr",
       "                (fn (s, d1, a) => ",
       "                    intersect f a (SOME d1, "^dict^".find dict2 s))",
       "                a dict1"
       ])
   deps)
@
[
"        | _ => raise Invariant",
"",
"   type 'a dict = 'a dict' option",
"",
"   datatype 'a zipper = ",
"      Z_ of int * 'a dict vector",
"    | ZSymbol of Symbol.symbol * 'a dict' SymbolSplayDict.dict",
"    | ZIntInf of IntInf.int * 'a dict' IntInfSplayDict.dict",
"    | ZString of String.string * 'a dict' StringSplayDict.dict"
]
@
List.map
   (fn {ty, dict, name} =>
       "    | Z" ^ name ^ " of " ^ ty ^ " * 'a dict' " ^ dict ^ ".dict")
   deps
@
[
"",
"   type 'a zipdict = 'a zipper list * 'a dict",
"",
"   fun id dict = ([], dict)",
"",
"   fun replace ((zipper, _), dict) = (zipper, dict)",
"",
"   val empty = NONE",
"",
"   fun isEmpty NONE = true",
"     | isEmpty _ = false",
"",
"   fun inj x = SOME (D x)",
"",
"   exception NotThere",
"",
"   fun prj NONE = raise NotThere",
"     | prj (SOME (D x)) = x",
"     | prj _ = raise Invariant",
"",
"   fun sub n dict =",
"      case dict of ",
"         NONE => raise NotThere",
"       | SOME (D_ vector) => Vector.sub (vector, n) ",
"       | _ => raise Invariant",
"",
"   fun subSymbol x dict = ",
"      case dict of",
"         NONE => raise NotThere",
"       | SOME (DSymbol dict) => SymbolSplayDict.find dict x",
"       | _ => raise Invariant",
"",
"   fun subIntInf i dict = ",
"      case dict of ",
"         NONE => raise NotThere",
"       | SOME (DIntInf dict) => IntInfSplayDict.find dict i",
"       | _ => raise Invariant",
"",
"   fun subString s dict = ",
"      case dict of",
"         NONE => raise NotThere",
"       | SOME (DString dict) => StringSplayDict.find dict s",
"       | _ => raise Invariant",
""
]
@
List.concat (List.map
   (fn {name, dict, ...} => 
       [
       "   fun sub" ^ name ^ " s dict = ",
       "      case dict of",
       "         NONE => raise NotThere",
       "       | SOME (D" ^ name ^ " dict) => " ^ dict ^ ".find dict s", 
       "       | _ => raise Invariant",
       ""
       ])
   deps)
@
[
"   fun unzip (n, typ) (zipper, dict) = ",
"      case dict of ",
"          NONE => ",
"             (Z_ (n, Vector.tabulate (typ, fn _ => NONE)) :: zipper, NONE)",
"        | SOME (D_ vector) => ",
"             (Z_ (n, vector) :: zipper, Vector.sub (vector, n))",
"        | SOME _ => raise Invariant",
"",
"   fun unzipSymbol x (zipper, dict) = ",
"      case dict of ",
"         NONE =>",
"            (ZSymbol (x, SymbolSplayDict.empty) :: zipper, NONE)",
"       | SOME (DSymbol dict) =>",
"            (ZSymbol (x, dict) :: zipper, SymbolSplayDict.find dict x)",
"       | _ => raise Invariant",
"",
"   fun unzipIntInf i (zipper, dict) = ",
"      case dict of ",
"         NONE =>",
"            (ZIntInf (i, IntInfSplayDict.empty) :: zipper, NONE)",
"       | SOME (DIntInf dict) =>",
"            (ZIntInf (i, dict) :: zipper, IntInfSplayDict.find dict i)",
"       | _ => raise Invariant",
"",
"   fun unzipString s (zipper, dict) = ",
"      case dict of ",
"         NONE => (ZString (s, StringSplayDict.empty) :: zipper, NONE)",
"       | SOME (DString dict) =>",
"            (ZString (s, dict) :: zipper, StringSplayDict.find dict s)",
"       | _ => raise Invariant",
""
]
@
List.concat (List.map
   (fn {name, dict, ...} => 
       [
       "   fun unzip" ^ name ^ " s (zipper, dict) = ",
       "      case dict of ",
       "         NONE => (Z"^name^" (s, "^dict^".empty) :: zipper, NONE)",
       "       | SOME (D" ^ name ^ " dict) =>",
       "            (Z"^name^" (s, dict) :: zipper, "^dict^".find dict s)",
       "       | _ => raise Invariant",
       ""
       ])
   deps)
@
[
"   (* XXX these insertion functions need to be revised if the rezip",
"    * function has the possibility of *deleting* entries *)",
"   fun insertSymbol dict x NONE = dict",
"     | insertSymbol dict x (SOME discdict) =",
"          SymbolSplayDict.insert dict x discdict",
"",
"   fun insertIntInf dict i NONE = dict",
"     | insertIntInf dict i (SOME discdict) =",
"          IntInfSplayDict.insert dict i discdict",
"",
"   fun insertString dict s NONE = dict",
"     | insertString dict s (SOME discdict) =",
"          StringSplayDict.insert dict s discdict",
""
]
@
List.concat (List.map
   (fn {name, dict, ...} => 
       [
       "   fun insert"^name^" dict s NONE = dict",
        "     | insert"^name^" dict s (SOME discdict) =",
       "          "^dict^".insert dict s discdict",
       ""
       ])
   deps  )
@
[
"   fun rezip ([], discdict) = discdict",
"     | rezip (Z_ (n, vector) :: zipper, discdict) = ",
"          rezip (zipper, SOME (D_ (Vector.update (vector, n, discdict))))",
"     | rezip (ZSymbol (x, dict) :: zipper, discdict) = ",
"          rezip (zipper, SOME (DSymbol (insertSymbol dict x discdict)))",
"     | rezip (ZIntInf (i, dict) :: zipper, discdict) = ",
"          rezip (zipper, SOME (DIntInf (insertIntInf dict i discdict)))",
"     | rezip (ZString (s, dict) :: zipper, discdict) = ",
"          rezip (zipper, SOME (DString (insertString dict s discdict)))"
]
@
List.concat (List.map
   (fn {name, dict, ...} => 
       [
       "     | rezip (Z"^name^" (s, dict) :: zipper, discdict) = ",
       "          rezip ",
       "             (zipper",
       "              , SOME (D"^name^" (insert"^name^" dict s discdict)))"
       ])
   deps)
@
[
"end",
"",
"functor DiscDictFn",
"   (P: sig",
"          type t",
"          val unzip: t -> 'a DiscDict.zipdict -> 'a DiscDict.zipdict",
"          val sub: t -> 'a DiscDict.dict -> 'a DiscDict.dict",
"       end):> DICT where type key = P.t =",
"struct",
"   open DiscDict",
"",
"   type key = P.t",
"",
"   exception Absent",
"",
"   type 'a dict = 'a dict",
"",
"   val empty = empty",
"",
"   fun singleton key data =",
"      rezip (replace (P.unzip key (id empty), inj data))",
"",
"   fun insert dict key data = ",
"      rezip (replace (P.unzip key (id dict), inj data))",
"",
"   fun find dict key = SOME (prj (P.sub key dict))",
"      handle NotThere => NONE",
"",
"   fun lookup dict key = prj (P.sub key dict)",
"      handle NotThere => raise Absent",
"",
"   exception NotImpl",
"   val union = fn _ => raise NotImpl",
"   val operate = fn _ => raise NotImpl",
"   val insertMerge = fn _ => raise NotImpl",
"   val isEmpty = fn _ => raise NotImpl",
"   val member = fn _ => raise NotImpl",
"   val size = fn _ => raise NotImpl",
"   val toList = fn _ => raise NotImpl",
"   val domain = fn _ => raise NotImpl",
"   val map = fn _ => raise NotImpl",
"   val foldl = fn _ => raise NotImpl",
"   val foldr = fn _ => raise NotImpl",
"   val app = fn _ => raise NotImpl",
"   val remove = fn _ => raise NotImpl",
"end"
]
end

(*
"",
"signature DISC_PATHS = sig",
"   type key",
"   val unzip: key -> 'a DiscDict.zipdict -> 'a DiscDict.zipdict",
"   val sub: key -> 'a DiscDict.dict -> 'a DiscDict.dict",
"end",
"",
"signature DISC_DICT = sig",
"   type key ",
"   type 'a dict",
"   val empty: 'a dict",
"   val singleton: key * 'a -> 'a dict ",
"   val insert: 'a dict * key * 'a -> 'a dict",
"   val insert': (key * 'a) * 'a dict -> 'a dict",
"   val find: 'a dict * key -> 'a option",
"   val lookup: 'a dict * key -> 'a",
"end",
]
*)

end
