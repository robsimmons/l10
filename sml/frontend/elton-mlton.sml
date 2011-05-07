structure EltonMLton = 
struct

val name = CommandLine.name ()
val args = CommandLine.arguments ()

fun errfn p s = 
  (print ("Error" ^ (if p = "" then "" else p ^ " ") ^ ": " ^ s ^ "\n")
   ; OS.Process.exit OS.Process.failure)


(* Options *)

datatype options = 
   Verbose
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
     desc = GetOpt.ReqArg (Prefix, "prefix"),
     help = "Prefix for PREFIX_TERMS, PrefixSearch, prefix.terms.sml, etc." },
    {short = "s",
     long = [ "sources-file" ],
     desc = GetOpt.ReqArg (Sources, "sources"),
     help = "Name for the generated sources.cm and sources.mlb files"},
    {short = "d",
     long = [ "directory" ],
     desc = GetOpt.ReqArg (Directory, "output-directory"),
     help = "Directory for file output (will be created if non-existant)"} ]

val (opts, files) = 
   GetOpt.getOpt 
      {argOrder = GetOpt.Permute, 
       options = options, 
       errFn = errfn "reading arguments"} args

fun processOpt (opt, (prefix, sources, dir)) =
   case opt of 
      Verbose => (* Cause effect *) (prefix, sources, dir)
    | Prefix prefix' => (prefix', sources, dir)
    | Sources sources' => (prefix, sources', dir)
    | Directory dir' => (prefix, sources, dir')

val (prefix, sources, dir) = 
   foldr processOpt ("l10", "sources", OS.FileSys.getDir ()) opts



(* Load program *)

val () = 
   let in 
      CompilerState.reset ()
      ; SMLCompileUtil.setPrefix prefix
      ; Read.files files
      ; CompilerState.load ()
   end handle Fail s => errfn "" s 



(* Output program *)

val dirUser = OS.FileSys.getDir ()
val dirProg = OS.Path.mkAbsolute { path = name, relativeTo = dirUser }

fun absoluteUser s = OS.Path.mkAbsolute { path = s, relativeTo = dirUser }
fun absoluteProg s = OS.Path.mkAbsolute { path = s, relativeTo = dirProg }
fun file s = 
   OS.Path.joinDirFile 
      {dir = absoluteUser dir, file = SMLCompileUtil.getPrefix false "." ^ s}
                
val () = 
   let in
      SMLCompileUtil.write (file "terms-sig.sml") SMLCompileTerms.termsSig
      ; SMLCompileUtil.write (file "terms.sml") SMLCompileTerms.terms
      ; SMLCompileUtil.write (file "tables.sml") SMLCompileTables.tables
      ; SMLCompileUtil.write (file "search-sig.sml") SMLCompileSearch.searchSig
      ; SMLCompileUtil.write (file "search.sml") SMLCompileSearch.search
   end handle Fail s => errfn "generating code" s   

end
