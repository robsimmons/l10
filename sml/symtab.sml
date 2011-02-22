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

functor Multitab (type entrytp) :> sig
   type entry = entrytp
   val reset : unit -> unit
   val bind : Symbol.symbol * entry -> unit
   val lookup : Symbol.symbol -> entry list
   val list : unit -> (Symbol.symbol * entry) list
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
   List.concat 
      (map 
          (fn (id, xs) => map (fn x => (id, x)) xs)
          (MapX.listItemsi (!symtab)))
end

