(* Use: 
 $ cd ~/l10
 $ bin/elton examples/TreeDepth.l10 
 $ sml examples/TreeDepth.sml
 *)

CM.make "$SMACKAGE/cmlib/v1/cmlib.cm";
use "examples/TreeDepth.l10.sml";
fun f (t, ()) = print ("   Tree: "^Tree.toString t^"\n");
print ("\nDepth 2\n");
TreeDepth.Query.alltrees f () TreeDepth.empty (N.S (N.S N.Z));
print ("\nDepth 3\n");
TreeDepth.Query.alltrees f () TreeDepth.empty (N.S (N.S (N.S N.Z)));
print ("\n");

fun g (_, n) = n+1;
fun count n =
   print ("Depth "^N.toString n^" "
          ^Int.toString (TreeDepth.Query.alltrees g 0 TreeDepth.empty n)^"\n");

(* For faster results, see https://oeis.org/A003095 *)
count N.Z;
count (N.S N.Z);
count (N.S (N.S N.Z));
count (N.S (N.S (N.S N.Z)));
count (N.S (N.S (N.S (N.S N.Z))));
count (N.S (N.S (N.S (N.S (N.S N.Z))))); (* Note: this one takes awhile *)
