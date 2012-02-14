CM.make "transitive2.l10.cm";

fun generate_input 0 db = db
  | generate_input i db = 
    generate_input (i-1) (L10.Assert.edge ((i-1, i), db));

val b: bool = L10.Query.patha (generate_input SIZE (L10.empty ())) (0, 1);
