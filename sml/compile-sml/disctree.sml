(* An implementation of discrimination trees. My sins are many. *)

structure DiscTree = 
struct

val s = 
"   (* Discrimination trees as used in the L10 compiler *)\
\\n\
\   (* Hopefully this won't wind up write-only; the invariants are\n\
\    * complicated. This is basically a hack to get around SML's lack of \n\
\    * polymorphic recursion, which would enforce the shape invariants that\n\
\    * we're counting on. *)  \n\
\\n\
\   structure DiscMap:> sig\n\
\      type 'a map \n\
\      exception NotThere\n\
\\n\
\      val empty: 'a map\n\
\      val isEmpty: 'a map -> bool\n\
\      val inj: 'a -> 'a map (* Insert data *)\n\
\      val prj: 'a map -> 'a (* Expect data, may raise NotThere *)\n\
\      val sub: int -> 'a map -> 'a map \n\
\      val subX: Symbol.symbol -> 'a map -> 'a map\n\
\      val subII: IntInf.int -> 'a map -> 'a map\n\
\      val subS: String.string -> 'a map -> 'a map\n\
\\n\
\      (* Combines the ORD_MAP intersectWith with a fold *)\n\
\      val intersect: ('a * 'b * 'c -> 'c) -> 'c -> ('a map * 'b map) -> 'c\n\
\\n\
\      type 'a zipmap \n\
\      val id: 'a map -> 'a zipmap\n\
\      val unzip: int * int -> 'a zipmap -> 'a zipmap\n\
\      val unzipX: Symbol.symbol -> 'a zipmap -> 'a zipmap\n\
\      val unzipII: IntInf.int -> 'a zipmap -> 'a zipmap\n\
\      val unzipS: String.string -> 'a zipmap -> 'a zipmap\n\
\\n\
\      val rezip: 'a zipmap -> 'a map\n\
\      val replace: 'a zipmap * 'a map -> 'a zipmap\n\
\   end = \n\
\   struct\n\
\      exception Invariant\n\
\\n\
\      datatype 'a map' = \n\
\         D of 'a \n\
\       | M of 'a map' option vector\n\
\       | MX of 'a map' MapX.map\n\
\       | MII of 'a map' MapII.map\n\
\       | MS of 'a map' MapS.map\n\
\\n\
\      fun intersect f a (NONE, _) = a\n\
\        | intersect f a (_, NONE) = a\n\
\        | intersect f a (SOME m1, SOME m2) = \n\
\          case (m1, m2) of \n\
\             (D data1, D data2) => f (data1, data2, a)\n\
\           | (M vec1, M vec2) => \n\
\             if Vector.length vec1 <> Vector.length vec2\n\
\             then raise Invariant\n\
\             else Vector.foldri \n\
\                (fn (i, map1, a) => \n\
\                   intersect f a (map1, Vector.sub (vec2, i)))\n\
\                a vec1\n\
\           | (MX map1, MX map2) =>\n\
\             MapX.foldri\n\
\                (fn (x, m1, a) =>\n\
\                   intersect f a (SOME m1, MapX.find (map2, x)))\n\
\                a map1\n\
\           | (MII map1, MII map2) =>\n\
\             MapII.foldri\n\
\                (fn (i, m1, a) => \n\
\                   intersect f a (SOME m1, MapII.find (map2, i)))\n\
\                a map1\n\
\           | (MS map1, MS map2) => \n\
\             MapS.foldri\n\
\                (fn (s, m1, a) => \n\
\                   intersect f a (SOME m1, MapS.find (map2, s)))\n\
\                a map1\n\
\           | _ => raise Invariant\n\
\\n\
\      type 'a map = 'a map' option\n\
\\n\
\      datatype 'a zipper = \n\
\         Z of int * 'a map vector\n\
\       | ZX of Symbol.symbol * 'a map' MapX.map\n\
\       | ZII of IntInf.int * 'a map' MapII.map\n\
\       | ZS of String.string * 'a map' MapS.map\n\
\\n\
\      type 'a zipmap = 'a zipper list * 'a map\n\
\\n\
\      fun id map = ([], map)\n\
\\n\
\      fun replace ((zipper, _), map) = (zipper, map)\n\
\\n\
\      val empty = NONE\n\
\\n\
\      fun isEmpty NONE = true\n\
\        | isEmpty _ = false\n\
\\n\
\      fun inj x = SOME (D x)\n\
\\n\
\      exception NotThere\n\
\\n\
\      fun prj NONE = raise NotThere\n\
\        | prj (SOME (D x)) = x\n\
\        | prj _ = raise Invariant\n\
\\n\
\      (* XXX Uses Unsafe.Vector.sub *)\n\
\      fun sub n map =\n\
\         case map of \n\
\            NONE => raise NotThere\n\
\          | SOME (M vector) => Vector.sub (vector, n) \n\
\          | _ => raise Invariant\n\
\\n\
\      fun subX x map = \n\
\         case map of\n\
\            NONE => raise NotThere\n\
\          | SOME (MX map) => MapX.find (map, x)\n\
\          | _ => raise Invariant\n\
\\n\
\      fun subII i map = \n\
\         case map of \n\
\            NONE => raise NotThere\n\
\          | SOME (MII map) => MapII.find (map, i)\n\
\          | _ => raise Invariant\n\
\\n\
\      fun subS s map = \n\
\         case map of\n\
\            NONE => raise NotThere\n\
\          | SOME (MS map) => MapS.find (map, s)\n\
\          | _ => raise Invariant\n\
\\n\
\      (* XXX Uses Unsafe.Vector.sub *)\n\
\      fun unzip (n, typ) (zipper, map) = \n\
\         case map of \n\
\             NONE => \n\
\             (Z (n, Vector.tabulate (typ, fn _ => NONE)) :: zipper, NONE)\n\
\           | SOME (M vector) => \n\
\             (Z (n, vector) :: zipper, Vector.sub (vector, n))\n\
\           | SOME _ => raise Invariant\n\
\\n\
\      fun unzipX x (zipper, map) = \n\
\         case map of \n\
\            NONE => (ZX (x, MapX.empty) :: zipper, NONE)\n\
\          | SOME (MX map) =>\n\
\            (ZX (x, map) :: zipper, MapX.find (map, x))\n\
\          | _ => raise Invariant\n\
\\n\
\      fun unzipII i (zipper, map) = \n\
\         case map of \n\
\            NONE => (ZII (i, MapII.empty) :: zipper, NONE)\n\
\          | SOME (MII map) =>\n\
\            (ZII (i, map) :: zipper, MapII.find (map, i))\n\
\          | _ => raise Invariant\n\
\\n\
\      fun unzipS s (zipper, map) = \n\
\         case map of \n\
\            NONE => (ZS (s, MapS.empty) :: zipper, NONE)\n\
\          | SOME (MS map) =>\n\
\            (ZS (s, map) :: zipper, MapS.find (map, s))\n\
\          | _ => raise Invariant\n\
\\n\
\      (* XXX these insertion functions need to be revised if the rezip\n\
\       * function has the possibility of *deleting* entries *)\n\
\      fun insertX (map, x, NONE) = map\n\
\        | insertX (map, x, SOME discmap) = MapX.insert (map, x, discmap)\n\
\\n\
\      fun insertII (map, i, NONE) = map\n\
\        | insertII (map, i, SOME discmap) = MapII.insert (map, i, discmap)\n\
\\n\
\      fun insertS (map, s, NONE) = map\n\
\        | insertS (map, s, SOME discmap) = MapS.insert (map, s, discmap)\n\
\\n\
\      fun rezip ([], discmap) = discmap\n\
\        | rezip (Z (n, vector) :: zipper, discmap) = \n\
\          rezip (zipper, SOME (M (Vector.update (vector, n, discmap))))\n\
\        | rezip (ZX (x, map) :: zipper, discmap) = \n\
\          rezip (zipper, SOME (MX (insertX (map, x, discmap))))\n\
\        | rezip (ZII (i, map) :: zipper, discmap) = \n\
\          rezip (zipper, SOME (MII (insertII (map, i, discmap))))\n\
\        | rezip (ZS (s, map) :: zipper, discmap) = \n\
\          rezip (zipper, SOME (MS (insertS (map, s, discmap))))\n\
\   end\n\
\\n\
\   signature DISC_PATHS = sig\n\
\      type key\n\
\      val unzip: key -> 'a DiscMap.zipmap -> 'a DiscMap.zipmap\n\
\      val sub: key -> 'a DiscMap.map -> 'a DiscMap.map\n\
\   end\n\
\\n\
\   signature DISC_MAP = sig\n\
\      type key \n\
\      type 'a map\n\
\      val empty: 'a map\n\
\      val singleton: key * 'a -> 'a map \n\
\      val insert: 'a map * key * 'a -> 'a map\n\
\      val insert': (key * 'a) * 'a map -> 'a map\n\
\      val find: 'a map * key -> 'a option\n\
\      val lookup: 'a map * key -> 'a\n\
\   end\n\
\\n\
\   (* Leaves the implementation exposed *)\n\
\   functor DiscMapImplFn (P: DISC_PATHS) =\n\
\   struct\n\
\      open DiscMap\n\
\\n\
\      type key = P.key\n\
\\n\
\      type 'a map = 'a map\n\
\\n\
\      val empty = empty\n\
\\n\
\      fun singleton (key, data) =\n\
\         rezip (replace (P.unzip key (id empty), inj data))\n\
\\n\
\      fun insert (map, key, data) = \n\
\         rezip (replace (P.unzip key (id map), inj data))\n\
\\n\
\      fun insert' ((key, data), map) = \n\
\         rezip (replace (P.unzip key (id map), inj data))\n\
\\n\
\      fun find (map, key) = SOME (prj (P.sub key map))\n\
\         handle NotThere => NONE\n\
\\n\
\      fun lookup (map, key) = prj (P.sub key map)\n\
\   end\n"

end
