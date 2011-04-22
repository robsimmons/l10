(* Tables - state that is updated as signatures are loaded and checked *)

(* Type table
 * 
 * Term types are either extensible (the type "t") or not. 
 * TypeTab.lookup "t" = SOME true, 
 * TypeTab.lookup tp = SOME false for other valid types. *)
structure TypeTab = 
struct
   datatype extensible = YES | NO | CONSTANTS | SPECIAL
   structure S = Symtab(type entrytp = extensible)
   open S
   val t = Symbol.symbol "t"
   val nat = Symbol.symbol "nat"
   val string = Symbol.symbol "string"
   fun reset () = 
      let in
         S.reset ()
         ; bind (t, CONSTANTS)
         ; bind (nat, SPECIAL)
         ; bind (string, SPECIAL)
      end
   val () = reset ()
end 

(* World constant table
 *
 * For a world constant w : tp1 -> ... -> tpn -> world.
 * WorldTab.lookup w = SOME ([ tp1, ..., tpn ]) *)
structure WorldTab = Symtab(type entrytp = Ast.typ list)

(* Term constant table
 *
 * For a term constant a : tp1 -> ... -> tpn -> tp, 
 * ConTab.lookup a = SOME ([ tp1, ..., tpn ], tp) *)
structure ConTab = 
struct
   structure S = Symtab(type entrytp = Ast.typ list * Ast.typ)
   open S
   val plus = Symbol.symbol "_plus"
   fun reset () = 
      let in
         S.reset ()
         ; bind (plus, ([ TypeTab.nat, TypeTab.nat ], TypeTab.nat))
      end
   val () = reset ()
end

(* Database table *)
structure DbTab = Symtab(type entrytp = Term.atomic list * Term.world)

(* Relation constant table
 *
 * For a relation constant r : tp1 -> ... -> {Tn: tpn} -> rel @ W,
 * RelTab.lookup r = SOME ([ (NONE, tp1), ..., (SOME Tn, tpn) ], W) *)
structure RelTab = Symtab(type entrytp = Ast.arg list * Ast.world)

(* World dependency table
 *
 * For a world dependency w t1...tn <- w1, ..., wm,
 * SearchTab.lookup w contains ([ t1, ..., tn ], [ w1, ..., wm ]) *)
structure SearchTab = Multitab(type entrytp = Ast.term list * Ast.world list)

structure RuleTab :> sig
   val reset: unit -> unit
   val register: Ast.world * Ast.rule -> unit
   val lookup: Term.world -> (Subst.subst * Ast.rule) list 
end = struct

   val database: (Ast.world * Ast.rule) list ref = ref []
   fun reset () = database := []
   fun register data = database := data :: !database

   fun lookup' world' (world, rule) = 
      case Match.matchWorld Subst.empty world world' of
         NONE => NONE
       | SOME subst => SOME (subst, rule)

   fun lookup world = List.mapPartial (lookup' world) (!database)

end

structure Reset = struct
   fun reset () = 
      (TypeTab.reset ()
       ; WorldTab.reset ()
       ; ConTab.reset ()
       ; RelTab.reset ()
       ; SearchTab.reset ()
       ; RuleTab.reset ())
end
