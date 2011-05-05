(* Multi-symbol tables bind individual symbols to a sequence of entries *)
(* Robert J. Simmons *)

functor Multitab (type entrytp) :> sig
   type entry = entrytp
   val reset: unit -> unit
   val bind: Symbol.symbol * entry -> unit
   val list: unit -> Symbol.symbol list
   val lookup: Symbol.symbol -> entry list
end = 
struct

type entry = entrytp

val symtab: entry list MapX.map ref = ref MapX.empty

fun reset () = symtab := MapX.empty

fun bind (id, x) = 
   case MapX.find (!symtab, id) of
      NONE => symtab := MapX.insert (!symtab, id, [ x ])
    | SOME xs => symtab := MapX.insert (!symtab, id, x :: xs)

fun lookup (id) = 
   case MapX.find (!symtab, id) of
      NONE => []
    | SOME xs => xs

fun list () = 
   map (fn (id, xs) => id) (MapX.listItemsi (!symtab))

end

