structure Indexing = 
struct

open IndexTerm

fun mapi' n [] = []
  | mapi' n (x :: xs) = (n, x) :: mapi' (n+1) xs

fun mapi xs = mapi' 0 xs

fun indexRule (rule_n, (world: Ast.world, (pats, concs))) = 
   let in
      print ("Binding intro for rule #" ^ Int.toString rule_n ^ "\n")
      ; InterTab.bind (#1 world, (rule_n, 0, FV.fvWorld world))
   end

fun indexWorld w = 
   let
      val () = print ("Indexing for world " ^ Symbol.name w ^ "\n")
      val rules = mapi (RuleTab.lookupw w)
      val () = print (Int.toString (length rules) ^ " applicable rule(s)\n")
   in
      app indexRule rules
      ; print "\n"
   end

fun index () = 
   app indexWorld (WorldTab.list ())

end
