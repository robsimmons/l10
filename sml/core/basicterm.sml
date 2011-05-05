structure BasicTerm = 
struct

   datatype 'a term = 
      Const of Symbol.symbol
    | NatConst of IntInf.int
    | StrConst of string
    | Structured of Symbol.symbol * 'a term list
    | Var of 'a 

   fun strTerm str term = 
      case term of 
         Const x => Symbol.name x
       | NatConst i => IntInf.toString i
       | StrConst s => "\"" ^ s ^ "\""
       | Structured (f, terms) => 
         "(" ^ Symbol.name f ^ " " 
         ^ String.concatWith " " (map (strTerm str) terms)
         ^ ")"
       | Var x => str x

   type astTerm = Symbol.symbol option term
   fun strAstTerm x = strTerm (fn NONE => "_" | SOME x => Symbol.name x) x

   type modedTerm = (bool * Symbol.symbol) term
   fun strModedTerm x = strTerm (fn (true, _) => "++" | (false, _) => "--") x

end
