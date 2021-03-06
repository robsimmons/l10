(* Mode checking *)

structure Modes:> 
sig
   exception ModeError of Pos.t * string
   exception WorldsError of Pos.t * string
   exception NegationError of Pos.t * string
   exception DynamicError of Pos.t * Symbol.symbol

   (* Mode checks and rewrites rules: 
      * Turns equality judgments around so that the first half of the
        equality is always ground.
      * Adds Prem.WorldStatic and Prem.WorldDyn premises (the latter
        are only allowed if the first argument is true) to represent 
        worlds that need to be searched for statically and dynamically.
      * (XXX TODO): Turns reasonable uses of "plus" into a successor pattern.*)
   (*[ val check: bool -> Rule.rule_t -> Atom.world_t * Rule.rule_checked ]*)
   val check: bool -> Rule.t -> (Atom.t * Rule.t) 
end = 
struct

exception Invariant
exception ModeError of Pos.t * string
exception WorldsError of Pos.t * string
exception NegationError of Pos.t * string
exception DynamicError of Pos.t * Symbol.symbol

(* Ensure that all the conclusions are at the same world *)
(*[ val checkConcWorlds: Atom.world_t -> (Pos.t * Atom.prop_t) list -> unit ]*)
fun checkConcWorlds world [] = ()
  | checkConcWorlds world (conc :: concs) = 
    let
       val (pos, world') = Worlds.ofProp conc
    in 
       if Atom.eq (world, world') 
       then checkConcWorlds world concs
       else raise ModeError (pos,
                             "World associated with conclusion `"
                             ^Atom.toString (#2 conc)^"` is `"
                             ^Atom.toString world'^"`, which differs from \
                             \earlier conclusions assoiated with world `"
                             ^Atom.toString world^"`")
    end


(* Gets the world from a pattern, and check that the world is appropriately
 * grounded. Also generates the extra "world" premese that are generated
 * by this phase. *)
(*[ val updateWorlds: bool 
       -> bool
       -> Atom.world_t conslist (* First element is the conclusion's world *)
       -> SetX.set
       -> SetX.set
       -> Pat.pat_t
       -> Pos.t
       -> Atom.world_t * Atom.world_t list * Prem.prem_checked list ]*)
fun worldPat isDyn isNeg seenWorlds worldVars groundVars pat pos = 
let
   val (world, vars) = Worlds.ofPat pos pat
(* val () = print ("    Head world: "^ Atom.toString (hd seenWorlds) ^ "\n")
   val () = print ("    This world: "^ Atom.toString world ^ "\n") *)
in
   if isNeg andalso Atom.eq (world, hd seenWorlds)
   then raise NegationError (pos, "The world associated with the conclusion, `"
                                  ^Atom.toString world^"`, cannot be the same \
                                  \as the world associated with a negated \
                                  \premise.")
   else if List.exists (fn x => Atom.eq (world, x)) seenWorlds
   then (hd seenWorlds, tl seenWorlds, [])
   else if not (SetX.subset (vars, groundVars))
   then raise WorldsError 
                 (pos, 
                  "The variable `"
                  ^Symbol.toValue 
                      (hd (SetX.toList (SetX.difference vars groundVars)))
                  ^"` determines the world in this premise but is not ground.")
   else if Atom.hasUscore world
   then raise WorldsError (pos, ("Underscore present where argument\
                                 \ is needed to determine world"))
       
   else if SetX.subset (vars, worldVars)
   then (hd seenWorlds, world :: tl seenWorlds, 
         [ (pos, Prem.WorldStatic world) ])
   else if isDyn
   then (hd seenWorlds, world :: tl seenWorlds,
         [ (pos, Prem.WorldDynamic world) ])
   else raise DynamicError 
                 (pos, hd (SetX.toList (SetX.difference vars worldVars)))
end

(* checkPrems isDyn (concWorld, seenWorlds) prems worldVars freeVars *)
(*[ val checkPrems: bool
       -> Atom.world_t * Atom.world_t list 
       -> (Pos.t * Prem.prem_t) list 
       -> SetX.set
       -> SetX.set
       -> (Pos.t * Prem.prem_checked) list * SetX.set ]*)
fun checkPrems isDyn seenWorlds prems worldVars groundVars = 
   case prems of 
      [] => ([], groundVars)
    | (pos, Prem.Normal pat) :: prems => 
      let
         val (concWorld, premWorlds, newprems) = 
            worldPat isDyn false ((op ::) seenWorlds) worldVars groundVars
               pat pos
         val (prems', groundVars') = 
            checkPrems isDyn (concWorld, premWorlds) prems worldVars
               (SetX.union groundVars (Pat.fv pat))
      (* val pat = ground_modify_pat groundVars pat *)
      in
         (newprems @ (pos, Prem.Normal pat) :: prems', groundVars')
      end
    | (pos, Prem.Negated pat) :: prems => 
      let
         val (concWorld, premWorlds, newprems) = 
            worldPat isDyn true ((op ::) seenWorlds) worldVars groundVars
               pat pos
         val () = 
            case SetX.toList (SetX.difference (Pat.fv pat) groundVars) of
               [] => ()
             | x :: _ => raise ModeError (pos, ("Variable `" 
                                                ^Symbol.toValue x
                                                ^"` in negated premise not \
                                                \ground"))
         val (prems', groundVars') = 
            checkPrems isDyn (concWorld, premWorlds) prems worldVars
               (SetX.union groundVars (Pat.fv pat))
      (* val pat = ground_modify_pat groundVars pat *)
      in
         (newprems @ (pos, Prem.Negated pat) :: prems', groundVars')         
      end
    | (pos, Prem.Binrel (Binrel.Eq, term1, term2, SOME t)) :: prems => 
      let 
         val (fv1, fv2) = (Term.fv term1, Term.fv term2) 
         val (prems', groundVars') = 
            checkPrems isDyn seenWorlds prems worldVars
               (SetX.union groundVars (SetX.union fv1 fv2))
      (* val term1 = ground_modify_term something something? *)
      (* val term2 = ground_modify_term something something? *)
      in 
         if SetX.subset (fv1, groundVars)
         then ((pos, Prem.Binrel (Binrel.Eq, term1, term2, SOME t)) :: prems',
               groundVars')
         else if SetX.subset (fv2, groundVars)
         then ((pos, Prem.Binrel (Binrel.Eq, term2, term2, SOME t)) :: prems',
               groundVars')
         else raise ModeError (pos, ("Cannot check for equality between\
                                     \ two non-ground-terms"))
      end
    | (pos, Prem.Binrel (binrel, term1, term2, SOME t)) :: prems => 
      let 
         val (prems', groundVars') = 
            checkPrems isDyn seenWorlds prems worldVars groundVars
      in
         case SetX.toList 
                 (SetX.difference 
                     (SetX.union (Term.fv term1) (Term.fv term2))
                     groundVars) of
            [] => 
               ((pos, Prem.Binrel (binrel, term1, term2, SOME t)) :: prems',
                groundVars')
          | x :: _ => raise ModeError (pos, "Variable `"^Symbol.toValue x
                                            ^"` in comparison not ground")
      end


(*[ val checkConcs: 
       SetX.set
       -> (Pos.t * Atom.prop_t) list 
       -> (Pos.t * Atom.prop_t) list ]*)
fun checkConcs groundVars: (Pos.t * Atom.t) list -> (Pos.t * Atom.t) list =
let
   (*[ val checkConcArgs: 
          Pos.t -> Term.term_t list -> Class.rel_t -> Term.term_t list ]*)
   fun checkConcArgs pos terms class = 
      case class of 
         Class.Rel _ => []
       | Class.Arrow (_, class) =>
         (* This index is not grounded by the world, and must be checked. *)
         let val fv = Term.fv (hd terms) 
         in 
            case SetX.toList (SetX.difference fv groundVars) of 
               [] => ()
             | x :: _ => 
                  raise ModeError (pos, "Variable `"^Symbol.toValue x
                                        ^"` in conclusion not ground")
          ; if Term.hasUscore (hd terms)
            then raise ModeError (pos, "Underscore in illegal position \
                                       \in conclusion")
            else ()
          ; hd terms :: checkConcArgs pos (tl terms) class
         end
       | Class.Pi (_, _, class) =>
         (* This index is grounded by the world, and can be ignored. *)
            hd terms :: checkConcArgs pos (tl terms) class 

   (*[ val checkConc: (Pos.t * Atom.prop_t) -> (Pos.t * Atom.prop_t) ]*)
   fun checkConc (pos, (a, terms)) = 
      (pos, (a, checkConcArgs pos terms (Tab.lookup Tab.rels a)))
in
   map checkConc
end
 

(*[ val check: bool -> Rule.rule_t -> Atom.world_t * Rule.rule_checked ]*)
fun check isDyn (prems, concs) = 
let 
   (* Check the worlds of the conclusions *)
   val world = #2 (Worlds.ofProp (hd concs))
   val () = checkConcWorlds world concs
(* val world = ground_modify_atom SetX.empty world *)

   val worldVars = Atom.fv world 
   val (checked_prems, groundVars) = 
      checkPrems isDyn (world, []) prems worldVars worldVars 
in
   (world, (checked_prems, checkConcs groundVars concs))
end

end
