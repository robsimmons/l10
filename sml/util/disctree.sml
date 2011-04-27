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

   type 'a zipmap 
   val id: 'a map -> 'a zipmap
   val unzip: int * int -> 'a zipmap -> 'a zipmap
   val rezip: 'a zipmap -> 'a map
   val replace: 'a zipmap * 'a map -> 'a zipmap
end = 
struct
   datatype 'a map' = 
      D of 'a 
    | M of 'a map' option vector

   type 'a map = 'a map' option

   type 'a zipper = (int * 'a map vector) list

   type 'a zipmap = 'a zipper * 'a map

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
       | SOME (D _) => raise Fail "Invariant"
       | SOME (M vector) => Unsafe.Vector.sub (vector, n) 

   (* XXX Uses Unsafe.Vector.sub *)
   fun unzip (n, typ) (zipper, map) = 
      case map of 
          NONE => ((n, Vector.tabulate (typ, fn _ => NONE)) :: zipper, NONE)
        | SOME (D _) => raise Fail "Invariant"
        | SOME (M vector) => 
          ((n, vector) :: zipper, Unsafe.Vector.sub (vector, n))

   fun rezip ([], tree) = tree
     | rezip (((n, vector) :: zipper) : 'a zipper, tree) = 
       rezip (zipper, SOME (M (Vector.update (vector, n, tree))))
end

signature DISC_PATHS = sig
   type key
   val makePath: key -> 'a DiscMap.zipmap -> 'a DiscMap.zipmap
   val followPath: key -> 'a DiscMap.map -> 'a DiscMap.map
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

functor DiscMapFn (P: DISC_PATHS):> DISC_MAP where type key = P.key =
struct
   open DiscMap

   type key = P.key
  
   type 'a map = 'a map

   val empty = empty

   fun singleton (key, data) =
      rezip (replace (P.makePath key (id empty), inj data))

   fun insert (map, key, data) = 
      rezip (replace (P.makePath key (id map), inj data))

   fun insert' ((key, data), map) = 
      rezip (replace (P.makePath key (id map), inj data))

   fun find (map, key) = SOME (prj (P.followPath key map))
      handle NotThere => NONE

   fun lookup (map, key) = prj (P.followPath key map)
end
