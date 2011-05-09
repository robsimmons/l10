structure EltonMain:> sig
   (* Reset, load, and compile SML files *)
   val load: {sourceFiles: string list} -> unit

   (* Output the generated .sml files *)
   val writeSML: {targetDir: string, prefix: string} -> unit

   (* Load helper files from the directory where they live to the target dir *)
   val writeHelpers: {sourceDir: string, targetDir: string} -> unit

   (* Output the compiler manager files: must run after writeSML. *)
   val writeCM: {targetDir: string} -> unit
end = 
struct

open OS.Path

structure Util = SMLCompileUtil

val emit = Util.emit
   

(* Reset, load, and compile SML files *)
fun load {sourceFiles} = 
   let in 
      CompilerState.reset ()
      ; Read.files sourceFiles
      ; CompilerState.load ()
   end


(* Output the generated .sml files *)
fun writeSML {targetDir, prefix} =
   let 
      fun file s = 
         joinDirFile {dir = targetDir, file = Util.getPrefix false "." ^ s}
   in
      Util.setPrefix prefix
      ; print "one\n"
      ; Util.write (file "terms-sig.sml") SMLCompileTerms.termsSig
      ; Util.write (file "terms.sml") SMLCompileTerms.terms
      ; Util.write (file "tables.sml") SMLCompileTables.tables
      ; Util.write (file "search-sig.sml") SMLCompileSearch.searchSig
      ; Util.write (file "search.sml") SMLCompileSearch.search
      ; print "two\n"
   end      


(* Load helper files from the directory where they live to the target dir *)
fun writeHelpers {sourceDir, targetDir} =
   let 
      fun copy file = 
         let 
            val source = mkAbsolute {path = file, relativeTo = sourceDir}
            val target = mkAbsolute {path = file, relativeTo = targetDir}
            val file1 = TextIO.openIn source
            val s     = TextIO.inputAll file1 
            val ()    = TextIO.closeIn file1 
            val file2 = TextIO.openOut target
         in  
            TextIO.output(file2, s) 
            ; TextIO.closeOut file2 
         end 
   in 
      print "three\n"
      ; copy "disctree.sml"
    ; print "four\n"
      ; copy "symbol.sml"
      ; copy "sets-maps.sml"
   end


(* Output the compiler manager files: must run after writeSML. *)
fun cm () = 
   let in 
      emit ("Library")
      ; Util.incr ()
      ; emit ("structure Symbol")
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

(* Output the compiler manager files *)
fun writeCM {targetDir} = 
   let val file = Util.getPrefix false "." ^ "sources" ^ ".cm"
   in Util.write (joinDirFile {dir = targetDir, file = file}) cm end

end
