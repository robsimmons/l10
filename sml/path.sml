(* A path uniquely identifies a position in a term *)

structure Path =
struct
   type t = int list

   fun toString path = String.concatWith "_" (map Int.toString path)

   fun toVar path = "x_" ^ toString path

   structure Set = SplaySet (structure Elem = ListOrdered (IntOrdered))
   structure Dict = SplayDict (structure Key = ListOrdered (IntOrdered))

   (*[ val subst: Term.shape * t -> Term.shape -> Term.shape ]*)
   (*[ val substs: Term.shape * t -> 
          ( Term.shape list -> Term.shape list 
          & Term.shape conslist -> Term.shape conslist) ]*)
   fun subst (newshape, []) (Term.Path _) = newshape
     | subst (newshape, path) (Term.Root (f, shapes)) = 
          Term.Root (f, substs (newshape, path) shapes)
     | subst (newshape, path) shapes = raise Fail "Path.subst"
   
   and substs (_, []) _ = raise Fail "Path.substs"
     | substs (newshape, i :: path) shapes =
        ( if length shapes <= i then raise Fail "Path.substs" else ()
        ; (List.take (shapes, i)
           @ [ subst (newshape, path) (List.nth (shapes, i)) ]
           @ tl (List.drop (shapes, i))))

   (*[ val eq: t * t -> bool ]*)
   fun eq (p1, p2 : t) = ListPair.allEq (fn (x, y) = x = y) (p1, p2)
end

