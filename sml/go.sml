structure Go = struct

exception Nope of string 

val () = 
   let 
      fun join (dir, file) = OS.Path.joinDirFile {dir = dir, file = file}

      fun chk ds basedir [] = basedir
        | chk ds basedir (subdir :: subdirs) = 
          (case OS.FileSys.readDir ds of
              NONE => 
              let val newbasedir = join (basedir, subdir) in
                 OS.FileSys.mkDir newbasedir
                 ; chk (OS.FileSys.openDir newbasedir) newbasedir subdirs
              end
            | SOME s => 
              if s <> subdir 
              then chk ds basedir (subdir :: subdirs)
              else let val newbasedir = join (basedir, subdir) in
              if OS.FileSys.isDir newbasedir 
              then chk (OS.FileSys.openDir newbasedir) newbasedir subdirs
              else raise Nope (newbasedir ^ " exists and is not a directory")
              end)
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

      val () = print ("Reading " ^ filein ^ "\n")
      val program = Parse.parse filein
         handle IO.Io {name, function, cause} =>
         raise Nope ("unable to open " ^ name ^ " (error " ^ function ^ ")")
   in
      print ("Parsed " ^ Int.toString (length program) ^ " lines(s)\n")
      ; print ("Send output to " ^ fileout ^ "\n")
      ; print ("Success!\n")
      ; OS.Process.exit OS.Process.success
   end handle Nope s => 
      (print ("Error: " ^ s ^ ".\n"); OS.Process.exit OS.Process.success)

end
