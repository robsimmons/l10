(* Symbol tables bind individual symbols to individual entries *)
(* Robert J. Simmons, based on the C0 compiler by Frank Pfenning *)

functor Symtab (type entrytp val name: string) :> sig
   type entry = entrytp
   val reset : unit -> unit
   val bind : Symbol.symbol * entry -> unit
   val find : Symbol.symbol -> entry option
   val lookup : Symbol.symbol -> entry 
   val list : unit -> Symbol.symbol list
end = 
struct

type entry = entrytp

val symtab: entry MapX.map ref = ref MapX.empty

fun reset () = symtab := MapX.empty

fun bind (id, x) = symtab := MapX.insert (!symtab, id, x)

fun find id = MapX.find (!symtab, id)

fun lookup id = 
   case MapX.find (!symtab, id) of
      NONE => raise Fail ("Symbol " ^ Symbol.name id ^ " not in " ^ name)
    | SOME x => x

fun list () = MapX.listKeys (!symtab)

end

