structure EltonMLton = 
struct

val name = CommandLine.name ()
val args = CommandLine.arguments ()

fun die p s = 
  (print ((if p = "" then "" else p ^ ": ") ^ s ^ "\n")
   ; OS.Process.exit OS.Process.failure)

val () = print ("Elton database generator 0.0.1\n")



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
    {short = "s",
     long = [ "sources" ],
     desc = GetOpt.ReqArg (Sources, "l10.sources"),
     help = "Base name for the generated source files"},
    {short = "d",
     long = [ "directory" ],
     desc = GetOpt.ReqArg (Directory, "dir"),
     help = "Directory for file output"},
    {short = "h",
     long = [ "help" ],
     desc = GetOpt.NoArg (fn () => Help),
     help = "Show this message and exit"} ]

val usageinfo  = 
   GetOpt.usageInfo 
     {header = "Usage: " ^ name ^ " [options] file.l10 ...\nOptions:",
      options = options} ^ "\n"

val (opts, files) = 
   GetOpt.getOpt 
      {argOrder = GetOpt.Permute, 
       options = options, 
       errFn = (fn s => print ("Error: " ^ s ^ "\n" ^ usageinfo))} args

fun processOpt (opt, (prefix, sources, dir)) =
   case opt of 
      Verbose => (* Cause effect *) (prefix, sources, dir)
    | Help => (print usageinfo; die "" "Exiting...")
    | Prefix prefix' => (prefix', sources, dir)
    | Sources sources' => (prefix, sources', dir)
    | Directory dir' => (prefix, sources, dir')

val (prefix, sources, dir) = 
   foldr processOpt ("l10", "l10.sources", OS.FileSys.getDir ()) opts

val () = 
   if null files 
   then die "Nothing to do" ("type \"" ^ name ^ " --help\" for options") 
   else ()


(* Run program *)

val dirUser = OS.FileSys.getDir ()
val dirProg = OS.Path.mkAbsolute { path = name, relativeTo = dirUser }

fun absoluteUser s = OS.Path.mkAbsolute { path = s, relativeTo = dirUser }
fun absoluteProg s = OS.Path.mkAbsolute { path = s, relativeTo = dirProg }
                
val () = Elton.load files
   handle Fail s => die "Error loading code" s

val () = SMLCompileUtil.setPrefix sources

val () = Elton.write (absoluteUser dir) files
   handle Fail s => die "Error generating code" s   

end
