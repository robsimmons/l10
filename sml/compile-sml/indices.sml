
structure Indices:> 
sig
   type tables 

   (*[ val caonicalize: Atom.moded_t list -> tables ]*)
   val canonicalize: Atom.t list -> tables

(* 
   (*[ val lookup: Atom.prop_t ->  ]*)
   val lookup: tables -> Atom.moded_t ->  
                  -> {prop: Atom.t, input: SetX.set, output: SetX.set}
                  -> {id: int,
                      inputs: Symbol.symbol list,
                      outputs: Symbol.symbol option list}
*)
 
   val emit: tables -> unit
end = 
struct

open Util

type tables = (int * Atom.t) list

(* XXX This creates way too many tables - reuse tables! *)
fun canonicalize x = mapi (fn x => x) x 

fun emit' tables = 
let in
 ( emit ["", "", "(* L10 databases with required indexing (indices.sml) *)"]
 ; List.app
      (fn (n, index) =>
          emit ["(* "^Int.toString n^ " - "
                ^Atom.toString index^" *)"])
   tables)
end

val emit = emit'

end

