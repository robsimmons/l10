CM.make "sml/sources.cm";
Go.readfiles ["regression/tree.l10"];

let val termsig = TextIO.openOut "/tmp/terms-sig.sml"
in
   SMLCompiler.outstream := termsig
   ; SMLCompiler.termSig ()
   ; TextIO.closeOut termsig
end;

let val termstruct = TextIO.openOut "/tmp/terms.sml"
in
   SMLCompiler.outstream := termstruct
   ; SMLCompiler.termStruct ()
   ; TextIO.closeOut termstruct
end;

fun lp true = "(" | lp false = "";
fun rp true = ")" | rp false = "";

use "/tmp/terms-sig.sml";
use "/tmp/terms.sml";
open L10Terms;
val () = print "\n"
val () = print (strEven (Succ2' (Succ1' (Succ2' (Succ1' Zero')))))
val () = print "\n";
