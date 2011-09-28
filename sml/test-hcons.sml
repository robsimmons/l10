CM.make "$/hash-cons-lib.cm";
 
datatype n_view = Z | S of n_view HashCons.obj
type n = n_view HashCons.obj

fun eqN (n, m) = 
   case (n, m) of 
      (Z, Z) => true
    | (S y_0, S y_1) => HashCons.same (y_0, y_1)
    | _ => false

val n_table = HashCons.new {eq = eqN}

val Z' = HashCons.cons0 n_table (0wx0, Z)
fun S' x_0 = HashCons.cons1 n_table (0wx1, S)

