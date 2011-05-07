CM.make "sml/elton.cm";

fun smlfile name = "/tmp/" ^ SMLCompileUtil.getPrefix false "." ^ name ^ ".sml";

fun test (prefix, files) = 
  (CompilerState.reset ()
   ; SMLCompileUtil.setPrefix prefix
   ; Read.files files
   ; CompilerState.load ()
   ; SMLCompileUtil.write (smlfile "terms-sig") SMLCompileTerms.termsSig
   ; SMLCompileUtil.write (smlfile "terms") SMLCompileTerms.terms
   ; SMLCompileUtil.write (smlfile "tables") SMLCompileTables.tables
   ; SMLCompileUtil.write (smlfile "search-sig") SMLCompileSearch.searchSig
   ; SMLCompileUtil.write (smlfile "search") SMLCompileSearch.search);

test ("tree", [ "examples/TreeDepth.l10" ]);
use (smlfile "terms-sig");
use (smlfile "terms");
use (smlfile "tables");
use (smlfile "search-sig");
use (smlfile "search");

val elapsed = 
   let val start = Time.toSeconds (Time.now ()) 
   in fn () => Time.toSeconds (Time.now ()) - start end

val emp = TreeTerms.MapWorld.empty
val Z' = TreeTerms.Z'
val S' = TreeTerms.S';

val n0 = Z'
val n1 = S' n0
val n2 = S' n1
val n3 = S' n2
val n4 = S' n3
val n5 = S' n4
val n6 = S' n5;

ignore (TreeSearch.saturateW n4 emp)
before print ("Elapsed Time: " ^ IntInf.toString (elapsed ()) ^ "s\n");

val d0 = length (TreeTables.trees_1_lookup (!TreeTables.trees_1, n0))
val d1 = length (TreeTables.trees_1_lookup (!TreeTables.trees_1, n1))
val d2 = length (TreeTables.trees_1_lookup (!TreeTables.trees_1, n2))
val d3 = length (TreeTables.trees_1_lookup (!TreeTables.trees_1, n3))
val d4 = length (TreeTables.trees_1_lookup (!TreeTables.trees_1, n4));

ignore (TreeSearch.saturateW n5 emp)
before print ("Elapsed Time: " ^ IntInf.toString (elapsed ()) ^ "s\n");

val d5 = length (TreeTables.trees_1_lookup (!TreeTables.trees_1, n5));

ignore (TreeSearch.saturateW n6 emp)
before print ("Elapsed Time: " ^ IntInf.toString (elapsed ()) ^ "s\n");

val d6 = length (TreeTables.trees_1_lookup (!TreeTables.trees_1, n6));

