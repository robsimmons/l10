(* structure DeclTab = 
struct

local 
   exception Decl
   structure Tab = Symtab(type entrytp = A.decl)
in
open Tab
fun declWorld x = 
   case SymTab.find x of 
      SOME (Ast.DeclWorld (_, args)) => args 
    | _ => raise Decl

end
end *)
 

structure Check = struct

structure A = Ast
structure T = Term

type whorn = A.term list * A.world list

structure SearchTab = Multitab(type entrytp = whorn)

exception MatchFail
exception Invariant

fun assert b subst = if b then subst else raise MatchFail

fun matchTerm pat term subst = 
   case (pat, T.prj term) of 
      (A.Const x, T.Structured (y, [])) => assert (x = y) subst
    | (A.Structured (x, pats), T.Structured (y, terms)) =>
      if x <> y then raise MatchFail
      else matchTerms pats terms subst
    | (A.NatConst n1, T.NatConst n2) => assert (n1 = n2) subst
    | (A.StrConst s1, T.StrConst s2) => assert (s1 = s2) subst
    | (A.Var NONE, _) => subst
    | (A.Var (SOME x), _) => 
      (case Subst.find subst x of
          NONE => Subst.extend subst (x, term)
        | SOME t1 => assert (Term.eq (t1, term)) subst)
    | _ => raise MatchFail

and matchTerms [] [] subst = subst
  | matchTerms (pat :: pats) (term :: terms) subst =
    matchTerms pats terms (matchTerm pat term subst)
  | matchTerms _ _ _ = (print "matchTerms\n"; raise Invariant)

fun strWorld (w, terms) = 
  case terms of 
     [] => Symbol.name w
   | _ => 
     Symbol.name w
     ^ String.concat (map (fn term => " " ^ Term.strTerm' true term) terms)

fun search (w, terms) = 
   let 
      val () = print ("Searching for: " ^ strWorld (w, terms) ^ "\n")

      fun folder ((pats, prems), set) = 
         let 
            val subst = matchTerms pats terms Subst.empty
            fun addPrem ((w, pats), set) = 
               PredMap.insert (set, (w, map (Subst.apply subst) pats), ())
         in
            List.foldl addPrem set prems
         end
         handle MatchFail => set

      val results = List.foldl folder PredMap.empty (SearchTab.lookup w)
   in
      app (fn world => 
              print ("Immediate dependency: " ^ strWorld world ^ "\n")) 
          (PredMap.list results)
   end

fun check decl = 
   case decl of
      A.DeclConst (s, _, _) => 
      print ("=== Term constant " ^ Symbol.name s ^ " ===\n")
    | Ast.DeclDatabase (db, _, (w, terms)) => 
      let 
         val world = (w, map (Subst.apply Subst.empty) terms) 
      in
         print ("=== Database: " ^ Symbol.name db ^ "===\n")
         ; search world
      end
    | Ast.DeclDepends ((w, pats), worlds) => 
      let in
         print ("=== Dependency for " ^ Symbol.name w ^ " ===\n")
         ; SearchTab.bind (w, (pats, worlds))
      end
    | Ast.DeclRelation (s, _, _) => 
      print ("=== Relation " ^ Symbol.name s ^ " ===\n")
    | Ast.DeclRule (ls, s) => 
      print ("=== Rule ===\n")
    | Ast.DeclType s => 
      print ("=== Type " ^ Symbol.name s ^ " ===\n")
    | Ast.DeclWorld (s, _) => 
      print ("=== World " ^ Symbol.name s ^ " ===\n")

end
