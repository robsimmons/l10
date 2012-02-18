structure Test = 
struct

fun generate_input 0 db = db
  | generate_input i db = 
    generate_input (i-1) (Transitive1.Assert.edge ((i-1, i), db))

val n = valOf (IntInf.fromString (hd (CommandLine.arguments ())))
val db = generate_input n Transitive1.empty
val () =
  if Transitive1.Query.path db (0, n)
  then print "Success\n"
  else print "Failure\n"

end
