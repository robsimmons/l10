CM.make "sml/sources.cm";
Go.readfiles ["regression/tree.l10"];

SMLCompileTerms.termsSig ();
SMLCompileUtil.write "/tmp/terms-sig.sml" SMLCompileTerms.termsSig;
use "/tmp/terms-sig.sml";

SMLCompileUtil.write "/tmp/terms.sml" SMLCompileTerms.terms;
use "/tmp/terms.sml";

open L10Terms;
val () = print "\n"
val () = print (strEven (Succ2' (Succ1' (Succ2' (Succ1' Zero')))))
val () = print "\n";
