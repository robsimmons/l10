structure Elton:> sig
   exception Die of OS.Process.status 
   val go: string * string list -> unit
end = 
struct

(* Exceptional behavior *)

exception Die of OS.Process.status

fun die p s = 
  (print ((if p = "" then "" else p ^ ": ") ^ s ^ "\n")
   ; raise Die OS.Process.failure)


(* Options *)

datatype options = 
   Verbose
 | Help
 | Prefix of string
 | Sources of string
 | Directory of string

val options: options GetOpt.opt_descr list = 
  [ {short = "vV", 
     long = [ "verbose" ],
     desc = GetOpt.NoArg (fn () => Verbose),
     help = "Print out signature and compiler messages." },
    {short = "p",
     long = [ "prefix" ],
     desc = GetOpt.ReqArg (Prefix, "l10"),
     help = "Prefix for signatures, structures, and files." },
    {short = "d",
     long = [ "directory" ],
     desc = GetOpt.ReqArg (Directory, "dir"),
     help = "Directory for file output"},
    {short = "h",
     long = [ "help" ],
     desc = GetOpt.NoArg (fn () => Help),
     help = "Show this message and exit"} ]


(* Run top level *)

fun go (name, args) = 
   let 
      val () = print ("Elton database generator 0.0.1\n")

      val usageinfo  = 
         GetOpt.usageInfo 
            {header = "Usage: " ^ name ^ " [options] file.l10 ...\nOptions:",
             options = options} ^ "\n"

      fun processOpt (opt, (prefix, sources, dir)) =
         case opt of 
            Verbose => (* Cause effect *) (prefix, sources, dir)
          | Help => (print usageinfo; die "" "Exiting...")
          | Prefix prefix' => (prefix', sources, dir)
          | Sources sources' => (prefix, sources', dir)
          | Directory dir' => (prefix, sources, dir')

      fun errFn s = print ("Error: " ^ s ^ "\n" ^ usageinfo)

      val (opts, files) = 
         GetOpt.getOpt 
            {argOrder = GetOpt.Permute, options = options, errFn = errFn}
            args

      val (prefix, sources, dir) = 
         foldr processOpt ("l10", "l10.sources", OS.FileSys.getDir ()) opts


      (* File utilities *)

      val dirUser = OS.FileSys.getDir ()
      fun absoluteUser s = OS.Path.mkAbsolute {path = s, relativeTo = dirUser}
      val dirProg = absoluteUser (OS.Path.dir name)
      val dirSource = 
         OS.Path.mkAbsolute {path = "../sml/util", relativeTo = dirProg}
      val dirTarget = absoluteUser dir 
   in
      if null files 
      then die "Nothing to do" ("type \"" ^ name ^ " --help\" for options") 
      else ()
      ; EltonMain.load {sourceFiles = files} 
        handle Fail s => die "Error loading code" s
      ; EltonMain.writeSML {targetDir = "/tmp", prefix = prefix}
        handle Fail s => die "Error generating code" s
      ; EltonMain.writeHelpers {sourceDir = dirSource, targetDir = dirTarget}
        handle Fail s => die "Error copying helper functions" s
      ; EltonMain.writeCM {targetDir = dirTarget}
        handle Fail s => die "Error generating build files" s   
   end

end
