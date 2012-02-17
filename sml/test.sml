CM.make "$SMACKAGE/cmlib/v1/cmlib.cm";
CM.make "sml/sources.cm";

Tab.reset ();
Elton.go ("elton", [ "examples/EdgePath1.l10" ]);
use "examples/EdgePath1.l10.sml";

Tab.reset ();
Elton.go ("elton", [ "examples/TreePath.l10" ]);
use "examples/TreePath.l10.sml";

(*
Tab.reset ();
Read.file "examples/bulp/transitive2.l10";
use "examples/bulp/transitive2.l10.sml";
fun linear n db = 
   if n < 1 then db else linear (n-1) (L10.Assert.edge ((n-1, n), db));
val db0 = L10.empty ();
val db1 = linear 5 db0;
val db2 = linear 500 db0;
assert (125250 = L10.Query.forwards (op +) 0 db2 0);

Tab.reset (); 
Read.file "examples/Back3.l10";
use "examples/Back3.l10.sml"; 

Tab.reset ();
Read.file "examples/Indexing.l10"; 
use "examples/Indexing.l10.sml";
*)
