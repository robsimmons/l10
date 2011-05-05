structure SMLCompileDeduce = 
struct

open SMLCompileUtil
open SMLCompileTypes
open SMLCompileTerms

fun nameSaturate (w, rule, point) = 
   "saturate" ^ embiggen (Symbol.name w) 
   ^ "_" ^ Int.toString rule
   ^ (if point = 0 then "" else ("_" ^ Int.toString point))

fun nameIndex (a, n) = Symbol.name a ^ "_" ^ Int.toString n

fun pathStr path = "x_" ^ String.concatWith "_" (map Int.toString path)

fun inputPattern [] = "()"
  | inputPattern [ path ] = pathStr path
  | inputPattern paths = 
    "(" ^ String.concatWith ", " (map pathStr paths) ^ ")"

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
                 ^ " (x, " ^ pathStr path ^ ") of") 
           ; emit ("   NONE => []")
           ; emit (" | SOME x => ")
           ; incr ()
           ; emitLookupCases (n+1, pathtyps)
           ; decr ())

      fun emitLookup () = 
        (emit ("fun " ^ name ^ "_lookup (x: " ^ name ^ ", " 
               ^ inputPattern (rev (map #1 input)) ^ ") = ")
         ; incr ()
         ; emitLookupCases (0, rev input)
         ; decr ())

      fun next [] = "[]"
        | next ((path, typ) :: pathtyps) = nameOfMap "empty" typ

      fun emitInsertLets (n, []) = ()
        | emitInsertLets (n, (path, typ) :: pathtyps) = 
          (emit ("val y_" ^ Int.toString n ^ " = ")
           ; emit ("   case " ^ nameOfMap "find" typ ^ " (y_" 
                   ^ Int.toString (n-1) ^ ", " ^ pathStr path ^ ") of")
           ; emit ("      NONE => " ^ next pathtyps)
           ; emit ("    | SOME y => y")
           ; emitInsertLets (n+1, pathtyps))

      fun emitInsertInserts (n, []) = 
          emit (inputPattern (map #1 output)
                ^ " :: y_" ^ Int.toString n
                ^ repeat (n, #")"))
        | emitInsertInserts (n, (path, typ) :: pathtyps) = 
          (emit (nameOfMap "insert" typ ^ " (y_" ^ Int.toString n ^ ", "
                 ^ pathStr path ^ ",")
           ; emitInsertInserts (n+1, pathtyps))

      fun emitInsert () = 
        (emit ("fun " ^ name ^ "_insert (y_0: " ^ name ^ ", "
               ^ inputPattern (rev (map #1 input)) ^ ", "
               ^ inputPattern (map #1 output) ^ ") = ")
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

fun substPath ([], Ast.Var NONE, term) = term 
  | substPath (path, Ast.Structured (f, terms), term) = 
    Ast.Structured (f, substPaths (path, terms, term))
  | substPath _ = raise Fail "substPath invariant"

and substPaths (i :: path, terms, term) = 
    List.take (terms, i) 
    @ [ substPath (path, List.nth (terms, i), term) ]
    @ tl (List.drop (terms, i))
  | substPaths _ = raise Fail "substPaths invariant"

(* Checking to see if a moded term fits a particular shape *)

fun genTerm (shape, term) = 
   case (shape, term) of
      (_, ModedTerm.Var _) => true
    | (Ast.Var _, _) => raise Fail "Shape not sufficiently general"
    | (Ast.Const _, ModedTerm.Structured _) => false
    | (Ast.Structured _, ModedTerm.Const _) => false
    | (Ast.Const c, ModedTerm.Const c') => c = c'
    | (Ast.Structured (f, terms), ModedTerm.Structured (f', terms')) =>
      f = f' andalso genTerms terms terms'
    | (Ast.NatConst i, ModedTerm.NatConst i') => i = i'
    | (Ast.StrConst s, ModedTerm.StrConst s') => s = s'
    | _ => raise Fail "Typing invariant in shape"

and genTerms shapes terms = 
   List.all genTerm (ListPair.zipEq (shapes, terms))

(* Deep matching relations to create the indexing structure *)

fun emitMatches (a, shapes) [] = 
    let
       fun filter (n, {terms, input, output}) = genTerms shapes terms
       fun emitOne (n, {terms, input, output}) = 
          emit (" ; " ^ Symbol.name a ^ "_" ^ Int.toString n ^ " := "
                ^ Symbol.name a ^ "_" ^ Int.toString n ^ "_insert (!"
                ^ Symbol.name a ^ "_" ^ Int.toString n ^ ", "
                ^ inputPattern (MapP.listKeys input) ^ ", " 
                ^ inputPattern (MapP.listKeys output) ^ ") ")
    in
       emit "(()"
       ; app emitOne (List.filter filter (mapi (rev (IndexTab.lookup a))))
       ; emit ")"
    end
  | emitMatches shape ((path, Coverage'.Unsplit _) :: pathtree) =
    emitMatches shape pathtree
  | emitMatches shape ((path, Coverage'.Split (typ, subtrees)) :: pathtree) =
    let
       val constructors = TypeConTab.lookup typ
    in 
       emit ("(case " ^ nameOfPrj typ ^ pathStr path ^ " of")
       ; emitMatchCases "   " shape path typ subtrees pathtree constructors
       ; emit ")"
    end
  | emitMatches shape _ = raise Fail "Unimplemented form of splitting"

and emitMatchCases prefix shape path typ subtrees pathtree [] = 
    emit (prefix ^ "Void_" ^ embiggen (Symbol.name typ) 
          ^ " x = abort" ^ embiggen (Symbol.name typ) ^ " x")
  | emitMatchCases prefix shape path typ subtrees pathtree [ c ] = 
    emitMatchCase prefix shape path subtrees pathtree c
  | emitMatchCases prefix shape path typ subtrees pathtree (c :: cs) =
    (emitMatchCases prefix shape path typ subtrees pathtree cs
     ; emitMatchCase " | " shape path subtrees pathtree c)

and emitMatchCase prefix shape (path: int list) subtrees pathtree constructor = 
   let 
      val (a, shapes) = shape
      val typs = #1 (valOf (ConTab.lookup constructor))
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
               else (" " ^ inputPattern (map #1 new_pathtree)))
            ^ " => ")
      ; incr ()
      ; emitMatches (a, shapes) (new_pathtree @ pathtree)
      ; decr ()
   end

fun emitMatching a = 
   let
      val typs = map #2 (#1 (valOf (RelTab.lookup a)))
      val shape = (a, map (fn _ => Ast.Var NONE) typs)
      val pathtrees = 
         map (fn (i, pathtree) => ([ i ], pathtree)) 
            (mapi (valOf (MatchTab.lookup a)))
          handle Option => []
   in
      emit ("fun assert" ^ embiggen (Symbol.name a) 
            ^ " " ^ inputPattern (map #1 pathtrees) ^ " =")
      ; incr ()
      ; emit ("let"); incr ()

      (* Check for re-assertion *)
      ; emit ("val () = ")
      ; incr ()
      ; emit ("if null (" ^ Symbol.name a ^ "_0_lookup (!"
              ^ Symbol.name a ^ "_0, "
              ^ inputPattern (map #1 pathtrees) ^ "))")
      ; emit ("then () else raise Brk")
      ; decr ()

      ; decr (); emit ("in"); incr ()
      ; emitMatches shape pathtrees
      ; decr (); emit ("end handle Brk => () (* Duplicate assertion *)\n")
      ; decr ()
   end 

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

fun emitSaturate w (rule, point, Compiled.Normal args) = 
   let
      val {knownBefore, 
           index, 
           inputPattern, 
           outputPattern, 
           constraints, 
           knownAfterwards} = args
      val funName = nameSaturate (w, rule, point)
      val indexName = nameOfShape index
      fun aftermap (x, NONE) = Symbol.name x
        | aftermap (x, SOME path) = pathStr path
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
              ^ " " ^ tuple pathStr outputPattern ^ " =")
      ; incr ()
      ; if length constraints = 0 
        then emit (nameSaturate (w, rule, point+1) 
                   ^ optTuple aftermap knownAfterwards ^ " ()")
        else emit "() (* NEED TO DO CONSTRAINTS *)"
      ; decr ()
   end
  | emitSaturate w (rule, point, Compiled.Conclusion {knownBefore, facts}) = 
    let 
    in
       emit ""
       ; emit ("and " ^ nameSaturate (w, rule, point)
             ^ optTuple Symbol.name knownBefore ^ " () = (()")
       ; incr ()
       ; app (fn (a, terms) => 
                emit ("; assert" ^ embiggen (Symbol.name a) 
                      ^ " " ^ tuple buildTerm terms))
             facts
       ; emit ")"
       ; decr ()
    end

  | emitSaturate w (rule, point, _) = ()

fun emitSaturates w = app (emitSaturate w) (rev (InterTab.lookup w))

fun deduce () = 
   let 
      val worlds = WorldTab.list ()
   in 
      emit ("structure " ^ getPrefix true "" ^ "Deduce =")
      ; emit "struct"
      ; incr ()
      ; emit ("open " ^ getPrefix true "" ^ "Terms\n") 
      ; emit "(* Indexes on terms *)\n"
      ; app emitIndexTypes (IndexTab.list ())
      ; emit "(* Term matching *)\n"
      ; emit "exception Brk\n"
      ; app emitMatching (RelTab.list ())
      ; emit "(* Eager run-saturation functions for the McAllester loop *)\n"
      ; emit "fun fake () = ()"
      ; app emitSaturates worlds
      ; decr ()
      ; emit "end"
   end

end
