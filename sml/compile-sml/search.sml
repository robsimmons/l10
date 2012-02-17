
structure Search:> sig

   val emit: Compile.compiled_rule list DictX.dict -> unit 

end = 
struct

open Util

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

fun staticDepStr subst (w, args) = 
   "saturate_"^Symbol.toValue w
   ^Strings.optTuple
       (map (fn term => Strings.build (valOf (Term.subst (subst, term)))) args)
   ^" db"

fun emitRule shapes (fst, (i, pos, (world, deps), rule, subst)) =
let
   val (opar, cpar) = if null (#2 world) then ("", "") else ("(", ")") 
   val worldstr = if Symbol.eq (#1 world, Symbol.fromValue "world")
                  then "default world" 
                  else if null (#2 world)
                  then "world "^Symbol.toValue (#1 world)
                  else "world ("^Atom.toString world^")"
   val () = emit fst
   val () = emit ["(* Rule #"^Int.toString i^", "^worldstr^" *)",
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
   val (lcom,rcom) = ("(* "," *)")
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
 ; emit [lcom^"val () = print (\"Entering \"^World.toString w^\"...\")"^rcom]
 ; emit ["val exec = fn x => x"]
 ; decr ()
 ; emit ["in if World.Dict.member worldset w"]
 ; emit ["then ("^lcom^"print \"already visited.\\n\";"^rcom^" db) else"]
 ; incr ()
 ; emit ["let"]
 ; incr ()
 ; emit [lcom^"val () = print \"entering.\\n\""^rcom]
 ; emit ["val db = L10_Tables.set_worlds db (World.Dict.insert worldset w ())"]
 ; decr ()
 ; emit ["in"]
 ; CaseAnalysis.emit ""
      (fn (postfix, shapes) =>
        ( emit ["(* " ^ Atom.toString (w, shapes) ^ " *)"]
        ; emit ["let"]
        ; incr ()
        ; appFirst (fn () => ()) (emitRule shapes) ([],[""])
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

end
