
structure Interface:> 
sig
   (* emitSig MODULE_NAME *)
   val emitSig: string -> unit
 
   (* emitStructHead ModuleName MODULE_NAME *)
   val emitStructHead: string -> string -> unit

   (* emitStruct () *)
   val emitStruct: unit -> unit
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
  
   (*[ val typedecl: Class.knd -> unit ]*)
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
      emit ["type "^Symbol.toValue t^typeBuf t^" "^representation]
   end

   (*[ val assert: Symbol.symbol * Class.rel -> unit ]*)
   fun assert (t, knd) = 
      case map Symbol.toValue (Class.argtyps knd) of 
         [] => emit ["val "^Symbol.toValue t^relBuf t^": tables -> tables"]
       | [ arg ] => 
            emit ["val "^Symbol.toValue t^relBuf t
                  ^": "^arg^" * tables -> tables"]
       | args =>
            emit ["val "^Symbol.toValue t^":"^relBuf t
                  ^" ("^String.concatWith " * " args^") * tables -> tables"]

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
                     ^" tables "^instr^"-> bool"]
       | [ t ] => emit ["val "^Symbol.toValue qry^":"^queryBuf qry
                        ^" ("^t^" * 'a -> 'a) -> 'a -> tables "^instr^"-> 'a"]
       | ts => emit ["val "^Symbol.toValue qry^":"^queryBuf qry
                     ^" (("^String.concatWith " * " ts ^")"
                     ^" * 'a -> 'a) -> 'a -> tables "^instr^"-> 'a"]
   end
in
 ( emit ["signature "^MODULE_NAME^" =","sig"]
 ; incr ()
 ; emit ["type tables (* Type of L10 databases *)",""]
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
           | _ => true) 
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

fun emitStruct () = 
let
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
          [] => emit ["fun "^name^" (db: L10_Tables.tables) ="]
        | args => emit ["fun "^name^" (args, db: L10_Tables.tables) ="]
     ; emit ["let","   val () = #flag db := false"]
     ; emit ["   val db = L10_Tables.assert_"^name^" "^args^" db"]
     ; emit ["in","   if !(#flag db)"]
     ; emit ["   then (#worlds db := World.Dict.empty; db)"]
     ; emit ["   else db","end"])
   end

   (*[ val queries: Symbol.symbol * (Pos.t * Atom.moded_t) -> unit ]*)
   fun queries (qry, (_, index)) =
      emit ["fun "^Symbol.toValue qry^" _ = raise Match"]
in
 ( incr ()
 ; emit ["","","(* L10 public interface (interface.sml *)",""]
 ; emit ["type tables = L10_Tables.tables"]
 ; app (fn (t, knd) => emit ["type "^Symbol.toValue t^" = "^Strings.typ t]) 
      (Tab.list Tab.types)
 ; emit ["","structure Assert =","struct"]
 ; incr ()
 ; appFirst (fn () => ()) assert ([], [""]) (Tab.list Tab.rels)
 ; decr ()
 ; emit ["end","","structure Query =","struct"]
 ; incr ()
 ; app queries (Tab.list Tab.queries)
 ; decr ()
 ; emit ["end"]
 ; decr ()
 ; emit ["end"])
end

end
