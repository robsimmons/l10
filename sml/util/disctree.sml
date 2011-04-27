(* Discrimination trees as used in the L10 compiler *)
(* Robert J. Simmons *)

(* Hopefully this won't wind up write-only; the invariants are complicated.
 * This is basically a hack to get around SML's lack of polymorphic recursion,
 * which would enforce the shape invariants that we're counting on. *)

structure DiscMap:> sig
   type 'a map 
   val empty: 'a map
   val isEmpty: 'a map -> bool
   val inj: 'a -> 'a map (* Insert data *)
   val prj: 'a map -> 'a (* Expect data *)

   exception NotThere
   val sub: int -> 'a map -> 'a map 
   val subX: Symbol.symbol -> 'a map -> 'a map
   val subII: IntInf.int -> 'a map -> 'a map
   val subS: String.string -> 'a map -> 'a map

   type 'a zipmap 
   val id: 'a map -> 'a zipmap
   val unzip: int * int -> 'a zipmap -> 'a zipmap
   val unzipX: Symbol.symbol -> 'a zipmap -> 'a zipmap
   val unzipII: IntInf.int -> 'a zipmap -> 'a zipmap
   val unzipS: String.string -> 'a zipmap -> 'a zipmap

   val rezip: 'a zipmap -> 'a map
   val replace: 'a zipmap * 'a map -> 'a zipmap
end = 
struct
   datatype 'a map' = 
      D of 'a 
    | M of 'a map' option vector
    | MX of 'a map' MapX.map
    | MII of 'a map' MapII.map
    | MS of 'a map' MapS.map

   type 'a map = 'a map' option

   datatype 'a zipper = 
      Z of int * 'a map vector
    | ZX of Symbol.symbol * 'a map' MapX.map
    | ZII of IntInf.int * 'a map' MapII.map
    | ZS of String.string * 'a map' MapS.map

   type 'a zipmap = 'a zipper list * 'a map

   fun id map = ([], map)

   fun replace ((zipper, _), map) = (zipper, map)

   val empty = NONE

   fun isEmpty NONE = true
     | isEmpty _ = false

   fun inj x = SOME (D x)

   fun prj (SOME (D x)) = x
     | prj _ = raise Fail "Invariant"

   exception NotThere

   (* XXX Uses Unsafe.Vector.sub *)
   fun sub n map =
      case map of 
         NONE => raise NotThere
       | SOME (M vector) => Unsafe.Vector.sub (vector, n) 
       | _ => raise Fail "Invariant"

   fun subX x map = 
      case map of
         NONE => raise NotThere
       | SOME (MX map) => MapX.find (map, x)
       | _ => raise Fail "Invariant"

   fun subII i map = 
      case map of 
         NONE => raise NotThere
       | SOME (MII map) => MapII.find (map, i)
       | _ => raise Fail "Invariant"

   fun subS s map = 
      case map of
         NONE => raise NotThere
       | SOME (MS map) => MapS.find (map, s)
       | _ => raise Fail "Invariant"

   (* XXX Uses Unsafe.Vector.sub *)
   fun unzip (n, typ) (zipper, map) = 
      case map of 
          NONE => (Z (n, Vector.tabulate (typ, fn _ => NONE)) :: zipper, NONE)
        | SOME (M vector) => 
          (Z (n, vector) :: zipper, Unsafe.Vector.sub (vector, n))
        | SOME _ => raise Fail "Invariant"

   fun unzipX x (zipper, map) = 
      case map of 
         NONE => (ZX (x, MapX.empty) :: zipper, NONE)
       | SOME (MX map) =>
         (ZX (x, map) :: zipper, MapX.find (map, x))
       | _ => raise Fail "Invariant"

   fun unzipII i (zipper, map) = 
      case map of 
         NONE => (ZII (i, MapII.empty) :: zipper, NONE)
       | SOME (MII map) =>
         (ZII (i, map) :: zipper, MapII.find (map, i))
       | _ => raise Fail "Invariant"

   fun unzipS s (zipper, map) = 
      case map of 
         NONE => (ZS (s, MapS.empty) :: zipper, NONE)
       | SOME (MS map) =>
         (ZS (s, map) :: zipper, MapS.find (map, s))
       | _ => raise Fail "Invariant"

   (* XXX these insertion functions need to be revised if the rezip function 
    * has the possibility of *deleting* entries *)
   fun insertX (map, x, NONE) = map
     | insertX (map, x, SOME discmap) = MapX.insert (map, x, discmap)

   fun insertII (map, i, NONE) = map
     | insertII (map, i, SOME discmap) = MapII.insert (map, i, discmap)

   fun insertS (map, s, NONE) = map
     | insertS (map, s, SOME discmap) = MapS.insert (map, s, discmap)

   fun rezip ([], discmap) = discmap
     | rezip (Z (n, vector) :: zipper, discmap) = 
       rezip (zipper, SOME (M (Vector.update (vector, n, discmap))))
     | rezip (ZX (x, map) :: zipper, discmap) = 
       rezip (zipper, SOME (MX (insertX (map, x, discmap))))
     | rezip (ZII (i, map) :: zipper, discmap) = 
       rezip (zipper, SOME (MII (insertII (map, i, discmap))))
     | rezip (ZS (s, map) :: zipper, discmap) = 
       rezip (zipper, SOME (MS (insertS (map, s, discmap))))
end

signature DISC_PATHS = sig
   type key
   val unzip: key -> 'a DiscMap.zipmap -> 'a DiscMap.zipmap
   val sub: key -> 'a DiscMap.map -> 'a DiscMap.map
end

signature DISC_MAP = sig
   type key 
   type 'a map
   val empty: 'a map
   val singleton: key * 'a -> 'a map 
   val insert: 'a map * key * 'a -> 'a map
   val insert': (key * 'a) * 'a map -> 'a map
   val find: 'a map * key -> 'a option
   val lookup: 'a map * key -> 'a
end

(* Leaves the implementation explosed *)
functor DiscMapImplFn (P: DISC_PATHS) =
struct
   open DiscMap

   type key = P.key
  
   type 'a map = 'a map

   val empty = empty

   fun singleton (key, data) =
      rezip (replace (P.unzip key (id empty), inj data))

   fun insert (map, key, data) = 
      rezip (replace (P.unzip key (id map), inj data))

   fun insert' ((key, data), map) = 
      rezip (replace (P.unzip key (id map), inj data))

   fun find (map, key) = SOME (prj (P.sub key map))
      handle NotThere => NONE

   fun lookup (map, key) = prj (P.sub key map)
end

(* Appropriately hides the implementation *)
functor DiscMapFn (P: DISC_PATHS):> DISC_MAP where type key = P.key =
struct
   structure DiscMap = DiscMapImplFn(P)
   open DiscMap
end
