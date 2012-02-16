
structure Interface:> 
sig
   (* emitSig MODULE_NAME *)
   val emitSig: string -> unit
 
   (* emitStructHead ModuleName MODULE_NAME *)
   val emitStructHead: string -> string -> unit

   (* emitStruct tables *)
   val emitStruct: Indices.tables -> unit
end =
struct

open Util

fun buffer tab =
let
   val max = Tab.fold (fn (x, _, i) => Int.max (i, size (Symbol.toValue x)))
                0 tab
in
   fn x => 
   let
      val s = Symbol.toValue x
      val buf = String.implode (List.tabulate (max - size s, (fn _ => #" "))) 
   in
      buf
   end
end

fun emitSig MODULE_NAME = 
let 
   val typeBuf = buffer Tab.types
   val relBuf = buffer Tab.rels
   val queryBuf = buffer Tab.queries
  
   (*[ val typedecl: Type.t * Class.knd -> unit ]*)
   fun typedecl (t, knd) = 
   let 
      val knds = 
         case knd of 
            Class.Type => "(* = "^Strings.typ t^", sealed *)"
          | Class.Builtin => "   = "^Strings.typ t^" (* builtin *)"
          | Class.Extensible => "   = Symbol.symbol (* extensible *)"
      val representation =
         case Tab.find Tab.representations t of
            SOME Type.Transparent => "(* = "^Strings.typ t^" *)"
          | SOME Type.HashConsed => "(* = "^Strings.typ t^", hashconsed *)"
          | SOME Type.External => "   = "^Strings.typ t^" (* external *)"
          | SOME Type.Sealed => "(* = "^Strings.typ t^", sealed *)"
          | NONE => knds
   in
      if Symbol.eq (t, Type.world) orelse Symbol.eq (t, Type.rel) then ()
      else emit ["type "^Symbol.toValue t^typeBuf t^" "^representation]
   end

   (*[ val assert: Type.t * Class.rel -> unit ]*)
   fun assert (t, knd) = 
      case map Symbol.toValue (Class.argtyps knd) of 
         [] => emit ["val "^Symbol.toValue t^relBuf t^": db -> db"]
       | [ arg ] => 
            emit ["val "^Symbol.toValue t^relBuf t
                  ^": "^arg^" * db -> db"]
       | args =>
            emit ["val "^Symbol.toValue t^":"^relBuf t
                  ^" ("^String.concatWith " * " args^") * db -> db"]

   (*[ val queries: Symbol.symbol * (Pos.t * Atom.moded_t) -> unit ]*)
   fun queries (qry, (_, index)) =
   let
      val (ins, outs) = Indices.query_paths index
      val instr = 
         case map (Symbol.toValue o #2) (Path.Dict.toList ins) of 
            [] => ""
          | [ t ] => "-> "^t^" "
          | ts => "-> ("^String.concatWith " * " ts^") "
   in
      case map (Symbol.toValue o #2) (Path.Dict.toList outs) of 
         [] => emit ["val "^Symbol.toValue qry^":"^queryBuf qry
                     ^" db "^instr^"-> bool"]
       | [ t ] => emit ["val "^Symbol.toValue qry^":"^queryBuf qry
                        ^" ("^t^" * 'a -> 'a) -> 'a -> db "^instr^"-> 'a"]
       | ts => emit ["val "^Symbol.toValue qry^":"^queryBuf qry
                     ^" (("^String.concatWith " * " ts ^")"
                     ^" * 'a -> 'a) -> 'a -> db "^instr^"-> 'a"]
   end
in
 ( emit ["signature "^MODULE_NAME^" =","sig"]
 ; incr ()
 ; emit ["type db (* Type of L10 databases *)"]
 ; if Tab.member Tab.dbs (Symbol.fromValue "empty") then ()
   else emit ["val empty: db"]
 ; app (fn (s, _) => emit ["val "^Symbol.toValue s^": db"]) 
      (Tab.list Tab.dbs)
 ; emit [""] 
 ; app typedecl (Tab.list Tab.types)
 ; emit ["","structure Assert:","sig"]
 ; incr ()
 ; app assert (Tab.list Tab.rels)
 ; decr ()
 ; emit ["end","","structure Query:","sig"]
 ; incr ()
 ; app queries (Tab.list Tab.queries)
 ; decr ()
 ; emit ["end"]
 ; decr ()
 ; emit ["end"])
end

fun emitStructHead ModuleName MODULE_NAME = 
let 
   fun filter (t, Class.Extensible) = false
     | filter (t, Class.Builtin) = false
     | filter (t, Class.Type) =
         (case Tab.find Tab.representations t of
             SOME Type.External => false
           | _ => not (Symbol.eq (t, Type.world)
                       orelse Symbol.eq (t, Type.rel)))
in
 ( emit ["","","(* L10 Logic programming *)",""]
 ; emit ["structure "^ModuleName^":> "^MODULE_NAME]
 ; incr ()
 ; appFirst (fn () => ())
      (fn (decl, (t, knd)) => 
          emit [decl^" type "^Symbol.toValue t^" = "^Strings.typ t])
      ("where", "and")
      (List.filter filter (Tab.list Tab.types))
 ; decr ()
 ; emit ["=","struct"])
end

fun emitStruct tables = 
let
   fun dbs (db, facts) = 
   let
      fun loop prefix postfix [] = emit [prefix^"(L10_Tables.empty ())"^postfix]
        | loop prefix postfix ((_, (a, terms)) :: facts) =
           ( emit [prefix^"(L10_Tables.assert_"^Symbol.toValue a^" "
                   ^Strings.tuple (map Strings.build terms)]
           ; loop (prefix^" ") (postfix^")") facts)
   in
    ( emit ["","val "^Symbol.toValue db^" = ", "   let val table ="]
    ; loop "   " "" facts
    ; emit ["in {pristine=table, public=ref table} end"])
   end

   (* XXX rather than invalidating the whole world tree, we should traverse
    * it in the other direction (with forward links) - much more efficient *)
   (*[ val assert: Symbol.symbol * Class.rel -> unit ]*)
   fun assert (fst, (a, rel)) =
   let 
      val name = Symbol.toValue a
      val ts = mapi (fn x => x) (Class.argtyps rel)
      val args = if null ts then "()" else "args"
   in 
     ( emit fst
     ; case map (fn (x,_) => "x_"^Int.toString x) ts of 
          [] => emit ["fun "^name^" (db: db) ="]
        | args => emit ["fun "^name^" (args, db: db) ="]
     ; emit ["let"]
     ; emit ["   val pristine = L10_Tables.assert_"^name^" "^args]
     ; emit ["                     (L10_Tables.set_flag (#pristine db) false)"]
     ; emit ["in","   if L10_Tables.get_flag pristine"]
     ; emit ["   then {pristine=pristine, public=ref pristine}"]
     ; emit ["   else db","end"])
   end

   (*[ val queries: Symbol.symbol * (Pos.t * Atom.moded_t) -> unit ]*)
   fun queries (fst, (qry, (pos, index))) =
   let
      val qrys = Symbol.toValue qry
      val {label, inputs, outputs} = Indices.get_fold tables index
      val (ordered_ins, ordered_outs) = Indices.query_paths index

      val args = map (fn (path, t) => Path.toVar path)
          (Path.Dict.toList ordered_ins)

      (* This is a bit of a hack, entirely dependent on the fact that publicly
       * declared indices can't analyze the structure of terms *)
      (*[ val getwargs: int -> Term.pathsubst -> Class.rel_t 
             -> (Symbol.symbol * Term.shape list)]*)
      fun getwargs i subst (Class.Rel (_, (w, terms))) =
             (Symbol.toValue w, valOf (Term.substs (subst, terms)))
        | getwargs i subst (Class.Arrow (_, rel)) =
             getwargs (i+1) subst rel
        | getwargs i subst (Class.Pi (x, SOME t, rel)) =
             getwargs (i+1) (DictX.insert subst x (Term.Path([i], t))) rel
      val (w, wargs) = getwargs 0 DictX.empty (Tab.lookup Tab.rels (#1 index))
   in
    ( emit fst
    ; emit ["fun "^qrys^" f x (db: db)"
            ^Strings.optTuple args^" ="]
    ; emit ["let"]
    ; incr ()
    ; emit ["val public = L10_Search.saturate_"^w
            ^Strings.optTuple (map Strings.build wargs)^" (!(#public db))"]
    ; decr ()
    ; emit ["in"]
    ; emit [" ( #public db := public"]
    ; emit [" ; L10_Tables.fold_"^Int.toString label^" f x public "
            ^Strings.tuple (map (Path.toVar o #1) inputs)^")"]
    ; emit ["end"]
    ; if null outputs
      then emit ["val "^qrys^" = fn x => "^qrys^" (fn _ => true) false x"] 
      else ())
   end
in
 ( incr ()
 ; emit ["","","(* L10 public interface (interface.sml) *)",""]
 ; emit ["type db = {pristine: L10_Tables.tables,"]
 ; emit ["           public: L10_Tables.tables ref}"]
 ; app (fn (t, knd) => emit ["type "^Symbol.toValue t^" = "^Strings.typ t]) 
      (Tab.list Tab.types)
 ; emit ["","val empty = "]
 ; emit ["   let val table = L10_Tables.empty ()"]
 ; emit ["   in {pristine=table, public=ref table} end"]
 ; app dbs (Tab.list Tab.dbs)
 ; emit ["","structure Assert =","struct"]
 ; incr ()
 ; appFirst (fn () => ()) assert ([], [""]) (Tab.list Tab.rels)
 ; decr ()
 ; emit ["end","","structure Query =","struct"]
 ; incr ()
 ; appFirst (fn () => ()) queries ([], [""]) (Tab.list Tab.queries)
 ; decr ()
 ; emit ["end"]
 ; decr ()
 ; emit ["end"])
end

end
