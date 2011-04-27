CM.make "sml/sources.cm"; 
Control.Print.printDepth := 200;

datatype xtree = 
   XLeaf of Symbol.symbol
 | XNode of Symbol.symbol * xtree * xtree

fun unzipXtree x = 
   case x of
      XLeaf x_1 =>
      DiscMap.unzipX x_1 o
      DiscMap.unzip (0, 2)
    | XNode (x_1, x_2, x_3) =>
      unzipXtree x_3 o
      unzipXtree x_2 o
      DiscMap.unzipX x_1 o
      DiscMap.unzip (1, 2)

fun subXtree x = 
   case x of
      XLeaf x_1 =>
      DiscMap.subX x_1 o
      DiscMap.sub 0
    | XNode (x_1, x_2, x_3) =>
      subXtree x_3 o
      subXtree x_2 o
      DiscMap.subX x_1 o
      DiscMap.sub 1

datatype tree = 
   Leaf
 | Node of tree * tree 

fun unzipTree x = 
   case x of 
      Leaf => 
      DiscMap.unzip (0, 2)
    | Node (x_1, x_2) => 
      unzipTree x_2 o 
      unzipTree x_1 o 
      DiscMap.unzip (1, 2)

fun subTree x =
   case x of 
      Leaf =>
      DiscMap.sub 0
    | Node (x_1, x_2) =>
      subTree x_2 o
      subTree x_1 o
      DiscMap.sub 1
   
structure MapTree = DiscMapFn 
(struct
   type key = tree
   val unzip = unzipTree
   val sub = subTree
end)

structure MapXtree = DiscMapFn 
(struct
   type key = xtree
   val unzip = unzipXtree
   val sub = subXtree
end)

val map1 = MapTree.singleton (Leaf, 1);
val map2 = MapTree.insert (map1, Node (Node (Leaf, Leaf), Leaf), 2);
val x1 = MapTree.find (map2, Node (Leaf, Leaf)); 
val x2 = MapTree.find (map2, Node (Leaf, Node (Leaf, Leaf))); 
val x3 = MapTree.find (map2, Leaf); 
val x4 = MapTree.find (map2, Node (Node (Leaf, Leaf), Leaf)); 

(* 
fun lookup tree NONE = NONE
  | lookup tree (SOME map) = 
    case tree of 
       Leaf => Option.map DiscTree.prj tree
     | 
(map, tree) = 
   case tree of 
      Leaf => Option.map DiscTree.prj tree
    | Node (x1, x2) => 
   if DiscTree.isEmpty map then NONE
   else cas
*)

(*
fun singleton' (tree, submap) =
   case tree of 
      Leaf => 
      M (Vector.update (map_tree (), off_leaf, SOME submap))
    | Node (tree1, tree2) =>
      M (Vector.update (map_tree (), off_leaf, SOME (
         singleton' (tree1,
         singleton' (tree2, 
         submap)))))
fun singleton (tree, data) = singleton' (tree, D data)

(* Break apart a tree along a term *)
fun breakApart tree (dtree, 

fun insert' (map, tree, submap) = 
   case map of 
     NONE => SOME (singleton' (tree, submap))
   | SOME (D _) => raise Fail "Invariant"
   | SOME (M vector) => 
     (case tree of
*)         
        

(*
fun insert' (map, tree, submap) k =
   case map of 
     X => k (

 k (singleton (tree, submap))
  | insert' (D, tree, submap) k = raise Fail "Invariant" 
  | insert' (M vector, tree, submap) k = 
   (case tree of 
       Leaf => Vector.update (vector, 0, k (Vector.sub (vector, 0, )))
     | Node (tree1, tree2) => 
       Vector.update (vector, 1, insert (Vector.sub (vector, 1, )))
*)

(*
fun insertTree (M_Tree {node, leaf}, x_1, data)
   case x_1 of 
      Leaf => M_Tree {
         node = node, 
         leaf = insertTree_Leaf (leaf, data)
      }
    | Node (x_1, x_2) => M_Tree {
         node = insertTree_Node (node, x_1, x_2, data),
         leaf = leaf
      }

and insertTree_Leaf (leaf, data) = SOME data'

and insertTree_Node (node, x_1, x_2, data) =
   case node of
      NONE => SOME (
    | SOME map => insertTree (


fun singletonK tree k = 
   case tree of 
      Leaf => M (Vector.update (map_treek
    | Node (tree1, tree2) => 
      singletonK tree1 
      o singletonK tree2 

fun singleton tree data = singletonK tree (fn x => x) (D data)

fun findOpt tree NONE = NONE
  | findOpt tree (SOME X) = NONE
  | findOpt tree (SOME (D _)) = raise Fail "Invariant"
  | findOpt tree (SOME (M vector)) = 
    case tree of 
       Node (x1, x2) => findOpt (Vector.sub (2, findOpt (SOME map, 
     | Leaf => map

  | findOpt (D x) tree = SOME x
  | findOpt (M vector) tree = 
    case tree of 
       Node (x1, x2) = find 

   case map of 
      X => NONE
    | D x => SOME x
    | M

fun insert' (map, tree, submap) k =
   case map of 
     X => k (

 k (singleton (tree, submap))
  | insert' (D, tree, submap) k = raise Fail "Invariant" 
  | insert' (M vector, tree, submap) k = 
   (case tree of 
       Leaf => Vector.update (vector, 0, k (Vector.sub (vector, 0, )))
     | Node (tree1, tree2) => 
       Vector.update (vector, 1, insert (Vector.sub (vector, 1, )))

*)
