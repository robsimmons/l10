(***** hash-inc.sml *****)

signature HASH_INCREMENT =
   sig

      val hashInc : Word.word -> Word.word -> Word.word

   end




(***** hash-inc.sml *****)

structure JenkinsHash :> HASH_INCREMENT
   =
   struct

      (* Jenkins hash function *)

      fun hashInc hash datum =
          let
             val hash = Word.+ (hash, datum)
             val hash = Word.+ (hash, Word.<< (hash, 0w10))
             val hash = Word.xorb (hash, Word.>> (hash, 0w6))
          in
             hash
          end

   end


(* A non-commutative variant of the Jenkins hash. *)
structure MJHash :> HASH_INCREMENT
   =
   struct

      fun hashInc hash datum =
          let
             val hash = Word.+ (hash, Word.<< (hash, 0w10))
             val hash = Word.xorb (hash, Word.>> (hash, 0w6))
             val hash = Word.+ (hash, datum)
          in
             hash
          end

   end




(***** ordered.sml *****)

signature ORDERED =
   sig
      type t
         
      val eq : t * t -> bool
      val compare : t * t -> order
   end




(***** ordered.sml (partial) *****)

structure IntInfOrdered
   :> ORDERED where type t = IntInf.int
   =
   struct
      type t = IntInf.int
      
      val eq : IntInf.int * IntInf.int -> bool = (op =)  
      val compare = IntInf.compare
   end


structure StringOrdered
   :> ORDERED where type t = string
   =
   struct
      type t = string

      val eq : string * string -> bool = op =
      val compare = String.compare
   end




(***** red-black-tree.sml *****)

structure RedBlackTree =
   struct

      datatype color = RED | BLACK

      datatype 'a tree =
         Leaf
       | Node of color * 'a * 'a tree * 'a tree

      datatype 'a zipelem =
         LEFT of color * 'a * 'a tree
       | RIGHT of color * 'a * 'a tree
         
      fun zip tree zipper =
         (case zipper of
             [] => tree
           | LEFT (color, label, right) :: rest =>
                zip (Node (color, label, tree, right)) rest
           | RIGHT (color, label, left) :: rest =>
                zip (Node (color, label, left, tree)) rest)


      (* Precondition:
         (zip (Node (RED, label, left, right) zipper) satisfies the black-height
         invariant, but possibly not the red-black invariant.
      *)
      fun zipRed (label, left, right) zipper =
         (case zipper of
             [] =>
                Node (BLACK, label, left, right)

           | LEFT (BLACK, label1, right1) :: rest =>
                zip
                   (Node (BLACK, label1,
                          Node (RED, label, left, right),
                          right1))
                   rest

           | RIGHT (BLACK, label1, left1) :: rest =>
                zip
                   (Node (BLACK, label1,
                          left1,
                          Node (RED, label, left, right)))
                   rest

           | LEFT (RED, label1, right1) ::
             LEFT (_ (* BLACK *), label2, Node (RED, label3, left3, right3)) :: rest =>
                (* Grandparent is BLACK, by red-black invariant. *)
                zipRed
                   (label2,
                    Node (BLACK, label1,
                          Node (RED, label, left, right),
                          right1),
                    Node (BLACK, label3, left3, right3))
                   rest

           | LEFT (RED, label1, right1) ::
             RIGHT (_ (* BLACK *), label2, Node (RED, label3, left3, right3)) :: rest =>
                (* Grandparent is BLACK, by red-black invariant. *)
                zipRed
                   (label2,
                    Node (BLACK, label3, left3, right3),
                    Node (BLACK, label1,
                          Node (RED, label, left, right),
                          right1))
                   rest

           | RIGHT (RED, label1, left1) ::
             LEFT (_ (* BLACK *), label2, Node (RED, label3, left3, right3)) :: rest =>
                (* Grandparent is BLACK, by red-black invariant. *)
                zipRed
                   (label2,
                    Node (BLACK, label1,
                          left1,
                          Node (RED, label, left, right)),
                    Node (BLACK, label3, left3, right3))
                   rest

           | RIGHT (RED, label1, left1) ::
             RIGHT (_ (* BLACK *), label2, Node (RED, label3, left3, right3)) :: rest =>
                (* Grandparent is BLACK, by red-black invariant. *)
                zipRed
                   (label2,
                    Node (BLACK, label3, left3, right3),
                    Node (BLACK, label1,
                          left1,
                          Node (RED, label, left, right)))
                   rest

           | LEFT (RED, label1, right1) ::
             LEFT (_ (* BLACK *), label2, node3) :: rest =>
                (* Grandparent is BLACK, by red-black invariant. *)
                zip
                   (Node (BLACK, label1,
                          Node (RED, label, left, right),
                          Node (RED, label2, right1, node3)))
                   rest

           | LEFT (RED, label1, right1) ::
             RIGHT (_ (* BLACK *), label2, node3) :: rest =>
                (* Grandparent is BLACK, by red-black invariant. *)
                zip
                   (Node (BLACK, label,
                          Node (RED, label2, node3, left),
                          Node (RED, label1, right, right1)))
                   rest

           | RIGHT (RED, label1, left1) ::
             LEFT (_ (* BLACK *), label2, node3) :: rest =>
                (* Grandparent is BLACK, by red-black invariant. *)
                zip
                   (Node (BLACK, label,
                          Node (RED, label1, left1, left),
                          Node (RED, label2, right, node3)))
                   rest

           | RIGHT (RED, label1, left1) ::
             RIGHT (_ (* BLACK *), label2, node3) :: rest =>
                (* Grandparent is BLACK, by red-black invariant. *)
                zip
                   (Node (BLACK, label1, 
                          Node (RED, label2, node3, left1),
                          Node (RED, label, left, right)))
                   rest

           | [LEFT (RED, _, _)] =>
                (* The root cannot be red. *)
                raise (Fail "invariant")

           | [RIGHT (RED, _, _)] =>
                (* The root cannot be red. *)
                raise (Fail "invariant"))


      (* Precondition:
         1. tree is Leaf or BLACK
         2. (zip tree zipper) satisfies the red-black invariant, but the black-height
            of tree is 1 too small, unless zipper=[],
      *)
      fun zipBlack tree zipper =
         (case zipper of
             [] => tree


           | LEFT (color1, label1, Node (_ (* BLACK *), label2,
                                         left2,
                                         Node (RED, label3, left3, right3))) :: rest =>
                zip
                   (Node (color1, label2,
                          Node (BLACK, label1, tree, left2),
                          Node (BLACK, label3, left3, right3)))
                   rest

           | RIGHT (color1, label1, Node (_ (* BLACK *), label2,
                                          Node (RED, label3, left3, right3),
                                          right2)) :: rest =>
                (* Sibling is BLACK by red-black invariant. *)
                zip
                   (Node (color1, label2,
                          Node (BLACK, label3, left3, right3),
                          Node (BLACK, label1, right2, tree)))
                   rest



           | LEFT (color1, label1, Node (_ (* BLACK *), label2,
                                         Node (RED, label3, left3, right3),
                                         right2)) :: rest =>
                (* Sibling is BLACK by red-black invariant. *)
                zip
                   (Node (color1, label3,
                          Node (BLACK, label1, tree, left3),
                          Node (BLACK, label2, right3, right2)))
                   rest

           | RIGHT (color1, label1, Node (_ (* BLACK *), label2,
                                          left2,
                                          Node (RED, label3, left3, right3))) :: rest =>
                (* Sibling is BLACK by red-black invariant. *)
                zip
                   (Node (color1, label3,
                          Node (BLACK, label2, left2, left3),
                          Node (BLACK, label1, right3, tree)))
                   rest



           | LEFT (RED, label1, Node (_ (* BLACK *), label2, left2, right2)) :: rest =>
                (* Sibling is BLACK by red-black invariant.
                   Previous cases rule out left2 or right2 being a red node.
                *)
                zip
                   (Node (BLACK, label1,
                          tree,
                          Node (RED, label2, left2, right2)))
                   rest

           | RIGHT (RED, label1, Node (_ (* BLACK *), label2, left2, right2)) :: rest =>
                (* Sibling is BLACK by red-black invariant.
                   Previous cases rule out left2 or right2 being a red node.
                *)
                zip
                   (Node (BLACK, label1,
                          Node (RED, label2, left2, right2),
                          tree))
                   rest



           | LEFT (BLACK, label1, Node (BLACK, label2, left2, right2)) :: rest =>
                (* Previous cases rule out left2 or right2 being a red node. *)
                zipBlack
                   (Node (BLACK, label1,
                          tree,
                          Node (RED, label2, left2, right2)))
                   rest

           | RIGHT (BLACK, label1, Node (BLACK, label2, left2, right2)) :: rest =>
                (* Previous cases rule out left2 or right2 being a red node. *)
                zipBlack
                   (Node (BLACK, label1,
                          Node (RED, label2, left2, right2),
                          tree))
                   rest



           | LEFT (BLACK, label1, Node (RED, label2, left2, right2)) :: rest =>
                zipBlack
                   tree
                   (LEFT (RED, label1, left2) :: LEFT (BLACK, label2, right2) :: rest)

           | RIGHT (BLACK, label1, Node (RED, label2, left2, right2)) :: rest =>
                zipBlack
                   tree
                   (RIGHT (RED, label1, right2) :: RIGHT (BLACK, label2, left2) :: rest)



           | LEFT (_, _, Leaf) :: _ =>
                (* Impossible by black-height invariant. *)
                raise (Fail "invariant")
           | RIGHT (_, _, Leaf) :: _ =>
                (* Impossible by black-height invariant. *)
                raise (Fail "invariant"))


      fun search f tree zipper =
         (case tree of
             Leaf =>
                (Leaf, zipper)
           | Node (color, label, left, right) =>
                (case f label of
                    LESS =>
                       search f left (LEFT (color, label, right) :: zipper)
                  | GREATER =>
                       search f right (RIGHT (color, label, left) :: zipper)
                  | EQUAL =>
                       (tree, zipper)))

      fun searchMin tree zipper =
         (case tree of
             Leaf => zipper
           | Node (color, label, left, right) =>
                searchMin left (LEFT (color, label, right) :: zipper))

      fun searchMax tree zipper =
         (case tree of
             Leaf => zipper
           | Node (color, label, left, right) =>
                searchMax right (RIGHT (color, label, left) :: zipper))

      (* Precondition:
         (zip (Node (color, _, Leaf, child)) zipper) is a valid tree,
         or (zip (Node (color, _, child, Leaf)) zipper) is a valid tree.
      *)
      fun deleteNearLeaf color child zipper =
         (case color of
             RED =>
                (* child cannot be RED, by red-black invariant,
                   so it must be Leaf, by black-height invariant.
                *)
                zip Leaf zipper
           | BLACK =>
                (case child of
                    Node (_ (* RED *), label, _ (* Leaf *), _ (* Leaf *)) =>
                       (* Must be RED with Leaf children, by black-height invariant. *)
                       zip (Node (BLACK, label, Leaf, Leaf)) zipper
                  | Leaf =>
                       zipBlack Leaf zipper))

      (* Precondition:
         zip (Node (color, _, left, right)) zipper is a valid tree.
      *)
      fun delete color left right zipper =
         (case right of
             Leaf =>
                (case left of
                    Leaf =>
                       (case color of
                           RED =>
                              zip Leaf zipper
                         | BLACK =>
                              zipBlack Leaf zipper)
                  | _ =>
                       (case searchMax left [] of
                           RIGHT (colorLeftMin, labelLeftMin, leftLeftMin) :: zipper' =>
                              deleteNearLeaf
                                 colorLeftMin leftLeftMin
                                 (zipper' @ LEFT (color, labelLeftMin, right) :: zipper)
                         | _ =>
                              raise (Fail "postcondition")))
           | _ =>
                (case searchMin right [] of
                    LEFT (colorRightMin, labelRightMin, rightRightMin) :: zipper' =>
                       deleteNearLeaf
                          colorRightMin rightRightMin
                          (zipper' @ RIGHT (color, labelRightMin, left) :: zipper)
                  | _ =>
                       raise (Fail "postcondition")))

   end




(***** dict.sig *****)

signature DICT =
   sig

      type key
      type 'a dict

      exception Absent

      val empty : 'a dict
      val singleton : key -> 'a -> 'a dict
      val insert : 'a dict -> key -> 'a -> 'a dict
      val remove : 'a dict -> key -> 'a dict
      val find : 'a dict -> key -> 'a option
      val lookup : 'a dict -> key -> 'a
      val union : 'a dict -> 'a dict -> (key * 'a * 'a -> 'a) -> 'a dict

      val operate : 'a dict -> key -> (unit -> 'a) -> ('a -> 'a) -> 'a option * 'a * 'a dict
      val insertMerge : 'a dict -> key -> 'a -> ('a -> 'a) -> 'a dict

      val isEmpty : 'a dict -> bool
      val member : 'a dict -> key -> bool
      val size : 'a dict -> int

      val toList : 'a dict -> (key * 'a) list
      val domain : 'a dict -> key list
      val map : ('a -> 'b) -> 'a dict -> 'b dict
      val foldl : (key * 'a * 'b -> 'b) -> 'b -> 'a dict -> 'b
      val foldr : (key * 'a * 'b -> 'b) -> 'b -> 'a dict -> 'b
      val app : (key * 'a -> unit) -> 'a dict -> unit

   end




(***** dict-red-black.sml *****)

functor RedBlackDict (structure Key : ORDERED)
   :> DICT where type key = Key.t
   =
   struct

      type key = Key.t
      
      open RedBlackTree

      type 'a dict = int * (key * 'a) tree

      exception Absent

      val empty = (0, Leaf)

      fun singleton key datum =
         (1, Node (BLACK, (key, datum), Leaf, Leaf))

      fun isEmpty (n, _) = n = 0

      fun size (n, _) = n

      fun insert (n, tree) key datum =
         (case search (fn (key', _) => Key.compare (key, key')) tree [] of
             (Leaf, zipper) =>
                (n+1, zipRed ((key, datum), Leaf, Leaf) zipper)
           | (Node (color, _, left, right), zipper) =>
                (n, zip (Node (color, (key, datum), left, right)) zipper))

      fun remove (dict as (n, tree)) key =
         (case search (fn (key', _) => Key.compare (key, key')) tree [] of
             (Leaf, _) => dict
           | (Node (color, _, left, right), zipper) =>
                (n-1, delete color left right zipper))

      fun memberMain tree key =
         (case tree of
             Leaf => false
           | Node (_, (key', datum), left, right) =>
                (case Key.compare (key, key') of
                    EQUAL =>
                       true
                  | LESS =>
                       memberMain left key
                  | GREATER =>
                       memberMain right key))

      fun member (n, tree) key =
         memberMain tree key

      fun findMain tree key =
         (case tree of
             Leaf => NONE
           | Node (_, (key', datum), left, right) =>
                (case Key.compare (key, key') of
                    EQUAL =>
                       SOME datum
                  | LESS =>
                       findMain left key
                  | GREATER =>
                       findMain right key))

      fun find (n, tree) key =
         findMain tree key

      fun lookupMain tree key =
         (case tree of
             Leaf =>
                raise Absent
           | Node (_, (key', datum), left, right) =>
                (case Key.compare (key, key') of
                    EQUAL =>
                       datum
                  | LESS =>
                       lookupMain left key
                  | GREATER =>
                       lookupMain right key))

      fun lookup (_, tree) key =
         lookupMain tree key

      fun operate (n, tree) key absentf presentf =
         (case search (fn (key', _) => Key.compare (key, key')) tree [] of
             (Leaf, zipper) =>
                let
                   val datum = absentf ()
                in
                   (NONE, datum,
                    (n+1, zipRed ((key, datum), Leaf, Leaf) zipper))
                end
           | (Node (color, (_, datum), left, right), zipper) =>
                let
                   val datum' = presentf datum
                in
                   (SOME datum, datum',
                    (n, zip (Node (color, (key, datum'), left, right)) zipper))
                end)

      fun insertMerge dict key x f =
         #3 (operate dict key (fn () => x) f)

      fun foldlMain f x tree =
         (case tree of
             Leaf => x
           | Node (_, (key, elem), left, right) =>
                foldlMain f (f (key, elem, foldlMain f x left)) right)

      fun foldrMain f x tree =
         (case tree of
             Leaf => x
           | Node (_, (key, elem), left, right) =>
                foldrMain f (f (key, elem, foldrMain f x right)) left)

      fun foldl f x (_, tree) = foldlMain f x tree

      fun foldr f x (_, tree) = foldrMain f x tree

      fun toList (_, tree) = foldrMain (fn (key, datum, l) => (key, datum) :: l) [] tree

      fun domain (_, tree) = foldrMain (fn (key, _, l) => key :: l) [] tree
      
      fun mapMain f tree =
         (case tree of
             Leaf => Leaf
           | Node (color, (key, datum), left, right) =>
                Node (color, (key, f datum), mapMain f left, mapMain f right))

      fun map f (n, tree) =
         (n, mapMain f tree)

      fun appMain f tree =
         (case tree of
             Leaf => ()
           | Node (_, label, left, right) =>
                (
                appMain f left;
                f label;
                appMain f right
                ))

      fun app f (_, tree) =
         appMain f tree

      fun union (dict1 as (n1, tree1)) (dict2 as (n2, tree2)) f =
         if n1 <= n2 then
            foldlMain
            (fn (key, datum, dict) =>
                insertMerge dict key datum
                (fn datum' => f (key, datum, datum')))
            dict2
            tree1
         else
            foldlMain
            (fn (key, datum, dict) =>
                insertMerge dict key datum
                (fn datum' => f (key, datum', datum)))
            dict1
            tree2

   end




(***** hashable.sig *****)

signature HASHABLE =
   sig
      type t

      val eq : t * t -> bool
      val hash : t -> word
   end




(***** hashable.sml (partial) *****)

structure StringHashable
   :> HASHABLE where type t = string
   =
   struct
      type t = string

      val eq : string * string -> bool = op =

      fun hash str =
          let
             val len = String.size str
                
             fun loop i h =
                 if i >= len then
                    h
                 else
                    loop (i+1) (JenkinsHash.hashInc h (Word.fromInt (Char.ord (String.sub (str, i)))))
          in
             loop 0 0w0
          end
   end




(***** hash-table.sig *****)

signature HASH_TABLE =
   sig

      type key
      type 'a table

      exception Absent

      val table : int -> 'a table
      val reset : 'a table -> int -> unit

      val member : 'a table -> key -> bool
      val insert : 'a table -> key -> 'a -> unit
      val remove : 'a table -> key -> unit
      val find : 'a table -> key -> 'a option
      val lookup : 'a table -> key -> 'a

      val operate : 'a table -> key -> (unit -> 'a) -> ('a -> 'a) -> 'a option * 'a
      val insertMerge : 'a table -> key -> 'a -> ('a -> 'a) -> unit
      val lookupOrInsert : 'a table -> key -> (unit -> 'a) -> 'a

      val toList : 'a table -> (key * 'a) list
      val fold : (key * 'a * 'b -> 'b) -> 'b -> 'a table -> 'b
      val app : (key * 'a -> unit) -> 'a table -> unit

   end




(***** hash-table.sml *****)

functor HashTable (structure Key : HASHABLE)
   :> HASH_TABLE where type key = Key.t
   =
   struct

      type key = Key.t

      datatype 'a entry =
         Nil
       | Cons of word * key * 'a ref * 'a entry ref

      (* This is a little clumsy, since the first entry in a bucket is modified
         by updating the array and the remaining entries are modified using by 
         assigning to a reference, but it's okay because we want to special-case
         the first entry anyway.
      *)

      type 'a table =
         { residents : int ref,  (* current number of residents *)
           size : word,
           thresh : int,         (* number of residents at which to resize *)
           arr : 'a entry array } ref

      exception Absent

      fun resizeLoad n = n div 3 * 4

      fun table sz =
         if sz <= 0 then
            raise (Fail "illegal size")
         else
            ref { residents = ref 0,
                  size = Word.fromInt sz,
                  thresh = resizeLoad sz,
                  arr = Array.array (sz, Nil) }

      fun reset table sz =
         if sz <= 0 then
            raise (Fail "illegal size")
         else
            table := { residents = ref 0,
                       size = Word.fromInt sz,
                       thresh = resizeLoad sz,
                       arr = Array.array (sz, Nil) }


      fun search hash key curr =
         (case !curr of
             Nil =>
                Nil
           | entry as Cons (hash', key', datumref, next) =>
                if hash = hash' andalso Key.eq (key, key') then
                   (
                   curr := !next;  (* remove from list *)
                   entry
                   )
                else
                   search hash key next)

      fun resize (table as ref { residents, size, thresh, arr, ... } : 'a table) =
         if !residents < thresh then
            ()
         else
            let
               val newsize = 2 * Word.toInt size + 1
               val newsize' = Word.fromInt newsize
               val arr' = Array.array (newsize, Nil)
               
               fun move entry =
                  (case entry of
                      Nil => ()
                    | Cons (hash, _, _, next) =>
                         let
                            val entry' = !next
                            val n = Word.toInt (hash mod newsize')
                         in
                            next := Array.sub (arr', n);
                            Array.update (arr', n, entry);
                            move entry'
                         end)
            in
               (* Move entries to new array. *)
               Array.app move arr;
            
               table := { residents = residents,
                          size = newsize',
                          thresh = resizeLoad newsize,
                          arr = arr' }
            end

      fun member (ref { size, arr, ...} : 'a table) key = 
         let
            val hash = Key.hash key
            val n = Word.toInt (hash mod size)
            val bucket = Array.sub (arr, n)
         in
            (case bucket of
                Nil => false
              | Cons (hash', key', _, next) =>
                   (hash = hash' andalso Key.eq (key, key'))
                   orelse
                   (case search hash key next of
                       Nil => false
                     | entry as Cons (_, _, _, next') =>
                          (
                          next' := bucket;
                          Array.update (arr, n, entry);
                          true
                          )))
         end
         
      fun insert (table as ref { residents, size, arr, ... } : 'a table) key datum =
         let
            val hash = Key.hash key
            val n = Word.toInt (hash mod size)
            val bucket = Array.sub (arr, n)
         in
            (case bucket of
                Nil =>
                   (
                   Array.update (arr, n,
                                 Cons (hash, key, ref datum, ref Nil));
                   residents := !residents + 1;
                   resize table
                   )
              | Cons (hash', key', datumref, next) =>
                   if hash = hash' andalso Key.eq (key, key') then
                      datumref := datum
                   else
                      (case search hash key next of
                          Nil =>
                             (
                             Array.update (arr, n,
                                           Cons (hash, key, ref datum, ref bucket));
                             residents := !residents + 1;
                             resize table
                             )
                        | entry as Cons (_, _, datumref', next') =>
                             (
                             next' := bucket;
                             Array.update (arr, n, entry);
                             datumref' := datum
                             )))
         end

      fun remove (table as ref { residents, size, arr, ... } : 'a table) key =
         let
            val hash = Key.hash key
            val n = Word.toInt (hash mod size)
            val bucket = Array.sub (arr, n)
         in
            (case bucket of
                Nil => ()
              | Cons (hash', key', _, next) =>
                   if hash = hash' andalso Key.eq (key, key') then
                      Array.update (arr, n, !next)
                   else
                      (
                      search hash key next;
                      ()
                      ))
         end

      fun find (table as ref { residents, size, arr, ... } : 'a table) key =
         let
            val hash = Key.hash key
            val n = Word.toInt (hash mod size)
            val bucket = Array.sub (arr, n)
         in
            (case bucket of
                Nil => NONE
              | Cons (hash', key', datumref, next) =>
                   if hash = hash' andalso Key.eq (key, key') then
                      SOME (!datumref)
                   else
                      (case search hash key next of
                          Nil => NONE
                        | entry as Cons (_, _, datumref', next') =>
                             (
                             next' := bucket;
                             Array.update (arr, n, entry);
                             SOME (!datumref')
                             )))
         end
                      
      fun lookup (table as ref { residents, size, arr, ... } : 'a table) key =
         let
            val hash = Key.hash key
            val n = Word.toInt (hash mod size)
            val bucket = Array.sub (arr, n)
         in
            (case bucket of
                Nil =>
                   raise Absent
              | Cons (hash', key', datumref, next) =>
                   if hash = hash' andalso Key.eq (key, key') then
                      !datumref
                   else
                      (case search hash key next of
                          Nil =>
                             raise Absent
                        | entry as Cons (_, _, datumref', next') =>
                             (
                             next' := bucket;
                             Array.update (arr, n, entry);
                             !datumref'
                             )))
         end

      fun operate (table as ref { residents, size, arr, ... } : 'a table) key absentf presentf =
         let
            val hash = Key.hash key
            val n = Word.toInt (hash mod size)
            val bucket = Array.sub (arr, n)
         in
            (case bucket of
                Nil =>
                   let
                      val datum = absentf ()
                   in
                      Array.update (arr, n,
                                    Cons (hash, key, ref datum, ref Nil));
                      residents := !residents + 1;
                      resize table;
                      (NONE, datum)
                   end
              | Cons (hash', key', datumref, next) =>
                   if hash = hash' andalso Key.eq (key, key') then
                      let
                         val datum = !datumref
                         val datum' = presentf datum
                      in
                         datumref := datum';
                         (SOME datum, datum')
                      end
                   else
                      (case search hash key next of
                          Nil =>
                             let
                                val datum = absentf ()
                             in
                                Array.update (arr, n,
                                              Cons (hash, key, ref datum, ref bucket));
                                residents := !residents + 1;
                                resize table;
                                (NONE, datum)
                             end
                        | entry as Cons (_, _, datumref', next') =>
                             let
                                val datum = !datumref'
                                val datum' = presentf datum
                             in
                                next' := bucket;
                                Array.update (arr, n, entry);
                                datumref' := datum';
                                (SOME datum, datum')
                             end))
         end

      fun insertMerge table key x f =
         (
         operate table key (fn () => x) f;
         ()
         )

      fun lookupOrInsert table key datumf =
         #2 (operate table key datumf (fn x => x))

      fun foldEntry f x entry =
         (case entry of
             Nil => x
           | Cons (_, key, ref datum, ref next) =>
                foldEntry f (f (key, datum, x)) next)

      fun fold f x (ref { arr, ... } : 'a table) =
         Array.foldl
         (fn (bucket, acc) => foldEntry f acc bucket)
         x
         arr

      fun toList table =
         fold (fn (key, datum, l) => (key, datum) :: l) [] table

      fun appEntry f entry =
         (case entry of
             Nil => ()
           | Cons (_, key, ref datum, ref next) =>
                (
                f (key, datum);
                appEntry f next
                ))

      fun app f (ref { arr, ... } : 'a table) =
         Array.app (appEntry f) arr
         

   end




(***** symbol.sig *****)

signature SYMBOL =
   sig

      type value
      type symbol

      val eq : symbol * symbol -> bool
      val compare : symbol * symbol -> order

      val fromValue : value -> symbol
      val toValue : symbol -> value

      val hash : symbol -> word

   end




(***** symbol.sml *****)

functor SymbolFun (structure Value : HASHABLE)
   :> SYMBOL where type value = Value.t
   =
   struct

      type value = Value.t

      structure H = HashTable (structure Key = Value)

      val nextIndex = ref 0

      val table : (int * value) H.table = H.table 1001

      type symbol = int * value
            
      fun eq ((n1:int, _), (n2, _)) = n1 = n2
             
      fun compare ((n1, _), (n2, _)) = Int.compare (n1, n2)
            
      fun fromValue v =
         H.lookupOrInsert table v
         (fn () =>
             let val n = !nextIndex
             in
                nextIndex := !nextIndex + 1;
                (n, v)
             end)
             
      fun toValue (_ , v) = v

      fun hash (n, _) = Word.fromInt n

   end


functor SymbolOrderedFun (structure Symbol : SYMBOL)
   :> ORDERED where type t = Symbol.symbol
   =
   struct
      type t = Symbol.symbol

      val eq = Symbol.eq
      val compare = Symbol.compare
   end


functor SymbolHashableFun (structure Symbol : SYMBOL)
   :> HASHABLE where type t = Symbol.symbol
   =
   struct
      type t = Symbol.symbol

      val eq = Symbol.eq
      val hash = Symbol.hash
   end




(***** defaults.sml (partial) *****)

structure StringSymbol = SymbolFun (structure Value = StringHashable)
structure Symbol = StringSymbol
structure SymbolOrdered = SymbolOrderedFun(structure Symbol = Symbol)

structure IntInfRedBlackDict = RedBlackDict (structure Key = IntInfOrdered)
structure StringRedBlackDict = RedBlackDict (structure Key = StringOrdered)
structure SymbolRedBlackDict = RedBlackDict (structure Key = SymbolOrdered)
