(* Symbol tables bind individual symbols to individual entries *)
(* Robert J. Simmons, based on the C0 compiler by Frank Pfenning *)

functor Symtab (type entrytp) :> sig
   type entry = entrytp
   val reset : unit -> unit
   val bind : Symbol.symbol * entry -> unit
   val lookup : Symbol.symbol -> entry option
   val list : unit -> Symbol.symbol list
end = 
struct

type entry = entrytp

val symtab: entry MapX.map ref = ref MapX.empty

fun reset () = symtab := MapX.empty

fun bind (id, x) = symtab := MapX.insert (!symtab, id, x)

fun lookup (id) = MapX.find (!symtab, id)

fun list () = MapX.listKeys (!symtab)

end

