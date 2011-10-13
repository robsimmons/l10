(* Tables - state that is updated as signatures are loaded and checked *)
(* Robert J. Simmons *)

(* All stored information from the signature should be referenced here 
 * and reset with the master Reset.reset () *)

structure Tab = struct

   open HTabX
   val n = 1000
   val bind = insert


   (* Signature information *)

   (*[ val types: Class.knd table ]*)
   val types: Class.t table = table n

   (*[ val worlds: Class.world table ]*)
   val worlds: Class.t table = table n

   (*[ val rels: Class.rel table ]*)
   val rels: Class.t table = table n

   (*[ val cons: Class.typ table ]*)
   val cons: Class.t table = table n

   (* Reverse lookup: all the constructors used to make a term of a type *)
   (*[ val typecon: Symbol.symbol list table ]*)
   val typecon: Symbol.symbol list table = table n

   (*[ val typebind: Symbol.symbol -> Class.typ -> unit ]*)
   fun typebind c typ = 
      let val t = Class.base typ in
         HashX.insert cons c typ
         ; HashX.insertMerge typecon [ t ] (fn ts => t :: ts) 
      end


   (* Both dependencies and rules are indexed by the "head world" *)

   (*[ val dependencies: 
          (Pos.t 
           * (Pos.t * Atom.world) 
           * (Pos.t * Atom.world) list) 
          list table ]*)
   val dependencies: 
      (Pos.t * (Pos.t * Atom.t) * (Pos.t * Atom.t) list) list table = 
      table n 

   (*[ val rules: (Pos.t * Rule.rule) list table ]*)
   val rules: (Pos.t * Rule.t) list table


   (* Directives *)

   structure HTabPos = HashTable (structure Key = Pos.t)

(* World dependency table
 * For a world dependency w t1...tn <- W1, ..., Wm,
 * (where Wi = wi ti1 ... tik)
 * SearchTab.lookup w contains ([ t1, ..., tn ], [ w1, ..., wm ]) *)
structure SearchTab = Multitab(type entrytp = Ast.term list * Ast.world list)


   fun reset () = 
      let
         (*[ val plus: Class.typ ]*)
         val plustyp = 
            Class.Arrow 
               (Type.nat, (Class.Arrow (Type.nat, Class.Base Type.nat)))
      in
         HashX.reset types n
         ; HashX.reset worlds n
         ; HashX.reset rels n
         ; HashX.reset cons n
         ; HashX.reset typecon n
         ; typebind (Symbol.fromValue "_plus", plustyp)
         ; insert types Type.t Class.Extensible
         ; insert types Type.nat Class.Builtin
         ; insert types Type.string Class.Builtin
         ; insert types Type.world Class.Type
         ; insert types Type.rel Class.Type
      end
end



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


