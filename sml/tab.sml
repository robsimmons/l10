(* Tables - state that is updated as signatures are loaded and checked *)
(* Robert J. Simmons *)

(* All stored information from the signature should be referenced here 
 * and reset with the master Reset.reset () *)

(* XXX INTERFACE - this structure exposes that everything is a 
 * SymbolHashTable.table, but the invariants will only be maintained if they 
 * are used as Tab.tabs. *)

structure Tab = 
struct
   type 'a tab = 'a SymbolHashTable.table


   (* READING *)

   (*[ val app: 'a tab -> (Symbol.symbol * 'a -> unit) -> unit ]*)
   fun app tab f = SymbolHashTable.app f tab

   (*[ val find: 'a tab -> Symbol.symbol -> 'a option ]*)
   fun find tab x = SymbolHashTable.find tab x

   (*[ val list: 'a tab -> (Symbol.symbol * 'a) list ]*)
   fun list tab = SymbolHashTable.toList tab

   (*[ val fold: (Symbol.symbol * 'a * 'b -> 'b) -> 'b -> 'a tab -> 'b ]*)
   fun fold f x tab = SymbolHashTable.fold f x tab

   (*[ val lookup: 'a tab -> Symbol.symbol -> 'a ]*)
   fun lookup tab x = SymbolHashTable.lookup tab x

   (*[ val lookup_list: 'a list tab -> Symbol.symbol -> 'a list ]*)
   fun lookup_list tab x =
      case SymbolHashTable.find tab x of
         NONE => []
       | SOME values => values

   (*[ val member: 'a tab -> Symbol.symbol -> bool ]*)
   fun member tab x = SymbolHashTable.member tab x

   (*[ val range: 'a tab -> 'a list ]*)
   fun range tab = map #2 (SymbolHashTable.toList tab)


   (* SIGNATURE TABLES *)

   (*[ val types: Class.knd tab ]*)
   val types: Class.t tab = SymbolHashTable.table 1

   (*[ val worlds: Class.world tab ]*)
   val worlds: Class.t tab = SymbolHashTable.table 1

   (*[ val rels: Class.rel_t tab ]*)
   val rels: Class.t tab = SymbolHashTable.table 1

   (*[ val consts: Class.typ tab ]*)
   val consts: Class.t tab = SymbolHashTable.table 1

   (* Reverse lookup: all the constructors used to make a term of a type *)
   (*[ val typecon: SetX.set tab ]*)
   val typecon: SetX.set tab = SymbolHashTable.table 1

   (*[ val dbs: Decl.db tab ]*)
   val dbs: (Symbol.symbol * (Pos.t * Atom.t) list * (Pos.t * Atom.t)) tab =
      SymbolHashTable.table 1

   (* Both dependencies and rules are indexed by the "head world" *)

   (*[ sortdef depend = (Pos.t * Decl.depend_t * Type.env some) ]*)
   (*[ val depends: depend list tab ]*)
   val depends: 
      ( Pos.t 
      * ((Pos.t * Atom.t) * (Pos.t * Prem.t) list)
      * Type.env option) list tab = 
      (SymbolHashTable.table  
         (*[ <: int -> depend list tab ]*))
         1 

   (*[ sortdef rule = (Pos.t * Rule.rule_t * Type.env some) ]*)
   (*[ val rules: rule list tab ]*)
   val ruleid: int ref = ref 1
   val rules: (int * (Pos.t * Rule.t * Type.env option)) list tab =
      (SymbolHashTable.table
         (*[ <: int -> (Pos.t * Rule.rule_t * Type.env some) list tab ]*))
         1

   (*[ val queries: (Pos.t * Atom.moded_t) tab ]*)
   val queries: (Pos.t * Atom.t) tab = SymbolHashTable.table 1

   (* This one is populated directly from the parser *)
   val representations: Type.representation tab = SymbolHashTable.table 1

   (* WRITING *)

   val merge: 'a list tab -> Symbol.symbol -> 'a -> unit = 
      fn tab =>
      fn key =>
      fn value =>
      SymbolHashTable.insertMerge tab key [ value ] 
         (fn values => value :: values)

   val init: 'a list tab -> Symbol.symbol -> unit = 
      fn tab =>
      fn key =>
      SymbolHashTable.insertMerge tab key []
         (fn values => values)

   local 
      fun mergeTypecon t c = 
         SymbolHashTable.insertMerge typecon t
            (SetX.singleton c) (* Shouldn't ever be used *)
            (fn set => SetX.insert set c)
   in

   (*[ val bind: Decl.decl_t -> unit ]*)
   (* Loads a (presumed to be fully checked) declaration into the database. *)
   fun bind (Decl.World (_, w, class)) = 
        ( SymbolHashTable.insert worlds w class
        ; SymbolHashTable.insert consts w (Class.worldToTyp class)
        ; (init (*[ <: depend list tab -> Symbol.symbol -> unit ]*)) depends w 
        ; mergeTypecon Type.world w)
     | bind (Decl.Const (_, c, class)) =
       let val t = Class.base class 
       in  
        ( SymbolHashTable.insert consts c class
        ; mergeTypecon t c)
       end
     | bind (Decl.Rel (pos, r, class)) = 
       let 
          val outputs = 
             map (fn t => Term.Mode (Mode.Input, SOME t)) (Class.argtyps class)
       in
        ( SymbolHashTable.insert rels r class 
        ; SymbolHashTable.insert consts r (Class.relToTyp class)
        ; SymbolHashTable.insert queries r (pos, (r, outputs))
        ; mergeTypecon Type.rel r)
       end
     | bind (Decl.Type (_, a, class)) = 
        ( SymbolHashTable.insert types a class
        ; SymbolHashTable.insert typecon a SetX.empty)
     | bind (Decl.DB (pos, (db as (d, _, _)))) = SymbolHashTable.insert dbs d db
     | bind (Decl.Depend (depend as (_, ((_, (w, _)), _), _))) =
         (merge (*[ <: depend list tab -> Symbol.symbol -> depend -> unit ]*)) 
             depends w depend
     | bind (Decl.Rule (rule as (_, (_, concs), _))) = 
       let
          val (_, (r, _)) = hd concs
          val class = SymbolHashTable.lookup rels r
          val (w, _) = Class.rel class
       in 
         (merge
            (*[ <: (int * rule) list tab -> Symbol.symbol -> rule -> unit ]*))
            rules w (!ruleid, rule) 
         before ruleid := !ruleid + 1
       end
     | bind (Decl.Query (pos, m, mode)) = 
          SymbolHashTable.insert queries m (pos, mode)
     | bind (Decl.Representation (pos, t, rep)) =
          SymbolHashTable.insert representations t rep
   end

   local 
      val coord = Coord.init "?"
      val pos = Pos.pos coord coord
     
      (*[ val plus: Decl.decl_t ]*) 
      val plus = 
         Decl.Const
            (pos, 
             Symbol.fromValue "_plus", 
             Class.Arrow 
                 (Type.nat, (Class.Arrow (Type.nat, Class.Base Type.nat))))

      val n = 1000 
      val default_world = Symbol.fromValue "world"
   in
   fun reset () = 
    ( ruleid := 1
    ; SymbolHashTable.reset types n
    ; SymbolHashTable.reset worlds n
    ; SymbolHashTable.reset rels n
    ; SymbolHashTable.reset consts n
    ; SymbolHashTable.reset typecon n
    ; SymbolHashTable.reset dbs n
    ; SymbolHashTable.reset depends n
    ; SymbolHashTable.reset rules n
    ; SymbolHashTable.reset queries n
    ; SymbolHashTable.reset representations n
    ; bind plus
    ; bind (Decl.Type (pos, Type.nat, Class.Builtin))
    ; bind (Decl.Type (pos, Type.string, Class.Builtin))
    ; bind (Decl.Type (pos, Type.world, Class.Type))
    ; bind (Decl.Type (pos, Type.rel, Class.Type))
    ; bind (Decl.World (pos, default_world, Class.World))
    ; bind (Decl.Representation (pos, Type.world, Type.Transparent))
    ; bind (Decl.Representation (pos, Type.rel, Type.Transparent)))
   end

   val () = reset ()
end 
