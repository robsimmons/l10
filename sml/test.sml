CM.make "sml/elton.cm";
fun test (prefix, files) = 
   let 
      val sourceDir = OS.Path.mkAbsolute {path = "sml/util", 
                                          relativeTo = OS.FileSys.getDir ()}
   in
      Elton.load {sourceFiles = files}
      ; Elton.writeSML {targetDir = "/tmp", prefix = prefix}
      ; Elton.writeHelpers {sourceDir = sourceDir, targetDir = "/tmp"}
      ; Elton.writeCM 
          {targetDir = "/tmp", 
           filename = SMLCompileUtil.getPrefix false "." ^ "sources"}
   end;

test ("b3", [ "examples/Back3.l10" ]);
CM.make "/tmp/b3.sources.cm";

test ("plus", [ "examples/Plus.l10" ]);
CM.make "/tmp/plus.sources.cm";

test ("l10", [ "examples/self/ast.l10" ]);
CM.make "/tmp/plus.sources.cm";

test ("re", [ "examples/Regexp.l10", 
              "examples/RegexpQuery.l10", 
              "examples/RegexpNot.l10", 
              "examples/RegexpNot2.l10" ]);
CM.make "/tmp/re.sources.cm";

test ("pa", [ "examples/ProgAnalysisA.l10", 
              "examples/ProgAnalysisB.l10", 
              "examples/ProgAnalysisC.l10", 
              "examples/ProgAnalysisD.l10", 
              "examples/ProgAnalysisE.l10" ]);
CM.make "/tmp/pa.sources.cm";

test ("wr", [ "regression/worldrule.l10" ]);
CM.make "/tmp/wr.sources.cm";

test ("t", [ "regression/tree.l10" ]);
CM.make "/tmp/t.sources.cm";

test ("constr", [ "regression/constraints.l10" ]);
CM.make "/tmp/constr.sources.cm";

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

