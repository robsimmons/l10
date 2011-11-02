
structure CaseAnalysis =
struct

datatype t = 
   Done of Term.t
 | Case of (Type.t * path) * (Term.t * t) list * t option

(*[
datasort cases = 
   Done of Term.shape
 | Case of (Type.t * path) * (Term.pat * t) list * t option
]*)

(*[ cases: Splitting.t list -> cases ]*)
fun cases splits = 
let 
   fun mapi n [] = []
     | mapi n (x :: xs) = (n, x) :: mapi (n+1) xs

   (*[ val caser: 
          Term.shape list 
          -> Splitting.t list 
          -> Path.t
          -> Term.pat 
          -> Term.pat * t ]*)
   fun caser shapes splits path 

   (*[ val splitter: 
          Term.shape list
          -> Splitting.t list
          -> t ]*)
   fun splitter shapes [] = Done shapes
     | splitter shapes ((path, split) :: splits) = 
         (case split of  
             Splitting.Unsplit t => splitter shapes splits
           | Splitting.Sym (t, set) => 
                Case ((t, Type.path)
                      , map (caser shapes splits path)
                           (map Term.SymCon (SetX.toList set))
                      , SOME (splitter shapes splits))
           | Splitting.Nat set => 
                Case ((Type.nat, path)
                      , map (caser shapes splits path)
                           (map Term.NatCon (IntInfSplaySet.toList set))
                      , SOME (splitter shapes splits))
           | Splitting.Str set =>
                Case ((Type.string, path)
                      , map (caser shapes splits path)
                           (map Term.NatCon (StringSplaySet.toList set))
                      , SOME (splitter shapes splits))
           | Splitting.Root {t, covered, uncovered} => 
             let fun mapper c = 
                
                Case (path
                         , 
                         , splitter shapes splits)

end
