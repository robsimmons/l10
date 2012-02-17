(* Binary relations *)

structure Binrel = struct
   datatype t = Eq | Neq | Gt | Geq 

   fun toString Eq = "=="
     | toString Neq = "!="
     | toString Gt = ">"
     | toString Geq = ">="
end
