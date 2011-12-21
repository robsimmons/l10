(* Modes for indexing *)

structure Mode = 
struct
   datatype t = Input | Output | Ignore
   fun toString Input = "+"
     | toString Output = "-"
     | toString Ignore = "_"
end
