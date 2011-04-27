CM.make "sml/sources.cm";

fun smlfile name = "/tmp/" ^ SMLCompileUtil.getPrefix false "." ^ name ^ ".sml";

fun test (prefix, files) = 
  (Reset.reset ()
   ; SMLCompileUtil.setPrefix "b3"
   ; Go.readfiles files
   ; SMLCompileTerms.termsSig ()
   ; SMLCompileUtil.write (smlfile "terms-sig") SMLCompileTerms.termsSig
   ; SMLCompileUtil.write (smlfile "terms") SMLCompileTerms.terms
   ; SMLCompileUtil.write (smlfile "worlds-sig") SMLCompileWorlds.worldsSig
   ; SMLCompileUtil.write (smlfile "worlds") SMLCompileWorlds.worlds);

test ("b3", [ "examples/Back3.l10" ]);
use (smlfile "terms-sig");
use (smlfile "terms");
use (smlfile "worlds-sig");
use (smlfile "worlds");

test ("re", [ "examples/Regexp.l10", 
              "examples/RegexpQuery.l10", 
              "examples/RegexpNot.l10", 
              "examples/RegexpNot2.l10" ]);
use (smlfile "terms-sig");
use (smlfile "terms");
use (smlfile "worlds-sig");
use (smlfile "worlds");

test ("pa", [ "examples/ProgAnalysisA.l10", 
              "examples/ProgAnalysisB.l10", 
              "examples/ProgAnalysisC.l10", 
              "examples/ProgAnalysisD.l10", 
              "examples/ProgAnalysisE.l10" ]);
use (smlfile "terms-sig");
use (smlfile "terms");
use (smlfile "worlds-sig");
use (smlfile "worlds");

(*
open L10Terms;
val () = print "\n"
val () = print (strEven (Succ2' (Succ1' (Succ2' (Succ1' Zero')))))
val () = print "\n";
*)


