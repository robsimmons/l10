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
"   val sub: int -> 'a dict -> 'a dict "
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
"   val unzip: int * int -> 'a zipdict -> 'a zipdict"
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
"    | D_ of 'a dict' option vector"
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
"                a vec1"
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
"      Z_ of int * 'a dict vector"
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
"          rezip (zipper, SOME (D_ (Vector.update (vector, n, discdict))))"
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
"functor DiscDictFun",
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
"   fun insertMerge dict key default modify =",
"      insert dict key",
"         (modify (prj (P.sub key dict))",
"             handle NotThere => default)",
"",
"   fun member dict key = (ignore (prj (P.sub key dict)); true)",
"      handle NotThere => false",
"",
"   exception NotImpl",
"   val union = fn _ => raise NotImpl",
"   val operate = fn _ => raise NotImpl",
"   val isEmpty = fn _ => raise NotImpl",
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
