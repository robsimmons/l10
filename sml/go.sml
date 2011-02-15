structure Go = struct

exception Nope of string 

val () = 
   let 
      fun join (dir, file) = OS.Path.joinDirFile {dir = dir, file = file}

      fun checkfor ds basedir [] = basedir
        | checkfor ds basedir (subdir :: subdirs) = 
          (case OS.FileSys.readDir ds of
              NONE => 
              let val newbasedir = join (basedir, subdir) in
                 OS.FileSys.mkDir newbasedir
                 ; checkfor (OS.FileSys.openDir newbasedir) newbasedir subdirs
              end
            | SOME s => 
              if s <> subdir 
              then checkfor ds basedir (subdir :: subdirs)
              else let val newbasedir = join (basedir, subdir) in
              if OS.FileSys.isDir newbasedir 
              then checkfor (OS.FileSys.openDir newbasedir) newbasedir subdirs
              else raise Nope (newbasedir ^ " exists and is not a directory")
              end)
(*
      val file = 
          case CommandLine.arguments () of 
             [ name ] => 
*)

   in
      (print ("Success!\n"); OS.Process.exit OS.Process.success)
   end handle Nope s => 
      (print ("Error: " ^ s ^ ".\n"); OS.Process.exit OS.Process.success)

end
