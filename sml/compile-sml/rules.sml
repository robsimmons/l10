structure Rules:>
sig

   val emit: Indices.tables -> Compile.compiled_rule list DictX.dict -> unit

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
   fun next_call (common: Compile.rule Compile.common) =
      next^" "^tuple_outgoing (#outgoing common)^" satu db"
in
   case rule of 
      Compile.Normal {common, index, input, output, eqs} =>
      let
         val {label, inputs, outputs} = Indices.get_fold tables index
         val inputs_to_fold = 
            Strings.tuple
               (map (fn (path, t) =>
                       Symbol.toValue (Path.Dict.lookup input path)) inputs)
         val outputs_from_fold = 
            Strings.tuple (map (fn (path, t) => Path.toVar path) outputs)
      in
       ( emitrule' tables n (i+1) (#cont common)
       ; emit ["(* "^(#label common)^" *)"]
       ; emit ["fun "^this^" "^tuple_incoming (#incoming common)^" satu db ="]
       ; incr ()
       ; emit ["L10_Tables.fold_"^Int.toString label]
       ; incr ()
       ; emit ["(fn ("^outputs_from_fold^", db) => "]
       ; incr ()
       ; appSuper
            (fn () => emit [next_call common^")"])
            (fn cstr => emit ["if "^Strings.eqpath cstr,
                              "then "^next_call common,"else db)"])
            ((fn cstr => emit ["if "^Strings.eqpath cstr]),
             (fn cstr => emit ["   andalso "^Strings.eqpath cstr]),
             (fn cstr => emit ["   andalso "^Strings.eqpath cstr,
                               "then "^next_call common,"else db)"]))
            eqs
       ; decr ()
       ; emit ["db (#2 db) "^inputs_to_fold]
       ; decr ()
       ; decr ())
      end
    | Compile.Negated {common, index, input, eqs} =>
      let
         val {label, inputs, outputs} = Indices.get_fold tables index
         val inputs_to_fold = 
            Strings.tuple 
               (map (fn (path, t) =>
                        Symbol.toValue (Path.Dict.lookup input path)) inputs)
         val outputs_from_fold = 
            Strings.tuple (map (fn (path, t) => Path.toVar path) outputs)
      in
       ( emitrule' tables n (i+1) (#cont common)
       ; emit ["(* "^(#label common)^" *)"]
       ; emit ["fun "^this^" "^tuple_incoming (#incoming common)^" satu db ="]
       ; incr ()
       ; emit ["if L10_Tables.fold_"^Int.toString label]
       ; incr (); incr ()
       ; appSuper
            (fn () => emit ["(fn _ => true) false (#2 db) "^inputs_to_fold])
            (fn cstr => emit ["(fn ("^outputs_from_fold^", b) =>",
                              "    b orelse "^Strings.eqpath cstr^")",
                              "false (#2 db) "^inputs_to_fold])
            ((fn cstr => emit ["(fn ("^outputs_from_fold^", b) => b orelse",
                                "    ("^Strings.eqpath cstr]),
             (fn cstr => emit ["     andalso "^Strings.eqpath cstr]),
             (fn cstr => emit ["     andalso "^Strings.eqpath cstr^"))",
                               "false (#2 db) "^inputs_to_fold]))
            eqs
       ; decr (); decr ()
       ; emit ["then db else "^next_call common]
       ; decr ())
      end
    | Compile.Binrel {common, binrel, term1, term2, t} =>
       ( emitrule' tables n (i+1) (#cont common)
       ; emit ["(* "^(#label common)^" *)"]
       ; emit ["fun "^this^" "^tuple_incoming (#incoming common)^" satu db ="]
       ; incr ()
       ; emit ["if "^Strings.binrel t binrel 
                        (Strings.build term1) (Strings.build term2)]
       ; emit ["then "^next_call common^" else db"]
       ; decr ())
    | Compile.Conclusion {facts,incoming} => 
      let
         exception ImpossiblyEmptyConclusion 
         val str = String.concatWith "," (map (Atom.toString o #2) facts)
         fun assert (a, terms) =
            "L10_Tables.assert_"^Symbol.toValue a^" "
            ^Strings.tuple (map Strings.build terms)
         fun loop prefix postfix [] = raise ImpossiblyEmptyConclusion
           | loop prefix postfix [ (pos, atom) ] =
                emit [prefix^"("^assert atom^" db)"^postfix]
           | loop prefix postfix ((pos, atom) :: facts) =
              ( emit [prefix^"("^assert atom]
              ; loop (prefix^" ") (postfix^")") facts)
      in
       ( emit ["(* assert -- "^str^" *)"]
       ; emit ["fun "^this^" "^tuple_incoming incoming^" satu db ="]
       ; loop "   " "" (rev facts))
      end
    | Compile.World {common, world} =>
       ( emitrule' tables n (i+1) (#cont common)
       ; emit ["(* Dynamic world search: "^Atom.toString world^" *)"]
       ; emit ["fun "^this^" "^tuple_incoming (#incoming common)
               ^" satu (flag, db) ="]
       ; emit ["   "^next^" "^tuple_outgoing (#outgoing common)^" satu "
               ^"(flag, satu "^Strings.build (Term.Root world)^" db)"])
end

fun emitrule tables (n, pos, (world, deps), rule) =
 ( emit ["(* Rule at " ^ Pos.toString pos ^ " *)",""]
 ; emitrule' tables (Int.toString n) 0 rule
 ; emit [""])

fun emit' tables rules = 
 ( emit ["","","(* L10 immediate consequences (rules.sml) *)"]
 ; emit ["","structure L10_Consequence =","struct",""]
 ; incr ()
 ; DictX.app (List.app (emitrule tables) o #2) rules
 ; decr ()
 ; emit ["end"])

val emit = emit'

end
