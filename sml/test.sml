CM.make "sml/elton.cm";

fun smlfile name = "/tmp/" ^ SMLCompileUtil.getPrefix false "." ^ name ^ ".sml";

fun test (prefix, files) = 
  (CompilerState.reset ()
   ; SMLCompileUtil.setPrefix prefix
   ; Read.files files
   ; CompilerState.load ()
   (* ; Indexing.index () *)
   (* ; SMLCompileTerms.termsSig () *)
   ; SMLCompileUtil.write (smlfile "terms-sig") SMLCompileTerms.termsSig
   ; SMLCompileUtil.write (smlfile "terms") SMLCompileTerms.terms
   ; SMLCompileUtil.write (smlfile "tables") SMLCompileTables.tables
   ; SMLCompileUtil.write (smlfile "worlds-sig") SMLCompileWorlds.worldsSig
   ; SMLCompileUtil.write (smlfile "worlds") SMLCompileWorlds.worlds);

test ("b3", [ "examples/Back3.l10" ]);
use (smlfile "terms-sig");
use (smlfile "terms");
use (smlfile "tables");
use (smlfile "worlds-sig");
use (smlfile "worlds");

test ("plus", [ "examples/Plus.l10" ]);
use (smlfile "terms-sig");
use (smlfile "terms");
use (smlfile "tables");
use (smlfile "worlds-sig");
use (smlfile "worlds");

test ("l10", [ "examples/self/ast.l10" ]);
use (smlfile "terms-sig");
use (smlfile "terms");
use (smlfile "tables");
use (smlfile "worlds-sig");
use (smlfile "worlds");

test ("re", [ "examples/Regexp.l10", 
              "examples/RegexpQuery.l10", 
              "examples/RegexpNot.l10", 
              "examples/RegexpNot2.l10" ]);
use (smlfile "terms-sig");
use (smlfile "terms");
use (smlfile "tables");
use (smlfile "worlds-sig");
use (smlfile "worlds");

test ("pa", [ "examples/ProgAnalysisA.l10", 
              "examples/ProgAnalysisB.l10", 
              "examples/ProgAnalysisC.l10", 
              "examples/ProgAnalysisD.l10", 
              "examples/ProgAnalysisE.l10" ]);
use (smlfile "terms-sig");
use (smlfile "terms");
use (smlfile "tables");
use (smlfile "worlds-sig");
use (smlfile "worlds");

test ("wr", [ "regression/worldrule.l10" ]);
use (smlfile "terms-sig");
use (smlfile "terms");
use (smlfile "tables");
use (smlfile "worlds-sig");
use (smlfile "worlds");

test ("t", [ "regression/tree.l10" ]);
use (smlfile "terms-sig");
use (smlfile "terms");
use (smlfile "tables");
use (smlfile "worlds-sig");
use (smlfile "worlds"); 

test ("constr", [ "regression/constraints.l10" ]);
use (smlfile "terms-sig");
use (smlfile "terms");
use (smlfile "tables");
use (smlfile "worlds-sig");
use (smlfile "worlds"); 

open TTerms;
val map1 = MapTree.singleton (Leaf', 1);
val map2 = MapTree.insert (map1, Node' (Node' (Leaf', Leaf'), Leaf'), 2);
val x1 = MapTree.find (map2, Node' (Leaf', Leaf')); 
val x2 = MapTree.find (map2, Node' (Leaf', Node' (Leaf', Leaf'))); 
val x3 = MapTree.find (map2, Leaf'); 
val x4 = MapTree.find (map2, Node' (Node' (Leaf', Leaf'), Leaf')); 

val map3 = List.foldr MapList.insert' MapList.empty 
   [ (Cons' (4, Cons' (12, Cons' (6, End'))), "4-12-6"),
     (Cons' (9, End'), "9"),
     (End', ""),
     (Cons' (12, End'), "12") ]
val x5 = MapList.find (map3, Cons' (9, End'))
val x6 = MapList.find (map3, Cons' (4, Cons' (12, Cons' (6, End'))))
val x7 = MapList.find (map3, Cons' (11, End'))
val x8 = MapList.find (map3, Cons' (4, (Cons' (12, End')))) 

open PlusTerms;
val five = S' (S' (S' (S' (S' Z'))));
val three =  S' (S' (S' Z'));
val map4 = PlusSearch.saturateW (five, three) MapWorld.empty;
val res1 = app (fn x => print ("5+3 = " ^ strN x ^ "\n")) 
           (PlusTables.plus_1_lookup(!PlusTables.plus_1, (five, three)));

(*
open L10Terms;
val () = print "\n"
val () = print (strEven (Succ2' (Succ1' (Succ2' (Succ1' Zero')))))
val () = print "\n";
*)


