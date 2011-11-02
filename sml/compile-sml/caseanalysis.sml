
structure CaseAnalysis =
struct

datatype t = 
   Done of Term.t list
 | Case of (Type.t * Path.t) * (Term.t * t) list * t option
 | Sym of Path.t * (Term.t * t) list * t
 | Nat of Path.t * (Term.t * t) list * t
 | Str of Path.t * (Term.t * t) list * t

(*[
datasort cases = 
   Done of Term.shape list
 | Case of (Type.t * Path.t) * (Term.pat * cases) list * cases option
 | Sym of Path.t * (Term.pat * cases) list * cases
 | Nat of Path.t * (Term.pat * cases) list * cases
 | Str of Path.t * (Term.pat * cases) list * cases
]*)

(*[ cases: (int * Splitting.t) list -> cases ]*)
fun cases splits = 
let 
   (*[ val caser: 
          Term.shape list 
          -> (Path.t * Splitting.t) list 
          -> Path.t
          -> (Term.pat * (int * Splitting.t) list) 
          -> (Term.pat * cases) ]*)

   (*[ val splitter: 
          Term.shape list
          -> (Path.t * Splitting.t) list
          -> cases ]*)
   fun caser shapes splits path (term, newsplits) =
   let 
      val shapes' = Path.substs (term, path) shapes
      val newsplits' = map (fn (x, t) => (path @ [ x ], t)) newsplits
   in 
      (term, splitter shapes' (splits @ newsplits'))
   end

   and splitter shapes [] = Done shapes
     | splitter shapes ((path, split) :: splits) = 
       let
          (*[ val map': ('a -> 'b) -> 'a list 
                 -> ('b * (int * Splitting.t) list) list ]*) 
          fun map' f = map (fn x => (f x, []))
       in case split of  
             Splitting.Unsplit t => splitter shapes splits
           | Splitting.Sym (t, set) => 
                Sym (path
                     , map (caser shapes splits path)
                           (map' Term.SymConst (SetX.toList set))
                     , splitter shapes splits)
           | Splitting.Nat set => 
                Nat (path
                     , map (caser shapes splits path)
                           (map' Term.NatConst (IntInfSplaySet.toList set))
                     , splitter shapes splits)
           | Splitting.Str set =>
                Str (path
                     , map (caser shapes splits path)
                          (map' Term.StrConst (StringSplaySet.toList set))
                     , splitter shapes splits)
           | Splitting.Root {t, covered, uncovered} => 
             let 
                val Datatypes.DT {arms, ...} = Datatypes.dtype t
                val arms = List.filter (DictX.member covered o #1) arms 
                
                fun mapper (c, cstr, ndx, []) = 
                       (Term.SymConst c, DictX.lookup covered c)
                  | mapper (f, cstr, ndx, (args as _ :: _)) = 
                    let 
                       fun subtermize {t, ts, mutual, n} = 
                          Term.Path (path @ [ n ], t)
                    in 
                       (Term.Root (f, map subtermize args)
                        , DictX.lookup covered f)
                    end
             in 
                Case ((Splitting.typ split, path)
                      , map (caser shapes splits path) (map mapper arms)
                      , if SetX.isEmpty uncovered then NONE
                        else SOME (splitter shapes splits))
             end
       end

   (* first arg: (int * Splitting.t) list -> Term.shape list ]*)
   (* secnd arg: (int * Splitting.t) list -> (Path.t * Splitting.t) list ]*)
in
   splitter 
      (map (fn (i, split) => Term.Path ([ i ], Splitting.typ split)) splits)
      (map (fn (i, split) => ([ i ], split)) splits)
end

end (* struct *)
