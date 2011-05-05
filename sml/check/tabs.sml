(* Tables - state that is updated as signatures are loaded and checked *)
(* Robert J. Simmons *)

(* All stored information from the signature should be referenced here 
 * and reset with the master Reset.reset () *)

(* Type table
 * TypeTab.lookup (Symbol.name "t") = CONSTANTS,
 * TypeTab.lookup (Symbol.name "nat") = SPECIAL,
 * TypeTab.lookup tp = NO ("not extensible") for other valid types. *)
(* XXX change "NO" to "NORMAL," probably -RJS 5/5/11 *)
structure TypeTab = 
struct
   datatype extensible = YES | NO | CONSTANTS | SPECIAL 
   structure S = Symtab(type entrytp = extensible val name = "TypeTab")
   open S
   val t = Symbol.symbol "t"
   val nat = Symbol.symbol "nat"
   val string = Symbol.symbol "string"
   val world = Symbol.symbol "world"
   val rel = Symbol.symbol "rel"
   fun reset () = 
      let in
         S.reset ()
         ; bind (t, CONSTANTS)
         ; bind (nat, SPECIAL)
         ; bind (string, SPECIAL)
         ; bind (world, NO)
         ; bind (rel, NO)
      end
   val () = reset ()
end 

(* World constant table
 * For a world constant w : tp1 -> ... -> tpn -> world.
 * WorldTab.lookup w = [ tp1, ..., tpn ] *)
structure WorldTab = Symtab(type entrytp = Ast.typ list val name = "WorldTab")

(* Relation constant table
 * For a relation constant r : tp1 -> ... -> {Tn: tpn} -> rel @ W,
 * RelTab.lookup r = ([ (NONE, tp1), ..., (SOME Tn, tpn) ], W) *)
structure RelTab = Symtab(type entrytp = Ast.arg list * Ast.world
val name = "RelTab")

(* TypeCon table
 * Reverse lookup - lists all the constructors that can be used to make 
 * a term of a particular type. *)
structure TypeConTab = Multitab(type entrytp = Symbol.symbol)

(* Term constant table
 * For a term constant a : tp1 -> ... -> tpn -> tp, 
 * ConTab.lookup a = ([ tp1, ..., tpn ], tp) *)
structure ConTab = 
struct
   structure S = Symtab(type entrytp = Ast.typ list * Ast.typ 
   val name = "ConTab")

   open S

   val plus = Symbol.symbol "_plus"

   fun reset () = 
      let in
         S.reset ()
         ; bind (plus, ([ TypeTab.nat, TypeTab.nat ], TypeTab.nat))
      end

   fun bind (x, (typs, typ)) = 
      let in 
         S.bind (x, (typs, typ))
         ; TypeConTab.bind (typ, x)
      end

   val () = reset ()
end

(* World dependency table
 * For a world dependency w t1...tn <- w1, ..., wm,
 * SearchTab.lookup w contains ([ t1, ..., tn ], [ w1, ..., wm ]) *)
structure SearchTab = Multitab(type entrytp = Ast.term list * Ast.world list)

(* Rule table 
 * Rules are given identifying names (integers) when loaded into the table,
 * and can be taken as a list or looked up by world name. *)
structure RuleTab :> sig
   val reset: unit -> unit
   val register: Ast.world * Ast.rule -> unit
   val lookup: Symbol.symbol -> (int * Ast.world * Ast.rule) list
   val list: unit -> (int * Ast.world * Ast.rule) list
end = struct

   val next = ref 0 
   val database: (int * Ast.world * Ast.rule) list ref = ref []
   fun reset () = (database := []; next := 0)

   fun register (world, rule) = 
      (database := (!next, world, rule) :: !database; next := !next + 1)

   fun lookup' w (n, world : Ast.world, rule) = 
      if w = #1 world then SOME (n, world, rule) else NONE

   fun lookup w = List.mapPartial (lookup' w) (!database)
     
   fun list () = !database
                  
end

(* Database table
 * Straightforward: map from database names to their contents. *)
structure DbTab = Symtab(type entrytp = Ast.atomic list * Ast.world 
val name = "DbTab")

structure Reset = struct
   fun reset () = 
      (TypeTab.reset ()
       ; WorldTab.reset ()
       ; ConTab.reset ()
       ; TypeConTab.reset ()
       ; RelTab.reset ()
       ; SearchTab.reset ()
       ; RuleTab.reset ()
       ; DbTab.reset ())
end



