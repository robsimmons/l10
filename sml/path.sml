(* A path uniquely identifies a position in a term *)

structure Path =
struct
   type t = int list

   fun toString path = String.concatWith "_" (map Int.toString path)

   fun toVar path = "x_" ^ toString path

   structure Set =
      SplaySetFun (structure Elem = ListOrdered (IntOrdered))
   structure Dict = 
      SplayDictFun (structure Key = ListOrdered (IntOrdered))

   (* subst N path M = N [M/path] *)
   (*[ val subst: Term.shape -> t -> Term.shape -> Term.shape ]*)
   fun subst (Term.Var (NONE, SOME t)) [] newshape = newshape
     | subst (Term.Root (f, shapes)) path newshape = 
          Term.Root (f, substs shapes path newshape)
     | subst path shapes = raise Fail "Path.subst"
   
   (* subst Ns path M = Ns [M/path] *)
   (*[ val substs: Term.shape list -> t -> Term.shape -> Term.shape list ]*)
   fun substs [] _ _ = raise Invariant
     | substs (i :: path) newshape shapes =
        ( if length shapes <= i then raise Fail "Path.substs" else ()
        ; (List.take (terms, i)
           @ [ subst (path, List.nth (terms, i), terms) ]
           @ tl (List.drop (terms, i))))
end

