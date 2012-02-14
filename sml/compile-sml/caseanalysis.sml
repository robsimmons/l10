
structure CaseAnalysis:> sig

   datatype t = 
      Done of Term.t list
    | Case of (Type.t * Path.t) * (Term.t * t) list * t option

   (*[
   datasort cases = 
      Done of Term.shape list
    | Case of (Type.t * Path.t) * (Term.pat * cases) list * cases option
   ]*)

   (*[ val cases: (int * Splitting.t) list -> cases ]*)
   val cases: (int * Splitting.t) list -> t

   (*[ val emit: 
          string -> (string * Term.shape list -> unit) -> cases -> unit ]*)
   val emit: string -> (string * Term.t list -> unit) -> t -> unit 


end =
struct

datatype t = 
   Done of Term.t list
 | Case of (Type.t * Path.t) * (Term.t * t) list * t option

(*[
datasort cases = 
   Done of Term.shape list
 | Case of (Type.t * Path.t) * (Term.pat * cases) list * cases option
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
                Case ((t, path)
                     , map (caser shapes splits path)
                           (map' Term.SymConst (SetX.toList set))
                     , SOME (splitter shapes splits))
           | Splitting.Nat set => 
                Case ((Type.nat, path)
                     , map (caser shapes splits path)
                           (map' Term.NatConst (IntInfSplaySet.toList set))
                     , SOME (splitter shapes splits))
           | Splitting.Str set =>
                Case ((Type.string, path)
                     , map (caser shapes splits path)
                          (map' Term.StrConst (StringSplaySet.toList set))
                     , SOME (splitter shapes splits))
           | Splitting.Root {t, covered, uncovered} => 
             let 
                val Datatypes.DT {arms, ...} = Datatypes.dtype t
                val arms = List.filter (DictX.member covered o #1) arms 
                
                (*[ val mapper: 
                       (Symbol.symbol * string * int * Datatypes.subterm list)
                       -> (Term.pat * (int * Splitting.t) list) ]*)
                fun mapper (c, cstr, ndx, []) = 
                       (Term.SymConst c, DictX.lookup covered c)
                  | mapper (f, cstr, ndx, (args as _ :: _)) = 
                    let 
                       (*[ val subtermize: Datatypes.subterm -> Term.path ]*)
                       fun subtermize {t, ts, mutual, n} = 
                          Term.Path (path @ [ n ], t)
                    in 
                       (Term.Root (f, map subtermize args)
                        , DictX.lookup covered f)
                    end

                (*[ val normal: (Term.pat * cases) list ]*)
                val normal = map (caser shapes splits path) (map mapper arms)

                (*[ val catchall: cases option ]*)
                val catchall = 
                   if SetX.isEmpty uncovered then NONE
                   else SOME (splitter shapes splits)
             in 
                Case ((Splitting.typ split, path), normal, catchall)
             end
       end

   (* first arg: (int * Splitting.t) list -> Term.shape list ]*)
   (* secnd arg: (int * Splitting.t) list -> (Path.t * Splitting.t) list ]*)
in
   splitter 
      (map (fn (i, split) => Term.Path ([ i ], Splitting.typ split)) splits)
      (map (fn (i, split) => ([ i ], split)) splits)
end

(*[ val emit: string -> (string * Term.shape list -> unit) -> cases -> unit ]*)
fun emit postfix (f: string * Term.t list -> unit) cases = 
   case cases of 
      Done shapes => 
       ( Util.incr ()
       ; f (postfix, shapes)
       ; Util.decr ())
    | Case ((t, path), cases, catchall) =>
      let val postfix' = if Option.isSome catchall then "" else postfix ^ ")"
      in
       ( Util.emit ["  (case "
                    ^ Strings.prj t (Path.toVar path) ^ " of "]
       ; Util.appSuper 
            (fn () => 
              Util.emit ["      _ => raise Match (* impossible *)" ^ postfix'])
            (fn (term, cases) => 
              ( Util.emit ["      " ^ Strings.match term ^ " =>"]
              ; Util.incr (); Util.incr ()
              ; emit postfix' f cases
              ; Util.decr (); Util.decr ()))
            ((fn (term, cases) => 
               ( Util.emit ["      " ^ Strings.match term ^ " =>"]
               ; Util.incr (); Util.incr ()
               ; emit "" f cases 
               ; Util.decr (); Util.decr ())),
             (fn (term, cases) => 
                ( Util.emit ["    | " ^ Strings.match term ^ " =>"]
                ; Util.incr (); Util.incr ()
                ; emit "" f cases 
                ; Util.decr (); Util.decr ())),
             (fn (term, cases) => 
                ( Util.emit ["    | " ^ Strings.match term ^ " =>"]
                ; Util.incr (); Util.incr ()
                ; emit postfix' f cases 
                ; Util.decr (); Util.decr ())))
            cases
       ; case catchall of 
            NONE => () 
          | SOME cases => 
             ( Util.emit ["    | _ =>"]
             ; Util.incr (); Util.incr ()
             ; emit (postfix ^ ")") f cases 
             ; Util.decr (); Util.decr ()))
      end

end (* struct *)
