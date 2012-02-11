
structure Search:> sig

   val emit: unit -> unit 

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

fun filter shapes (pos, ((_, (w', args)), prems), SOME _) =
   case Term.gens (shapes, args) of
      NONE => NONE
    | SOME subst => SOME (pos, (w', args), subst, prems)

fun emitDependencyVisitor shapes (fst, (pos, conc, subst, prems)) = 
let
   (* Little helper function for printing out the individual substitutions *) 
   fun str (t, substs) =
      " |-> [ " 
      ^ String.concatWith ", " 
           (map (fn (path, Term.Path _) => Path.toVar path
                  | (path, term) => 
                       Path.toVar path ^ "=" ^ Term.toString term)
               substs) 
      ^ " ]"
  
   (* XXX TODO - Prevent dumb stuff like (z = s X) equalities *) 
   fun simplify_equalities t [] eqs_out = eqs_out
     | simplify_equalities t [ _ ] eqs_out = eqs_out
     | simplify_equalities t ((x, _) :: (eq as (y, _)) :: eqs) eqs_out =
          simplify_equalities t (eq :: eqs) ((t, x, y) :: eqs_out)

   fun process_subst ((x, (t, eqs)), (eqs_out, subst)) = 
      (simplify_equalities t eqs eqs_out, 
       DictX.insert subst x (Term.Path (#1 (hd eqs), t)))

   val subst_list = DictX.toList subst

   val (equalities, subst) =
      List.foldr process_subst ([], DictX.empty) subst_list

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

   fun getEquality (t, x, y) =
      Strings.eq t (Path.toVar x) (Path.toVar y)

in
 ( emit fst
 ; emit ["(* " ^ Pos.toString pos ^ " - " ^ Atom.toString conc ^ " *)"]
 ; appSuper (fn () => ())
      (fn (x, s) => emit ["(* { " ^ Symbol.toValue x ^ str s ^ " } *)"])
      ((fn (x, s) => emit ["(* { " ^ Symbol.toValue x ^ str s ^ ","]),
       (fn (x, s) => emit [" *   " ^ Symbol.toValue x ^ str s ^ ","]),
       (fn (x, s) => emit [" *   " ^ Symbol.toValue x ^ str s ^ " } *)"]))
      subst_list
 ; emit ["val db ="]
 ; incr ()
 ; appSuper (fn () => ())
      (fn cnstr => (emit ["if " ^ getEquality cnstr ^ " then"]; incr ()))
      ((fn cnstr =>  emit ["if " ^ getEquality cnstr ^ " andalso"]),
       (fn cnstr =>  emit ["   " ^ getEquality cnstr ^ " andalso"]),
       (fn cnstr => (emit ["   " ^ getEquality cnstr ^ " then"]; incr ())))
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

fun emitWorld (isAnd, (w, depends)) =
let 
   val splits = 
      List.foldl
         (fn ((_, ((_, (w', args)), _), SOME _), splits) => 
           ( if Symbol.eq (w, w') then () else raise Fail "Search.emit"
           ; Splitting.insertList splits args))
         (Splitting.unsplit (Tab.lookup Tab.worlds w))
         depends

   val tuple = Strings.optTuple (map (fn (i, _) => Path.toVar [ i ]) splits)
   val prefix = 
      (if isAnd then "and" else "fun") ^ " saturate_" ^ Symbol.toValue w
      ^ tuple ^ " db ="
in
 ( emit [prefix, "let"]
 ; incr ()
 ; emit ["val w = " ^ Strings.builder w ^ tuple]
 ; emit ["fun insert_w (db as {worlds=ref worlds, ...}: L10_Tables.tables) = "]
 ; emit [" ( #worlds db := World.Dict.insert worlds w ()"," ; db)"]
 ; decr ()
 ; emit ["in if World.Dict.member (!(#worlds db)) w"]
 ; emit ["   then db else"]
 ; incr ()
 ; CaseAnalysis.emit ""
      (fn (postfix, shapes) =>
        ( emit ["(* " ^ Atom.toString (w, shapes) ^ " *)"]
        ; emit ["let"]
        ; incr ()
        ; appFirst (fn () => ()) (emitDependencyVisitor shapes) ([],[""])
             (rev (List.mapPartial (filter shapes) depends))
        ; decr ()
        ; emit ["in"]
        ; incr ()
        ; emit ["insert_w (saturate (fn x => x) db)"]
        ; decr ()
        ; emit ["end" ^ postfix]))
      (CaseAnalysis.cases splits)
 ; decr ()
 ; emit ["end"])
end   

fun emit' () = 
let
in
 ( emit ["", "", "(* L10 Generated Tabled Search (search.sml) *)", ""]
 ; emit ["structure L10_Search = ", "struct"]
 ; incr ()
 ; emit ["fun saturate fs (table: L10_Tables.tables) = "]
 ; emit ["let","   val () = #flag table := false"]
 ; emit ["   val table = fs table"] 
 ; emit ["in","   if !(#flag table) then saturate fs table else table","end",""]
 ; appSuper 
      (fn () => ()) 
      (fn x => emitWorld (false, x))
      ((fn x => (emitWorld (false, x); Util.emit [""])),
       (fn x => (emitWorld (true, x); Util.emit [""])),
       (fn x => (emitWorld (true, x))))
      (rev (Tab.list Tab.depends))
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
