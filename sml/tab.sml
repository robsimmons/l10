(* Tables - state that is updated as signatures are loaded and checked *)
(* Robert J. Simmons *)

(* All stored information from the signature should be referenced here 
 * and reset with the master Reset.reset () *)

(* XXX INTERFACE - this structure exposes that everything is a HTabX.table, 
 * but, as an invariant, *)

structure Tab = 
struct
   type 'a tab = 'a HTabX.table


   (* READING *)

   (*[ val find: 'a tab -> Symbol.symbol -> 'a option ]*)
   fun find tab x = HTabX.find tab x

   (*[ val lookup: 'a tab -> Symbol.symbol -> 'a ]*)
   fun lookup tab x = HTabX.lookup tab x

   (*[ val lookup_list: 'a list tab -> Symbol.symbol -> 'a list ]*)
   fun lookup_list tab x =
      case HTabX.find tab x of
         NONE => []
       | SOME values => values

   (*[ val list: 'a tab -> (Symbol.symbol * 'a) list ]*)
   fun list tab = HTabX.toList tab

   (*[ val range: 'a tab -> 'a list ]*)
   fun range tab = map #2 (HTabX.toList tab)

   (*[ val app: 'a tab -> (Symbol.symbol * 'a -> unit) -> unit ]*)
   fun app tab f = HTabX.app f tab


   (* SIGNATURE TABLES *)

   (*[ val types: Class.knd tab ]*)
   val types: Class.t tab = HTabX.table 1

   (*[ val worlds: Class.world tab ]*)
   val worlds: Class.t tab = HTabX.table 1

   (*[ val rels: Class.rel tab ]*)
   val rels: Class.t tab = HTabX.table 1

   (*[ val cons: Class.typ tab ]*)
   val cons: Class.t tab = HTabX.table 1

   (* Reverse lookup: all the constructors used to make a term of a type *)
   (*[ val typecon: Symbol.symbol list tab ]*)
   val typecon: Symbol.symbol list tab = HTabX.table 1

   (*[ val dbs: Decl.db tab ]*)
   val dbs: (Symbol.symbol * (Pos.t * Atom.t) list * (Pos.t * Atom.t)) tab =
      HTabX.table 1

   (* Both dependencies and rules are indexed by the "head world" *)

   (*[ val depends: (Pos.t * Decl.depend) list tab ]*)
   val depends: 
      (Pos.t * ((Pos.t * Atom.t) * (Pos.t * Atom.t) list)) list tab = 
      HTabX.table 1 

   (*[ val rules: (Pos.t * Rule.rule) list tab ]*)
   val rules: (Pos.t * Rule.t) list tab = HTabX.table 1

   (*[ val queries: (Pos.t * Atom.moded_t) tab ]*)
   val queries: (Pos.t * Atom.t) tab = HTabX.table 1


   (* WRITING *)

   (*[ val bind: Decl.decl_t -> unit ]*)
   (* Loads a (presumed to be fully checked) declaration into the database. *)
   fun bind (Decl.World (_, w, class)) = 
         ( HTabX.insert worlds w class
         ; HTabX.insert cons w (Class.worldToTyp class))
     | bind (Decl.Const (_, c, class)) =
         let val t = Class.base class in  
            ( HTabX.insert cons c class
            ; HTabX.insertMerge typecon t [ c ] (fn cs => c :: cs))
         end
     | bind (Decl.Rel (_, r, class)) = 
         ( HTabX.insert rels r class 
         ; HTabX.insert cons r (Class.relToTyp class))
     | bind (Decl.Type (_, a, class)) = HTabX.insert types a class
     | bind (Decl.DB _) = raise Match
     | bind (Decl.Depend (depend as (_, ((_, (w, _)), _)))) =
         HTabX.insertMerge depends w [ depend ] (fn ds => depend :: ds)
     | bind (Decl.Rule (rule as (_, (_, concs)))) = 
         let
            val (_, (r, _)) = hd concs
            val class = HTabX.lookup rels r
            val (w, _) = Class.rel class
         in HTabX.insertMerge rules w [ rule ] (fn rules => rule :: rules) end
     | bind (Decl.Query (pos, m, mode)) = 
         HTabX.insert queries m (pos, mode)
            
   local 
      val coord = Coord.init "?"
      val pos = Pos.pos coord coord
     
      (*[ val plus: Decl.decl ]*) 
      val plus = 
         Decl.Const
            (pos, 
             Symbol.fromValue "_plus", 
             Class.Arrow 
                 (Type.nat, (Class.Arrow (Type.nat, Class.Base Type.nat))))

      val n = 1000 
   in
   fun reset () = 
      ( HTabX.reset types n
      ; HTabX.reset worlds n
      ; HTabX.reset rels n
      ; HTabX.reset cons n
      ; HTabX.reset typecon n
      ; bind plus
      ; bind (Decl.Type (pos, Type.t, Class.Extensible))
      ; bind (Decl.Type (pos, Type.nat, Class.Builtin))
      ; bind (Decl.Type (pos, Type.string, Class.Builtin))
      ; bind (Decl.Type (pos, Type.world, Class.Type))
      ; bind (Decl.Type (pos, Type.rel, Class.Type)))
   end

   val () = reset ()
end 
