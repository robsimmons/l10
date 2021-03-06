CM.make "$SMACKAGE/cmlib/v1/cmlib.cm";
CM.make "sml/sources.cm";

fun assert b = if b then () else raise Match;

(*
Tab.reset ();
Elton.go ("elton", [ "examples/EdgePath1.l10" ]);
use "examples/EdgePath1.l10.sml";

Tab.reset ();
Elton.go ("elton", [ "examples/TreePath.l10" ]);
use "examples/TreePath.l10.sml";

Tab.reset ();
Elton.go ("elton", [ "examples/Regexp.l10" ]);
use "examples/Regexp.l10.sml";

structure Whee = struct
datatype t = Whoo of IntInf.int | Wha of t * t
end;

Tab.reset ();
Elton.go ("elton", [ "regression/regexp.l10" ]);
use "regression/regexp.l10.sml";
*)

Tab.reset ();
Elton.go ("elton", [ "examples/Evens.l10" ]);
use "examples/Evens.l10.sml";
open Evens;
fun f db = (Query.justeven db, Query.justodd db, Query.empty db, Query.both db);
assert ((true, false, false, false) = f someevens);
assert ((false, true, false, false) = f someodds);
assert ((false, false, true, false) = f empty);
assert ((false, false, false, true) = f someofboth);

Tab.reset ();
Elton.go ("elton", [ "examples/Plus.l10" ]);
use "examples/Plus.l10.sml";
open Plus;

fun toN n = 
   if n < 0 then raise Domain
   else if n = 0 then N.Z' 
   else N.S' (toN (n-1));
fun fromN n = 
   case N.prj n of 
      N.Z => 0
    | N.S n => 1 + fromN n;
fun runN query x = 
   case query (op ::) [] empty x of 
      [ n ] => fromN n
    | _ => raise Match;
assert (runN Query.fibonacci (toN 11) = 144);

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
