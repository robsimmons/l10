structure Regression:> sig
   val checkFile: string -> unit
   val checkDirs: string list -> unit
   val reportAndReset: unit -> unit
end = 
struct

datatype outcome = 
   SyntaxError
 | TypeError
 | ModeError
 | NotStratified
 | InternalError of string
 | UnexpectedError of string
 | Success
 | BadSML
 | TestFailed

fun str SyntaxError = "syntax error"
  | str TypeError = "type error" 
  | str ModeError = "mode/worlds checking error"
  | str NotStratified = "stratification error"
  | str (InternalError s) = ("internal error: `"^s^"'")
  | str (UnexpectedError exnname) = ("unexpected error: `"^exnname^"'")
  | str Success = "success"
  | str BadSML = "generated invalid SML code"
  | str TestFailed = "compiled test failed"

val success: int ref = ref 0
val ignored: int ref = ref 0
val failure: (string * string * outcome * outcome) list ref = ref [] 

fun reportAndReset () = 
 ( print ("\nFinal results:\n")
 ; print ("Successful tests:  "^Int.toString (!success)^"\n")
 ; print ("Files ignored:     "^Int.toString (!ignored)^"\n")
 ; print ("Failures:          "^Int.toString (length (!failure))^"\n")
 ; if null (!failure) then () else print "\n=== Failed tests: ===\n"
 ; app (fn (filename, string, expected, got) =>
         ( print ("In file: "^filename^"\n")
         ; print ("Test: "
                  ^String.concatWith " " (String.tokens Char.isSpace string)
                  ^"\n")
         ; print ("Got: "^str got^"\n\n"))) (!failure)
 ; success := 0
 ; ignored := 0
 ; failure := [])    

fun check run filename args = 
let
   val () = Tab.reset ()
   val () = Elton.go_no_handle ("elton", filename :: args)
   val success = 
      OS.Process.isSuccess
         (OS.Process.system ("cp "^filename^".sml regression/test.l10.sml"))
      andalso
      OS.Process.isSuccess 
         (OS.Process.system
             (if run then "mlton regression/test.mlb"
              else "mlton -stop tc regression/test.mlb"))
in
   if success andalso run
   then (if OS.Process.isSuccess (OS.Process.system "regression/test")
         then Success
         else TestFailed)
   else if success then Success else BadSML
end handle Lexer.LexError _ => SyntaxError
        | Parser.SyntaxError _ => SyntaxError
        | Parser.TypeError _ => TypeError
        | Types.TypeError _ => TypeError
        | Types.Reserved _ => SyntaxError
        | Worlds.WorldsError _ => ModeError
        | Modes.ModeError _ => ModeError
        | Modes.WorldsError _ => ModeError
        | Modes.NegationError _ => NotStratified
        | Fail s => InternalError s
        | exn => UnexpectedError (exnName exn)

exception Ignore
fun checkFile filename =
   let 
      val file = TextIO.openIn filename
      val fstline = TextIO.inputLine file before TextIO.closeIn file
      val spec = 
         case Option.map (fn x => String.isPrefix "//test\n" x 
                                  orelse String.isPrefix "//test " x) fstline of
            SOME true => String.extract (valOf fstline, 7, NONE)
          | _ => raise Ignore
      val (args, expected) = 
         case map (String.tokens Char.isSpace)
                 (String.fields (fn c => #"~" = c) spec) of
            [ args ] => (args, Success)
          | [ args, [ "SYNTAX-ERROR" ] ] => (args, SyntaxError)
          | [ args, [ "TYPE-ERROR" ] ] => (args, TypeError)
          | [ args, [ "MODE-ERROR" ] ] => (args, ModeError)
          | [ args, [ "NOT-STRATIFIED" ] ] => (args, NotStratified)
          | _ => ([], InternalError ("could not parse `"^spec^"'"))
      val smlfile = 
         OS.Path.joinBaseExt {base = #base (OS.Path.splitBaseExt filename),
                              ext = SOME "sml"}
      val testfile = 
         OS.Path.joinBaseExt {base = #base (OS.Path.splitBaseExt filename),
                              ext = SOME "test.sml"}
      val () = ignore (OS.Process.system ("rm -f regression/test"))
      val () = ignore (OS.Process.system ("rm -f regression/test2.sml"))
      val () = ignore (OS.Process.system ("rm -f regression/test.l10.sml"))
      val _ = 
         if OS.FileSys.access (smlfile, [ OS.FileSys.A_READ ])
         then OS.Process.system ("cp "^smlfile^" regression/test.sml")
         else OS.Process.system ("cp /dev/null regression/test.sml")
      val run =
         if OS.FileSys.access (testfile, [ OS.FileSys.A_READ ])
         then (OS.Process.system ("cp "^testfile^" regression/test2.sml"); true)
         else (OS.Process.system ("cp /dev/null regression/test2.sml"); false)
      val got = check run filename args
   in
      if expected = got
      then success := !success + 1
      else failure := (filename, spec, expected, got) :: !failure
   end handle Ignore => ( print ("\n\n[ == Ignoring "^filename^" == ]\n\n")
                        ; ignored := !ignored + 1)


fun checkDirs [] = ()
  | checkDirs (dirname :: dirnames) = 
    let 
       val _ = OS.Process.system ("rm "^dirname^"/*.l10.sml")
       fun readDir dir =
          case OS.FileSys.readDir dir of
             NONE => (OS.FileSys.closeDir dir; [])
           | SOME filename => 
               (case #ext (OS.Path.splitBaseExt filename) of 
                   SOME "l10" => 
                      OS.Path.joinDirFile {dir=dirname, file=filename}
                      :: readDir dir
                 | _ => readDir dir)
    in
       app checkFile (readDir (OS.FileSys.openDir dirname))
    end
end
