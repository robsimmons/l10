structure Rules:>
sig

   (*[ val emit: Indices.tables 
                    -> (int * (Pos.t * Atom.world_t * rule)) list
                    -> unit ]*)
   val emit: Indices.tables 
                -> (int * (Pos.t * Atom.t * Compile.rule)) list 
                -> unit

end = 
struct

open Util

fun fake_functions (x, NONE) = Symbol.toValue x
  | fake_functions (x, SOME path) = 
       Path.toVar path^" (* "^Symbol.toValue x^" *)"

fun emitrule' tables n i rule = 
let
   val this = "exec_"^n^(if i=0 then "" else ("_"^Int.toString i))
   val next = "exec_"^n^("_"^Int.toString (i+1))
   fun tuple_incoming incoming =
      Strings.tuple (map Symbol.toValue (SetX.toList incoming))
   fun tuple_outgoing outgoing = 
      Strings.tuple (map fake_functions outgoing)
   fun optemit [] = ()
     | optemit ts = emit [Strings.tuple ts]
in
   case rule of 
      Compile.Normal {common,index,input,output,eqs} =>
      let
         val {label, inputs, outputs} = Indices.get_fold tables index
         val inputs_to_fold = 
            map (fn (path, t) =>
                    Symbol.toValue (Path.Dict.lookup input path))
               inputs
         val outputs_from_fold = 
            map (fn (path, t) => Path.toVar path) outputs
                    
      in
       ( emitrule' tables n (i+1) (#cont common)
       ; emit ["(* "^(#label common)^" *)"]
       ; emit ["fun "^this^" "^tuple_incoming (#incoming common)^" db ="]
       ; if null eqs 
         then 
           ( incr ()
           ; emit ["L10_Tables.fold_"^Int.toString label]
           ; incr ()
           ; emit ["(fn ("^Strings.tuple outputs_from_fold^", db) => "]
           ; emit ["    "^next^" "^tuple_outgoing (#outgoing common)^" db"^")"]
           ; emit ["db", Strings.tuple inputs_to_fold]
           ; decr ()
           ; decr ())
         else 
           ( emit ["   db (* XXX UNFINISHED *)"]))
      end
    | Compile.Negated {common,index,input,output,eqs} =>
       ( emitrule' tables n (i+1) (#cont common)
       ; emit ["(* "^(#label common)^" *)"]
       ; emit ["fun "^this^" "^tuple_incoming (#incoming common)^" db ="]
       ; incr ()
       ; emit ["   db (* XXX UNFINISHED *)"]
       ; decr ())
    | Compile.Binrel {common,binrel,term1,term2,t} =>
       ( emitrule' tables n (i+1) (#cont common)
       ; emit ["(* "^(#label common)^" *)"]
       ; emit ["fun "^this^" "^tuple_incoming (#incoming common)^" db ="]
       ; incr ()
       ; emit ["   db (* XXX UNFINISHED *)"]
       ; decr ())
    | Compile.Conclusion {facts,incoming} => 
      let val str = String.concatWith "," (map (Atom.toString o #2) facts)
      in
       ( emit ["(* assert -- "^str^" *)"]
       ; emit ["fun "^this^" "^tuple_incoming incoming^" db = db"])
      end
end

fun emitrule tables (n, (pos, world, rule)) =
 ( emit ["(* Rule at " ^ Pos.toString pos ^ " *)",""]
 ; emitrule' tables (Int.toString n) 0 rule
 ; emit [""])

fun emit' tables rules = 
 ( emit ["","","(* L10 immediate consequences (rules.sml) *)"]
 ; emit ["","structure L10_Consequence =","struct",""]
 ; incr ()
 ; List.app (emitrule tables) rules
 ; decr ()
 ; emit ["end"])

val emit = emit'

end
