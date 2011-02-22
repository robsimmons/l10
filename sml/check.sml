structure DeclTab = 
struct

local 
   exception Decl
   structure Tab = SymTab(type entrytp = A.decl)
in
open Tab
fun declWorld x = 
   case SymTab.find x of 
      SOME (Ast.DeclWorld (_, args)) => args 
    | _ => raise Decl

end
end


structure Check = struct

structure A = Ast

type ctx = typ MapX.map

type whorn = A.term list * A.world list

structure SearchTab = MultiTab(type entrytp = whorn)

fun uniqueify (set, []) = []
  | uniqueify (set, sym :: syms) = 
    let val sym = Symbol.unique (set, sym) 
    in sym :: uniqueify (SetX.add (set, sym), syms) end

fun buildSearchTab decl = 
   case decl of 
      A.DeclWorld (w, args) => 
      let
         (* Come up with variable names for the world arguments *)
         val symCand = map (fn (SOME x, _) => x 
                             | (_, y) => Symbol.symbol ("?" ^ Symbol.name y))
         val sym = uniqueify (SetX.empty, symCand) 
      in
         SearchTab.bind (w, (syms, A.One))
         ; DeclTab.bind (w, decl)
      end       
    | A.DeclDepends ((w1, ts1), (w2, ts2)) =>
      let
         val (syms, pat) = valOf (SearchTab.lookup w1)
         val exs = SetX.


end
