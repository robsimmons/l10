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
structure CD = CompiledData

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
                 ^ " (x, " ^ varPath path ^ ") of") 
           ; emit ("   NONE => []")
           ; emit (" | SOME x => ")
           ; incr ()
           ; emitLookupCases (n+1, pathtyps)
           ; decr ())

      fun emitLookup () = 
        (emit ("fun " ^ name ^ "_lookup (x: " ^ name ^ ", " 
               ^ tuple (varPath o #1) (rev input) ^ ") = ")
         ; incr ()
         ; emitLookupCases (0, rev input)
         ; decr ())

      fun next [] = "[]"
        | next ((path, typ) :: pathtyps) = nameOfMap "empty" typ

      fun emitInsertLets (n, []) = ()
        | emitInsertLets (n, (path, typ) :: pathtyps) = 
          (emit ("val y_" ^ Int.toString n ^ " = ")
           ; emit ("   case " ^ nameOfMap "find" typ ^ " (y_" 
                   ^ Int.toString (n-1) ^ ", " ^ varPath path ^ ") of")
           ; emit ("      NONE => " ^ next pathtyps)
           ; emit ("    | SOME y => y")
           ; emitInsertLets (n+1, pathtyps))

      fun emitInsertInserts (n, []) = 
          emit (tuple (varPath o #1) output
                ^ " :: y_" ^ Int.toString n
                ^ repeat (n, #")"))
        | emitInsertInserts (n, (path, typ) :: pathtyps) = 
          (emit (nameOfMap "insert" typ ^ " (y_" ^ Int.toString n ^ ", "
                 ^ varPath path ^ ",")
           ; emitInsertInserts (n+1, pathtyps))

      fun emitInsert () = 
        (emit ("fun " ^ name ^ "_insert (y_0: " ^ name ^ ", "
               ^ tuple (varPath o #1) (rev input) ^ ", "
               ^ tuple (varPath o #1) output ^ ") = ")
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



(* MATCHES *)
(* Deep matching relations to create the indexing structure *)

fun emitMatches (a, shapes) [] = 
    let
       fun filter (n, {terms, input, output}) = genTerms shapes terms
       fun emitOne (n, {terms, input, output}) = 
          emit (" ; " ^ Symbol.name a ^ "_" ^ Int.toString n ^ " := "
                ^ Symbol.name a ^ "_" ^ Int.toString n ^ "_insert (!"
                ^ Symbol.name a ^ "_" ^ Int.toString n ^ ", "
                ^ tuple varPath (MapP.listKeys input) ^ ", " 
                ^ tuple varPath (MapP.listKeys output) ^ ") ")
    in
       emit "(cnt := !cnt + 1"
       ; app emitOne (List.filter filter (mapi (rev (IndexTab.lookup a))))
       ; emit ")"
    end
  | emitMatches shape ((path, Coverage'.Unsplit _) :: pathtree) =
    emitMatches shape pathtree
  | emitMatches shape ((path, Coverage'.Split (typ, subtrees)) :: pathtree) =
    let
       val constructors = TypeConTab.lookup typ
    in 
       emit ("(case " ^ nameOfPrj typ ^ varPath path ^ " of")
       ; appFirst 
          (fn () => emit ("   Void_" ^ embiggen (Symbol.name typ) 
                          ^ " x = abort" ^ embiggen (Symbol.name typ) ^ " x"))
          (emitMatchesCase shape path subtrees pathtree)
          ("   ", " | ") constructors
       ; emit ")"
    end
  | emitMatches shape _ = raise Fail "Unimplemented form of splitting"

and emitMatchesCase shape path subtrees pathtree prefix constructor = 
   let 
      val (a, shapes) = shape
      val typs = #1 (ConTab.lookup constructor)
      val shape = 
         if null typs then Ast.Const constructor
         else Ast.Structured (constructor, map (fn _ => Ast.Var NONE) typs)
      val shapes = substPaths (path, shapes, shape)
      val new_pathtree = 
         map (fn (i, pathtree) => (path @ [ i ], pathtree))
            (mapi (MapX.lookup (subtrees, constructor)))
   in
      emit (prefix ^ embiggen (Symbol.name constructor) 
            ^ (if null new_pathtree then ""
               else (" " ^ tuple (varPath o #1) new_pathtree))
            ^ " => ")
      ; incr ()
      ; emitMatches (a, shapes) (new_pathtree @ pathtree)
      ; decr ()
   end


(* ASSERTION *)
(* Checks for the presence of a fact, indexes it if it's new. *)

fun emitAssertion a = 
   let
      val typs = map #2 (#1 (RelTab.lookup a))
      val shape = (a, map (fn _ => Ast.Var NONE) typs)
      val pathtrees = 
         map (fn (i, pathtree) => ([ i ], pathtree)) 
            (mapi (RelMatchTab.lookup a))
          handle Option => []
   in
      emit ("fun assert" ^ embiggen (Symbol.name a) 
            ^ " " ^ tuple (varPath o #1) pathtrees ^ " =")
      ; incr ()
      ; emit ("let"); incr ()

      (* Check for re-assertion *)
      ; emit ("val () = ")
      ; incr ()
      ; emit ("if null (" ^ Symbol.name a ^ "_0_lookup (!"
              ^ Symbol.name a ^ "_0, "
              ^ tuple (varPath o #1) pathtrees ^ "))")
      ; emit ("then () else raise Brk")
      ; decr ()

      ; decr (); emit ("in"); incr ()
      ; emitMatches shape pathtrees
      ; decr (); emit ("end handle Brk => () (* Duplicate assertion *)\n")
      ; decr ()
   end 


(* Helper function: looks up a shape in the signature by brute force *)

fun nameOfShape (a, shape) = 
   let 
      val shapes = mapi (rev (map #terms (IndexTab.lookup a)))
      fun find (shape, []) = raise Fail "Invariant"
        | find (shape, (i, shape') :: shapes) = 
          if shape = shape' 
          then (Symbol.name a ^ "_" ^ Int.toString i)
          else find (shape, shapes)
   in
      find (shape, shapes) 
   end


(* *)

fun emitSaturate (rule, point, CD.Normal args) = 
   let
      val {knownBefore, 
           index, 
           inputPattern, 
           outputPattern, 
           constraints, 
           knownAfterwards} = args
      val funName = nameOfExec (rule, point)
      val indexName = nameOfShape index
      fun aftermap (x, NONE) = Symbol.name x
        | aftermap (x, SOME path) = varPath path
      val knownBefore = optTuple Symbol.name knownBefore
   in
      emit ""
      ; emit ("and " ^ funName ^ knownBefore ^ " () =")
      ; incr ()
      ; emit ("app (" ^ funName ^ "_app" ^ knownBefore ^ ")")
      ; emit ("   (" ^ indexName ^ "_lookup (!" ^ indexName ^ ", "
              ^ tuple (Symbol.name o #2) inputPattern ^ "))\n")
      ; decr ()

      ; emit ("and " ^ funName ^ "_app" ^ knownBefore 
              ^ " " ^ tuple varPath outputPattern ^ " =")
      ; incr ()
      ; if length constraints = 0 
        then emit (nameOfExec (rule, point+1) 
                   ^ optTuple aftermap knownAfterwards ^ " ()")
        else emit "() (* NEED TO DO CONSTRAINTS *)"
      ; decr ()
   end
  | emitSaturate (rule, point, CD.Conclusion {knownBefore, facts}) = 
    let 
    in
       emit ""
       ; emit ("and " ^ nameOfExec (rule, point)
             ^ optTuple Symbol.name knownBefore ^ " () = (()")
       ; incr ()
       ; app (fn (a, terms) => 
                emit ("; assert" ^ embiggen (Symbol.name a) 
                      ^ " " ^ tuple buildTerm terms))
             facts
       ; emit ")"
       ; decr ()
    end

  | emitSaturate (rule, point, _) = ()


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
      ; app emitSaturate (rev (CompiledPremTab.lookup ()))
      ; decr ()
      ; emit "end"
   end

end
