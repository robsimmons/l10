CM.make "sml/sources.cm";
(* Go.readfiles ["examples/Back3.l10"];
SMLCompileUtil.setPrefix "b3"; *)
Go.readfiles ["examples/Regexp.l10", 
                    "examples/RegexpQuery.l10", 
                    "examples/RegexpNot.l10", 
                    "examples/RegexpNot2.l10"];
SMLCompileUtil.setPrefix "re"; 
(*Go.readfiles ["examples/ProgAnalysisA.l10", 
                    "examples/ProgAnalysisB.l10", 
                    "examples/ProgAnalysisC.l10", 
                    "examples/ProgAnalysisD.l10", 
                    "examples/ProgAnalysisE.l10"];
SMLCompileUtil.setPrefix "pa";*)

fun smlfile name = "/tmp/" ^ SMLCompileUtil.getPrefix false "." ^ name ^ ".sml";

SMLCompileTerms.termsSig ();
SMLCompileUtil.write (smlfile "terms-sig") SMLCompileTerms.termsSig;
use (smlfile "terms-sig");

SMLCompileUtil.write (smlfile "terms") SMLCompileTerms.terms;
use (smlfile "terms");

SMLCompileUtil.write (smlfile "worlds-sig") SMLCompileWorlds.worldsSig;
use (smlfile "worlds-sig");

SMLCompileUtil.write (smlfile "worlds") SMLCompileWorlds.worlds;

(*
open L10Terms;
val () = print "\n"
val () = print (strEven (Succ2' (Succ1' (Succ2' (Succ1' Zero')))))
val () = print "\n";
*)

(* use "/tmp/useterms.sml"; *)
