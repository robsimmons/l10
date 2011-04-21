structure X = 

   val (filein, fileout) = 
      case CommandLine.arguments () of 
         [ name ] => 
         let 
            val here = fn () => OS.FileSys.openDir "."
            val din  = chk (here ()) "." ["examples"]
            val dout = chk (here ()) "." ["src", "l10", "examples"]
         in
            (join (din, name ^ ".l10"), join (dout, name ^ ".x10"))
         end
       | args => 
         (print ("Usage: " ^ CommandLine.name () ^ " <name>\n");
          print ("l10front will read examples/<name>.l10,\n");
          print ("and then it will write src/l10/examples/<name>.x10\n\n");
          raise Nope ("expected 1 argument, found " 
                      ^ Int.toString (length args)))


   val _ = OS.Process.exit (Go.go (filein, fileout))

end
