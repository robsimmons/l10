CM.make "/tmp/trans1.sources.cm";

fun generate_input 0 = ()
  | generate_input i = 
    (Trans1Tables.assertEdge (IntInf.fromInt i, IntInf.fromInt (i+1))
     ; generate_input (i-1));

generate_input SIZE;

Trans1Search.saturateW Trans1Terms.MapWorld.empty;

