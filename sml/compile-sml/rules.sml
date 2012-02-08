structure Rules:>
sig

   (*[ val emit: (int * (Pos.t * Atom.world_t * rule)) list -> unit ]*)
   val emit: (int * (Pos.t * Atom.t * Compile.rule)) list -> unit

end = 
struct

open Util

fun fake_functions (x, NONE) = Symbol.toValue x
  | fake_functions (x, SOME path) = 
       "() (* "^Symbol.toValue x^"/"^Path.toVar path^" *)"

fun emitrule' n i rule = 
let
   val this = "exec_"^n^(if i=0 then "" else ("_"^Int.toString i))
   val next = "exec_"^n^("_"^Int.toString (i+1))
   fun tuple_incoming incoming =
      Strings.tuple (map Symbol.toValue (SetX.toList incoming))
   fun tuple_outgoing outgoing = 
      Strings.tuple (map fake_functions outgoing)
in
   case rule of 
      Compile.Normal {common,index,input,output,eqs} =>
       ( emitrule' n (i+1) (#cont common)
       ; emit ["(* "^(#label common)^" *)"]
       ; emit ["fun "^this^" ("^tuple_incoming (#incoming common)^", db) ="]
       ; incr ()
       ; emit [next^" ("^tuple_outgoing (#outgoing common)^", db)"]
       ; decr ())
    | Compile.Negated {common,index,input,output,eqs} =>
       ( emitrule' n (i+1) (#cont common)
       ; emit ["(* "^(#label common)^" *)"]
       ; emit ["fun "^this^" ("^tuple_incoming (#incoming common)^", db) ="]
       ; incr ()
       ; emit [next^" ("^tuple_outgoing (#outgoing common)^", db)"]
       ; decr ())
    | Compile.Binrel {common,binrel,term1,term2,t} =>
       ( emitrule' n (i+1) (#cont common)
       ; emit ["(* "^(#label common)^" *)"]
       ; emit ["fun "^this^" ("^tuple_incoming (#incoming common)^", db) ="]
       ; incr ()
       ; emit [next^" ("^tuple_outgoing (#outgoing common)^", db)"]
       ; decr ())
    | Compile.Conclusion {facts,incoming} => 
      let val str = String.concatWith "," (map (Atom.toString o #2) facts)
      in
       ( emit ["(* assert -- "^str^" *)"]
       ; emit ["fun "^this^" ("^tuple_incoming incoming^", db) = db"])
      end
end

fun emitrule (n, (pos, world, rule)) =
 ( emit ["(* Rule at " ^ Pos.toString pos ^ " *)",""]
 ; emitrule' (Int.toString n) 0 rule
 ; emit [""])

fun emit' rules = 
 ( emit ["","","(* L10 immediate consequences (rules.sml) *)"]
 ; emit ["","structure L10_Consequence =","struct",""]
 ; incr ()
 ; List.app emitrule rules
 ; decr ()
 ; emit ["end"])

val emit = emit'

end
