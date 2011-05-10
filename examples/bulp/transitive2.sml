CM.make "/tmp/trans2.sources.cm";

fun generate_input 0 = ()
  | generate_input i = 
    (Trans2Tables.assertEdge (IntInf.fromInt i, IntInf.fromInt (i+1))
     ; generate_input (i-1));

generate_input SIZE;

Trans2Search.saturateW Trans2Terms.MapWorld.empty;
