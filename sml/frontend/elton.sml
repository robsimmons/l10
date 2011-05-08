structure Elton:> sig

   val load: string list -> unit
   val write: string -> string -> string -> string -> unit

end = 
struct

structure Util = SMLCompileUtil
val emit = Util.emit

fun load files = 
   let in 
      CompilerState.reset ()
      ; Read.files files
      ; CompilerState.load ()
   end

fun cm () = 
   let in 
      emit ("Library")
      ; Util.incr ()
      ; emit ("structure " ^ Util.getPrefix true "" ^ "Terms")
      ; emit ("structure " ^ Util.getPrefix true "" ^ "Tables")
      ; emit ("structure " ^ Util.getPrefix true "" ^ "Search")
      ; emit ("structure MapI")
      ; emit ("structure MapII")
      ; emit ("structure MapP")
      ; emit ("structure MapS")
      ; emit ("structure MapX")
      ; Util.decr (); emit "is"; Util.incr ()
      ; emit ("$/basis.cm")
      ; emit ("$/smlnj-lib.cm")
      ; emit ("disctree.sml")
      ; emit ("symbol.sml")
      ; emit ("sets-maps.sml")
      ; emit (Util.getPrefix false "." ^ "terms-sig.sml")
      ; emit (Util.getPrefix false "." ^ "terms.sml")
      ; emit (Util.getPrefix false "." ^ "tables.sml")
      ; emit (Util.getPrefix false "." ^ "search-sig.sml")
      ; emit (Util.getPrefix false "." ^ "search.sml")
      ; Util.decr ()
      ; print "Okay that's done\n"
   end

fun write output_dir elton_dir prefix sources = 
   let 
      fun file s = OS.Path.joinDirFile 
                       {dir = output_dir, file = Util.getPrefix false "." ^ s}
   in
      Util.write (file "terms-sig.sml") SMLCompileTerms.termsSig
      ; Util.write (file "terms.sml") SMLCompileTerms.terms
      ; Util.write (file "tables.sml") SMLCompileTables.tables
      ; Util.write (file "search-sig.sml") SMLCompileSearch.searchSig
      ; Util.write (file "search.sml") SMLCompileSearch.search
      ; print ("Writing " ^ sources ^ ".cm\n")
      ; Util.write (sources ^ ".cm") cm
   end      
end
