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
 | InternalError of string
 | UnexpectedError of string
 | Success

fun str SyntaxError = "syntax error"
  | str TypeError = "type error" 
  | str ModeError = "mode/worlds checking error"
  | str (InternalError s) = ("internal error: `"^s^"'")
  | str (UnexpectedError exnname) = ("unexpected error: `"^exnname^"'")
  | str Success = "success"

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

fun check args = 
   (Tab.reset (); Elton.go_no_handle ("elton", args); Success)
   handle Lexer.LexError _ => SyntaxError
        | Parser.SyntaxError _ => SyntaxError
        | Types.TypeError _ => TypeError
        | Worlds.WorldsError _ => ModeError
        | Modes.ModeError _ => ModeError
        | Fail s => InternalError s
        | exn => UnexpectedError (exnName exn)

exception Ignore
fun checkFile filename =
   let 
      val file = TextIO.openIn filename
      val fstline = TextIO.inputLine file before TextIO.closeIn file
      val spec = 
         case Option.map (String.isPrefix "//test ") fstline of
            SOME true => String.extract (valOf fstline, 7, NONE)
          | _ => raise Ignore
      val (args, expected) = 
         case map (String.tokens Char.isSpace)
                 (String.tokens (fn c => #"~" = c) spec) of
            [ args ] => (args, Success)
          | [ args, [ "SYNTAX-ERROR" ] ] => (args, SyntaxError)
          | [ args, [ "TYPE-ERROR" ] ] => (args, TypeError)
          | [ args, [ "MODE-ERROR" ] ] => (args, ModeError)
          | _ => ([], InternalError ("could not parse `"^spec^"'"))
      val got = check (filename :: args)
   in
      if expected = got
      then success := !success + 1
      else failure := (filename, spec, expected, got) :: !failure
   end handle Ignore => ignored := !ignored + 1


fun checkDirs [] = ()
  | checkDirs (dirname :: dirnames) = 
    let 
       val dir = OS.FileSys.openDir dirname
       fun loop () =
          case OS.FileSys.readDir dir of
             NONE => OS.FileSys.closeDir dir
           | SOME filename =>
              ( case #ext (OS.Path.splitBaseExt filename) of 
                   SOME "l10" => 
                      checkFile 
                         (OS.Path.joinDirFile {dir=dirname, file=filename})
                 | _ => ()
              ; loop ())
    in 
       loop ()
    end

end
