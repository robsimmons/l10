
structure Search:> sig

   val emit: Compile.compiled_rule list DictX.dict -> unit 

end = 
struct

open Util

(*
(* Emit the correct seek functions for a world in the signature *) 

fun emitWorldSig world = 
   let
      val Name = embiggen (Symbol.name world)
      val args = WorldTab.lookup world
      fun gettyp x = 
         if encoded x 
         then getPrefix true "" ^ "Terms." ^ Symbol.name x
         else nameOfType x
      val strargs = String.concatWith " * " (map gettyp args)
      val maptyp = "unit " ^ getPrefix true "" ^ "Terms.MapWorld.map"
   in    
      if null args
      then emit ("val saturate" ^ Name ^ ": " ^ maptyp ^ " -> " ^ maptyp) 
      else emit ("val saturate" ^ Name ^ ": " ^ strargs ^ " -> "
                 ^ maptyp ^ " -> " ^ maptyp) 
   end


(* Ensure that dependent worlds are searched first *)

fun emitDependencies w terms = 
   let
      val typs = WorldTab.lookup w

      fun handleArg subst prefix (w, terms) = 
         let val terms' = valOf (Ast.subTerms (subst, terms)) in  
            emit (prefix ^ "saturate" ^ embiggen (Symbol.name w) 
                  ^ optTuple buildTerm terms') 
         end

      fun handlePat prefix (pat, args) = 
         let 
            val pattyp = ListPair.zipEq (pat, typs)
            val (terms, subst, eqs) = pathTerms pattyp
            val eqs =
               map (fn (a, b, c) => (a, Symbol.name b, Symbol.name c)) eqs
         in
            if null eqs 
            then appFirst (fn () => emit (prefix ^ "(fn x => x)")) 
                    (handleArg subst) (prefix, " o ") (rev args)
            else (emit (prefix ^ "(if " 
                        ^ String.concatWith " andalso " (map nameOfEq eqs))
                  ; incr ()
                  ; appFirst (fn () => emit "then (fn x => x")
                       (handleArg subst) ("then (", "      o ") (rev args)
                  ; emit ") else (fn x => x))"
                  ; decr ())
         end
       
      val pats = List.filter (Path.genTerms terms o #1) (SearchTab.lookup w)
   in
      appFirst (fn () => emit "((fn x => x)") handlePat ("(", " o ") (rev pats)
   end


(* Return a list of functions that begin saturation at the current world *)

fun emitStartingPoints w terms = 
   let
      val typs = WorldTab.lookup w

      fun handleSubst' prefix postfix (w, n, subst) = 
         emit (prefix ^ nameOfExec (n, 0) 
               ^ optTuple buildTerm (MapX.listItems subst) ^ postfix)

      fun handleRule prefix (n, (w, pat), _) =
         let
            val pattyp = ListPair.zipEq (pat, typs)
            val (terms, subst, eqs) = pathTerms pattyp
            val eqs =
               map (fn (a, b, c) => (a, Symbol.name b, Symbol.name c)) eqs
         in
            if null eqs
            then handleSubst' prefix " ::" (w, n, subst)
            else (emit (prefix ^ "(if "
                        ^ String.concatWith " andalso " (map nameOfEq eqs))
                  ; handleSubst' "   then [ " " ] else []) @" (w, n, subst))
         end

      fun handleRules [] = false
        | handleRules [ rule ] = (handleRule ", " rule; true)
        | handleRules (rule :: rules) = 
          (handleRules rules before handleRule "  " rule)

      val rules = List.filter (Path.genTerms terms o #2 o #2) (RuleTab.lookup w)
   in
      if handleRules rules
      then emit "  [])"
      else emit ", [])"
   end  
*)


(* Emit the saturation fuction for a given world *)

(*
fun filterDependency shapes (pos, ((_, (w', args)), prems), SOME _) =
   case Term.gens (shapes, args) of
      NONE => NONE
    | SOME subst => SOME (pos, (w', args), subst, prems)
*)

fun filterRule shapes (i, pos, ((w, args), deps), rule) =
  case Term.gens (shapes, args) of
      NONE => NONE
    | SOME subst => SOME (i, pos, ((w, args), deps), rule, subst)

fun substEqualities subst = 
let
   (* XXX TODO - Prevent dumb stuff like (z = s X) equalities *) 
   fun simplify_equalities t [] eqs_out = eqs_out
     | simplify_equalities t [ _ ] eqs_out = eqs_out
     | simplify_equalities t ((x, _) :: (eq as (y, _)) :: eqs) eqs_out =
          simplify_equalities t (eq :: eqs) ((t, x, y) :: eqs_out)

   fun process_subst ((x, (t, eqs)), (eqs_out, subst)) = 
      (simplify_equalities t eqs eqs_out, 
       DictX.insert subst x (Term.Path (#1 (hd eqs), t)))

   val subst_list = DictX.toList subst

   (* Little helper function for printing out the individual substitutions *) 
   fun str (t, substs) =
      " |-> [ " 
      ^ String.concatWith ", " 
           (map (fn (path, Term.Path _) => Path.toVar path
                  | (path, term) => 
                       Path.toVar path ^ "=" ^ Term.toString term)
               substs) 
      ^ " ]"
in
 ( appSuper (fn () => ())
      (fn (x, s) => emit ["(* { " ^ Symbol.toValue x ^ str s ^ " } *)"])
      ((fn (x, s) => emit ["(* { " ^ Symbol.toValue x ^ str s ^ ","]),
       (fn (x, s) => emit [" *   " ^ Symbol.toValue x ^ str s ^ ","]),
       (fn (x, s) => emit [" *   " ^ Symbol.toValue x ^ str s ^ " } *)"]))
      subst_list
 ; List.foldr process_subst ([], DictX.empty) subst_list)
end

(*
fun emitDependencyVisitor shapes (fst, (pos, conc, subst, prems)) = 
let
   val () = emit fst
   val () = emit ["(* "^Atom.toString conc^" - "^Pos.toString pos^" *)"]
   val (equalities, subst) = substEqualities subst

   fun getSaturate prem =
   let
     val (w, args) = 
        case prem of 
           Prem.Normal (Pat.Atom prem) => prem
         | Prem.Negated (Pat.Atom prem) => prem
   in 
      "saturate_" ^ Symbol.toValue w
      ^ Strings.optTuple 
           (map (fn term => Strings.build (valOf (Term.subst (subst, term))))
               args)
   end
in
 ( emit ["val db ="]
 ; incr ()
 ; appSuper (fn () => ())
      (fn cnstr => (emit ["if "^Strings.eqpath cnstr^" then"]; incr ()))
      ((fn cnstr =>  emit ["if "^Strings.eqpath cnstr^" andalso"]),
       (fn cnstr =>  emit ["   "^Strings.eqpath cnstr^" andalso"]),
       (fn cnstr => (emit ["   "^Strings.eqpath cnstr^" then"]; incr ())))
      equalities
 ; appSuper (fn () => emit ["db"])
      (fn (_, prem) => emit [getSaturate prem ^ " db"])
      ((fn (_, prem) => emit ["(" ^ getSaturate prem ^ " o"]),
       (fn (_, prem) => emit [" " ^ getSaturate prem ^ " o"]),
       (fn (_, prem) => emit [" " ^ getSaturate prem ^ ") db"]))
      prems
 ; if null equalities then () else (decr (); emit ["else db"])
 ; decr ())
end
*)

fun staticDepStr subst (w, args) = 
   "saturate_"^Symbol.toValue w
   ^Strings.optTuple
       (map (fn term => Strings.build (valOf (Term.subst (subst, term)))) args)
   ^" db"

fun emitRule shapes (i, pos, (world, deps), rule, subst) =
let
   val (opar, cpar) = if null (#2 world) then ("", "") else ("(", ")") 
   val worldstr = if Symbol.eq (#1 world, Symbol.fromValue "world")
                  then "default world" 
                  else if null (#2 world)
                  then "world "^Symbol.toValue (#1 world)
                  else "world ("^Atom.toString world^")"
   val () = emit ["","(* Rule #"^Int.toString i^", "^worldstr^" *)",
                  "(* "^Pos.toString pos^" *)"]
   val (equalities, subst) = substEqualities subst
   val easy_case = null equalities
   val starting_point = 
      "L10_Consequence.exec_"^Int.toString i^" "
      ^Strings.tuple (map (Strings.build o #2) (DictX.toList subst))
      ^" saturate"
in
 if easy_case 
 then
   ( app (fn world => emit ["val db = "^staticDepStr subst world]) deps
   ; emit ["val exec = "^starting_point^" o exec"])
 else
   ( appFirst (fn () => raise Fail "Invariant: impossible except in easy case")
        (fn (pre,cnstr) => emit [pre^Strings.eqpath cnstr])
        ("val b = ", "        andalso")
        equalities
   ; app (fn world => 
            emit ["val db = if b then "^staticDepStr subst world^" else db"])
        deps
   ; emit ["val exec = if b then "^starting_point^" o exec else exec"])
end

fun emitWorld (w, rules: Compile.compiled_rule list) =
let 
   val splits = 
      List.foldl
         (fn ((w', args), splits) => 
           ( if Symbol.eq (w, w') then () else raise Fail "Search.emit"
           ; Splitting.insertList splits args))
         (Splitting.unsplit (Tab.lookup Tab.worlds w))
         (map (#1 o #3) rules)

   val tuple = Strings.optTuple (map (fn (i, _) => Path.toVar [ i ]) splits)
   val prefix = 
      "and saturate_" ^ Symbol.toValue w
      ^ tuple ^ " db ="
in
 ( emit ["",prefix, "let"]
 ; incr ()
 ; emit ["val w = " ^ Strings.builder w ^ tuple]
 ; emit ["val worldset = L10_Tables.get_worlds db"]
 ; emit ["(* val () = print \"Entering "^Symbol.toValue w^"\\n\" *)"]
 ; emit ["val exec = fn x => x"]
 ; decr ()
 ; emit ["in if World.Dict.member worldset w then db else"]
 ; incr ()
 ; emit ["let val db=L10_Tables.set_worlds db (World.Dict.insert worldset w ())"]
 ; emit ["in"]
 ; CaseAnalysis.emit ""
      (fn (postfix, shapes) =>
        ( emit ["(* " ^ Atom.toString (w, shapes) ^ " *)"]
        ; emit ["let"]
        ; incr ()
(*
        ; appFirst (fn () => ()) (emitDependencyVisitor shapes) ([],[""])
             (rev (List.mapPartial (filterDependency shapes) depends))
        ; flush ()
*)
        ; app (emitRule shapes)
             (rev (List.mapPartial (filterRule shapes) rules))
        ; decr ()
        ; emit ["in"]
        ; incr ()
        ; emit ["loop exec db"]
        ; decr ()
        ; emit ["end" ^ postfix]))
      (CaseAnalysis.cases splits)
 ; emit ["end"]
 ; decr ()
 ; emit ["end"])
end   

fun emit' compiled_rules = 
let
in
 ( emit ["", "", "(* L10 Generated Tabled Search (search.sml) *)", ""]
 ; emit ["structure L10_Search = ", "struct"]
 ; incr ()
 ; emit ["fun loop fs (db: L10_Tables.tables) = "]
 ; emit ["let"]
 ; emit ["   (* val () = print \"Beginning saturation loop...\" *)"]
 ; emit ["   val db = fs (L10_Tables.set_flag db false)"] 
 ; emit ["in","   if L10_Tables.get_flag db"]
 ; emit ["   then ((* print \"continue!\\n\"; *) loop fs db)"]
 ; emit ["   else ((* print \"done.\\n\"; *) db)","end",""]

 (* Callback saturation function *)
 ; emit ["fun saturate x_0 db ="]
 ; CaseAnalysis.emit ""
      (fn (postfix, shapes) =>
       let 
          exception WorldFormationInvariant
          val (w, terms) =
             case shapes of 
                [ Term.SymConst w ] => (Symbol.toValue w, [])
              | [ Term.Root (w, terms) ] => (Symbol.toValue w, terms)
              | _ => raise WorldFormationInvariant
       in
          emit ["saturate_"^w
                ^Strings.optTuple (map Strings.build terms)^" db"^postfix]
       end)  
      (CaseAnalysis.cases 
          [(0,
            Tab.fold 
               (fn (w, Class.World, split) => 
                      Splitting.insert split (Term.SymConst w)
                 | (w, class, split) => 
                      Splitting.insert split 
                         (Term.Root (w, map (fn t => (Term.Var (NONE, SOME t)))
                                           (Class.argtyps class))))
               (Splitting.Unsplit Type.world) 
               Tab.worlds)])

 ; DictX.app emitWorld compiled_rules
 ; decr ()
 ; emit ["end"])
end

val emit = emit'

(*
   val name = Symbol.name w
   val Name = embiggen (Symbol.name w)
   val typs = WorldTab.lookup w
      val pathtree = WorldMatchTab.lookup w
      val tuple = optTuple (fn (i, _) => Path.var [ i ]) (mapi pathtree)
   in
      emit ("and saturate_" ^ Name ^ tuple ^ " worldmap =")
      ; incr (); emit ("let"); incr ()

      ; emit ("val w = " ^ embiggen (Symbol.name w) ^ "'" ^ tuple)
      ; emit ("val () = if isSome (MapWorld.find (worldmap, w))")
      ; emit ("         then raise Revisit else ()")
      ; emit ("val worldmap = MapWorld.insert (worldmap, w, ())" )
      ; emit ("val (child_searches, rulefns) = ")
      ; incr ()
      ; caseConstructor 
           (fn shapes => 
              (emitDependencies w shapes; emitStartingPoints w shapes))
           pathtree
      ; decr ()
      ; emit ("val worldmap' = child_searches worldmap")
      (* ; emit ("val () = print (\"Visiting \" ^ strWorld w ^ \"\\n\")") *)
      ; emit ("val () = loop rulefns")
      ; decr ()
      ; emit ("in")
      ; incr ()
      ; emit "worldmap'"
      ; decr ()
      ; emit ("end handle Revisit => worldmap\n")
      ; decr ()
   end
*)

(*
(* SIGNATURE FOO_SEARCH *)

fun searchSig () = 
   let 
      val worlds = WorldTab.list ()
   in
      emit ("signature " ^ String.map Char.toUpper (getPrefix true "_")
            ^ "SEARCH =")
      ; emit "sig" 
      ; incr ()
      ; app emitWorldSig worlds 
      ; decr ()
      ; emit "end"
   end


(* STRUCTURE FooSearch *)

fun search () = 
   let
      val worlds = WorldTab.list ()
   in
      emit ("structure " ^ getPrefix true "" ^ "Search" 
            ^ ":> " ^ String.map Char.toUpper (getPrefix true "_")
            ^ "SEARCH" ^ " =")
      ; emit "struct"
      ; incr ()
      ; emit ("open " ^ getPrefix true "" ^ "Terms")
      ; emit ("open " ^ getPrefix true "" ^ "Tables\n")

      ; emit ("fun loop fs = if !cnt = (app (fn f => f ()) fs; !cnt) " 
              ^ "then () else loop fs")

      ; emit ("exception Revisit\n")
      ; emit "fun fake () = ()\n"
      ; app emitWorld worlds
      ; decr ()
      ; emit "end"
   end
*)

end
