
structure Indices:> 
sig
   type indexset
   type tables 

   (*[ ]*)
   val canonicalize: indexset -> tables

   (*[ val lookup: Atom.prop_t ->  ]*)
   val lookup: tables 
                  -> {prop: Atom.t, input: SetX.set, output: SetX.set}
                  -> {id: int,
                      inputs: Symbol.symbol list,
                      outputs: Symbol.symbol option list}
end = 
struct


end

