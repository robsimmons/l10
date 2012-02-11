
structure Interface:> sig
 
   (* emitSig MODULE_NAME *)
   val emitSig: string -> unit

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

   (*[ val assert: Class.rel -> unit ]*)
   fun assert (t, knd) = 
      case map Symbol.toValue (Class.argtyps knd) of 
         [] => emit ["val "^Symbol.toValue t^relBuf t^": tables -> tables"]
       | [ arg ] => 
            emit ["val "^Symbol.toValue t^relBuf t
                  ^": "^arg^" * tables -> tables"]
       | args =>
            emit ["val "^Symbol.toValue t^":"^relBuf t
                  ^" ("^String.concatWith " * " args^") * tables -> tables"]

   (*[ val queries: Pos.t * Atom.moded_t -> unit ]*)
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

end
