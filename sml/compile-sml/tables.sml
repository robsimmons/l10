(* Tables, indexes, and forward chaining search *)
(* Robert J. Simmons *)

structure SMLCompileTables:> sig

   (* structure FooTables *)
   val tables: unit -> unit

   val nameIndex: Symbol.symbol * int -> string

end = 
struct

open SMLCompileUtil
open SMLCompileTypes
open SMLCompileTerms

fun nameIndex (a, n) = Symbol.name a ^ "_" ^ Int.toString n


(* INDEX TYPE *)
(* Given an index, declares type, creates reference, writes helper functions *)

fun emitIndexType a (n, {terms, input, output}) = 
   let
      val input = rev (MapP.listItemsi input)
      val output = MapP.listItemsi output
      val input' = String.concatWith " " (map (nameOfMap "map" o #2) input)
      val output' = 
         if length output = 0 then "unit"
         else if length output = 1 then nameOfType (#2 (hd output))
         else "(" ^ String.concatWith " * " (map (nameOfType o #2) output) ^ ")"
      val name = nameIndex (a, n)

      fun emitLookupCases (n, []) = emit ("x" ^ repeat (n, #")"))
        | emitLookupCases (n, (path, typ) :: pathtyps) = 
          (emit ("(case " ^ nameOfMap "find" typ 
                 ^ " (x, " ^ Path.var path ^ ") of") 
           ; emit ("   NONE => []")
           ; emit (" | SOME x => ")
           ; incr ()
           ; emitLookupCases (n+1, pathtyps)
           ; decr ())

      fun emitLookup () = 
        (emit ("fun " ^ name ^ "_lookup (x: " ^ name ^ ", " 
               ^ tuple (Path.var o #1) (rev input) ^ ") = ")
         ; incr ()
         ; emitLookupCases (0, rev input)
         ; decr ())

      fun next [] = "[]"
        | next ((path, typ) :: pathtyps) = nameOfMap "empty" typ

      fun emitInsertLets (n, []) = ()
        | emitInsertLets (n, (path, typ) :: pathtyps) = 
          (emit ("val y_" ^ Int.toString n ^ " = ")
           ; emit ("   case " ^ nameOfMap "find" typ ^ " (y_" 
                   ^ Int.toString (n-1) ^ ", " ^ Path.var path ^ ") of")
           ; emit ("      NONE => " ^ next pathtyps)
           ; emit ("    | SOME y => y")
           ; emitInsertLets (n+1, pathtyps))

      fun emitInsertInserts (n, []) = 
          emit (tuple (Path.var o #1) output
                ^ " :: y_" ^ Int.toString n
                ^ repeat (n, #")"))
        | emitInsertInserts (n, (path, typ) :: pathtyps) = 
          (emit (nameOfMap "insert" typ ^ " (y_" ^ Int.toString n ^ ", "
                 ^ Path.var path ^ ",")
           ; emitInsertInserts (n+1, pathtyps))

      fun emitInsert () = 
        (emit ("fun " ^ name ^ "_insert (y_0: " ^ name ^ ", "
               ^ tuple (Path.var o #1) (rev input) ^ ", "
               ^ tuple (Path.var o #1) output ^ ") = ")
         ; incr ()
         ; emit "let"
         ; incr ()
         ; emitInsertLets (1, (rev input))
         ; decr ()
         ; emit "in"
         ; incr ()
         ; emitInsertInserts (0, (rev input))
         ; decr ()
         ; emit "end"
         ; decr ())
   in 
      emit ("type " ^ name ^ " = " ^ output' ^ " list " ^ input')
      ; emit ("val " ^ name ^ ": " ^ name ^ " ref = ref " ^ 
              (if length input = 0 then "[]" 
               else nameOfMap "empty" (#2 (hd (rev input)))))
      ; emitLookup ()
      ; emitInsert ()
      ; emit ""
   end

fun emitIndexTypes a = app (emitIndexType a) (mapi (rev (IndexTab.lookup a)))


(* ASSERTION *)
(* Checks for the presence of a fact, indexes it if it's new. *)

fun emitAssertion a = 
   let
     fun populateIndexes shapes = 
        let
           fun filter (n, {terms, input, output}) = Path.genTerms shapes terms
           fun emitOne (n, {terms, input, output}) = 
              emit (" ; " ^ Symbol.name a ^ "_" ^ Int.toString n ^ " := "
                    ^ Symbol.name a ^ "_" ^ Int.toString n ^ "_insert (!"
                    ^ Symbol.name a ^ "_" ^ Int.toString n ^ ", "
                    ^ tuple Path.var (MapP.listKeys input) ^ ", " 
                    ^ tuple Path.var (MapP.listKeys output) ^ ") ")
        in
           emit "(cnt := !cnt + 1"
           ; app emitOne (List.filter filter (mapi (rev (IndexTab.lookup a))))
           ; emit ")"
        end

      val typs = map #2 (#1 (RelTab.lookup a))
      val pathtrees = RelMatchTab.lookup a
      val tuple = tuple (fn (i, _) => Path.var [ i ]) (mapi pathtrees)
   in
      emit ("fun assert" ^ embiggen (Symbol.name a) ^ " " ^ tuple ^ " =")
      ; incr ()
      ; emit ("let"); incr ()

      (* Check for re-assertion *)
      ; emit ("val () = ")
      ; incr ()
      ; emit ("if null (" ^ Symbol.name a ^ "_0_lookup (!"
              ^ Symbol.name a ^ "_0, " ^ tuple ^ "))")
      ; emit ("then () else raise Brk")
      ; decr ()

      ; decr (); emit ("in"); incr ()
      ; caseConstructor populateIndexes pathtrees
      ; decr (); emit ("end handle Brk => () (* Duplicate assertion *)\n")
      ; decr ()
   end 


(* Helper function: looks up a shape in the signature by brute force *)

fun nameOfShape (a, shape) = 
   let 
      val shapes = mapi (rev (map #terms (IndexTab.lookup a)))
      fun find (shape, []) = raise Fail "Invariant in nameOfShape"
        | find (shape, (i, shape') :: shapes) = 
          if shape = shape' 
          then (Symbol.name a ^ "_" ^ Int.toString i)
          else find (shape, shapes)
   in
      find (shape, shapes) 
   end


(* Emit execution that eagerly pounds through an individual rule *)

fun emitExec (rule, point, known, prem, annotation) = 
   let
      val funName = nameOfExec (rule, point)
      val knownBefore = optTuple Symbol.name known

      val () = emit ""
      val () = emit ("(* " ^ annotation ^ " *)")
      val () = emit ("and " ^ funName ^ knownBefore ^ " () =")
   in
      case prem of 
         Rule.Normal args =>
         let
            val {index, 
                 inputPattern, 
                 outputPattern, 
                 constraints, 
                 knownAfterwards} = args
            val funName = nameOfExec (rule, point)
            val indexName = nameOfShape index
            fun aftermap (x, NONE) = Symbol.name x
              | aftermap (x, SOME path) = Path.var path
            val eqs =
               map (fn (a, b, c) => (a, Path.var b, Path.var c)) constraints
         in
           incr ()
           ; emit ("app (" ^ funName ^ "_app" ^ knownBefore ^ ")")
           ; emit ("   (" ^ indexName ^ "_lookup (!" ^ indexName ^ ", "
                   ^ tuple (Symbol.name o #2) inputPattern ^ "))\n")
           ; decr ()
           
           ; emit ("and " ^ funName ^ "_app" ^ knownBefore 
                   ^ " " ^ tuple Path.var outputPattern ^ " =")
           ; incr ()
           ; if length constraints = 0 
             then emit (nameOfExec (rule, point+1) 
                        ^ optTuple aftermap knownAfterwards ^ " ()")
             else (emit ("if " 
                         ^ String.concatWith " andalso " (map nameOfEq eqs))
                   ; emit ("then " ^ nameOfExec (rule, point+1) 
                           ^ optTuple aftermap knownAfterwards ^ " ()")
                   ; emit ("else ()"))
           ; decr ()
         end
         
       | Rule.Negated args => 
         let
            val {index,
                 inputPattern, 
                 outputPattern,
                 constraints, 
                 knownAfterwards} = args
            val funName = nameOfExec (rule, point)
            val indexName = nameOfShape index
            val knownBefore = optTuple Symbol.name known
            val eqs = 
               map (fn (a, b, c) => (a, Path.var b, Path.var c)) constraints
         in
            incr (); emit "let"; incr ()
            ; emit ("val res = " ^ indexName ^ "_lookup (!" ^ indexName ^ ", "
                    ^ tuple (Symbol.name o #2) inputPattern ^ ")")
            ; if null eqs then ()
              else emit ("val res = List.filter " ^ funName ^ "_filter res")
            ; decr (); emit "in"; incr ()
            ; emit ("if null res then " ^ nameOfExec (rule, point+1) 
                    ^ optTuple Symbol.name knownAfterwards ^ " () else ()")
            ; decr (); emit "end"; decr ()
            ; if null eqs then ()
              else (emit ""
                    ; emit ("and " ^ funName ^ "_filter _ = "
                            ^ "raise Fail \"Unimplemented\"\n"))
         end 

       | Rule.Conclusion {facts} =>
         let in
            appFirst (fn _ => emit "   ()")
               (fn prefix =>
                fn (a, terms) => 
                   emit (prefix ^ "assert" ^ embiggen (Symbol.name a) 
                         ^ " " ^ tuple buildTerm terms))
               ("  (", "   ; ") facts
            ; emit "  )"
         end

       | Rule.Binrel {binrel, term1, term2, knownAfterwards} =>
         let
            val binstr = 
               if binrel = Ast.Neq
               then " <> " else (" " ^ Ast.strBinrel binrel ^ " ")
         in 
            incr ()
            ; emit ("if " ^ buildTerm term1 ^ binstr ^ buildTerm term2)
            ; emit ("then " ^ nameOfExec (rule, point+1) 
                    ^ optTuple Symbol.name knownAfterwards ^ " ()")
            ; emit ("else ()")
            ; decr ()
         end
    end


(* STRUCTURE FooTables *)

fun tables () = 
   let 
      val worlds = WorldTab.list ()
   in 
      emit ("structure " ^ getPrefix true "" ^ "Tables =")
      ; emit "struct"
      ; incr ()
      ; emit ("open " ^ getPrefix true "" ^ "Terms\n") 
      ; emit "(* Indexes on terms *)\n"
      ; emit "val cnt = ref 0\n"
      ; app emitIndexTypes (IndexTab.list ())
      ; emit "(* Term matching *)\n"
      ; emit "exception Brk\n"
      ; app emitAssertion (RelTab.list ())
      ; emit "(* Eager run-saturation functions for the McAllester loop *)\n"
      ; emit "fun fake () = ()"
      ; app emitExec (rev (CompiledPremTab.lookup ()))
      ; decr ()
      ; emit "end"
   end

end
