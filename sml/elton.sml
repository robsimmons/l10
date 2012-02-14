(* SML output *)

structure Elton:> sig
   val go_no_handle: string * string list -> unit
   val go: string * string list -> OS.Process.status
end = 
struct

exception Failure
exception Success

(* Is this a valid SML identifier? *)
fun goodname s = 
   case String.explode s of
      [] => false
    | c :: cs => 
         Char.isAlpha c 
         andalso List.all (fn c => c = #"_" orelse Char.isAlphaNum c) cs
fun okName typ s =
   if goodname s then () 
   else ( print ("Error: Identifier `"^s^"' is a bad "^typ^"\n.")
        ; raise Failure) 

(* If there is not already a signature, propose one *)
fun toSig s (SOME M_NAME) = SOME M_NAME
  | toSig s NONE =
    let 
       fun conv cs =
          case cs of 
             [] => []
           | [ c ] => [ Char.toUpper c ]
           | c1 :: c2 :: cs =>
                if c1 <> #"_" andalso Char.isUpper c2
                then Char.toUpper c1 :: #"_" :: c2 :: conv cs
                else Char.toUpper c1 :: conv (c2 :: cs)
    in SOME (String.implode (conv (String.explode s))) end

(* Handle a new file that suggests module and signature names if well-formed *)
fun newfile state input base =
let 
   val {dir, file} = OS.Path.splitDirFile base 
   val exfile = String.explode file
   val File = String.implode (Char.toUpper (hd exfile) :: tl exfile)
   val goodFile = goodname File
in case state of
      (output, SOME input', _, _) =>
       ( print ("Error: multiple files `"^input'^"' and `"^input^"' given\n.")
       ; raise Failure)
    | (output, NONE, NONE, M_NAME) =>
         if not goodFile then (output, SOME input, NONE, M_NAME)
         else (output, SOME input, SOME File, toSig File M_NAME)
    | (output, NONE, SOME MName, M_NAME) =>
         if not goodFile then (output, NONE, SOME MName, M_NAME)
         else (output, SOME input, SOME MName, toSig File M_NAME)  
end    

fun print_usage () = 
print
"Elton database generator v0.1.0\n\
\Usage: elton filename.l10 [-o output.sml] [-s ModuleName] [-S ModuleName]\n\
\ Options:\n\
\  -h            --help              Show this message\n\
\  -o output.sml                     Output file (default filename.l10.sml)\n\
\  -s StructName --struct StructName Struct name (default Filename)\n\
\  -S SIG_NAME   --sig SIG_NAME      Signature name (default FILENAME)\n\n"

(* Force some filename, struct name, and signature name to exist *)
fun finalize (NONE, SOME filename, SOME MName, SOME M_NAME) = 
       (OS.Path.joinBaseExt {base=filename, ext=SOME "sml"},
        filename, MName, M_NAME)
  | finalize (SOME output, SOME filename, SOME MName, SOME M_NAME) = 
       (output, filename, MName, M_NAME)
  | finalize (_, NONE, _, _) = 
     ( print "Error: No filename given.\n\n"
     ; print_usage ()
     ; raise Failure)
  | finalize (_, _, NONE, _) = 
     ( print "Error: No module name given, use `-s Name'.\n\n"
     ; raise Failure) 
  | finalize (_, _, _, NONE) = 
     ( print "Error: No module name given, use `-S NAME'.\n\n"
     ; raise Failure) 

fun process_args (state as (output, filename, MName, M_NAME)) args = 
   case args of 
      [] => finalize state
    | "-h" :: _ => (print_usage (); raise Success)
    | "--help" :: _ => (print_usage (); raise Success)
    | "-o" :: s :: args =>
        (case OS.Path.splitBaseExt s of 
            {ext=SOME "sml",...} =>
               process_args (SOME s, filename, MName, M_NAME) args
          | {ext=SOME ext,...} => 
             ( print ("Error: Output must be a .sml file, not a ."
                      ^ext^" file.\n")
             ; raise Failure)
          | {ext=NONE,...} => 
             ( print ("Error: No extension on output file `"^s^"'.\n")
             ; raise Failure))
    | "-s" :: s :: args => 
       ( okName "structure" s
       ; process_args (output, filename, SOME s, toSig s M_NAME) args)
    | "--struct" :: s :: args =>
       ( okName "structure" s
       ; process_args (output, filename, SOME s, toSig s M_NAME) args)
    | "-S" :: s :: args =>
       ( okName "signature" s
       ; process_args (output, filename, MName, SOME s) args) 
    | "--sig" :: s :: args =>
       ( okName "signature" s
       ; process_args (output, filename, MName, SOME s) args) 
    | input :: args => 
        (case OS.Path.splitBaseExt input of 
            {base, ext=SOME "l10"} => 
               process_args (newfile state input base) args
          | {base, ext=SOME ext} =>
             ( print ("Error: Expected a .l10 file, not a ."^ext^" file.\n")
             ; raise Failure)
          | {base, ext=NONE} =>
             ( print ("Error: No extension on input file `"^input^"'.\n")
             ; raise Failure))

fun go_no_handle (name, args) = 
let
   val (output, input, MName, M_NAME) = 
      process_args (NONE, NONE, NONE, NONE) args
   val () = Read.file input
   val out = TextIO.openOut output
   val all_rules = List.concat (Tab.range Tab.rules)
   val rules = map (fn (i, r) => (i, Compile.compile r)) all_rules
   val tables = Indices.canonicalize (Compile.indices (map #2 rules))
in
 ( Util.write out
      (fn () =>
        ( Interface.emitSig M_NAME
        ; Datatypes.emit ()
        ; Interface.emitStructHead MName M_NAME
        ; Util.incr ()
        ; Indices.emit tables
        ; Rules.emit tables rules
        ; Search.emit ()
        ; Util.decr ()
        ; Interface.emitStruct tables))
 ; TextIO.closeOut out)
end

fun err s = (print s; OS.Process.failure)

fun go (name, args) = (go_no_handle (name, args); OS.Process.success)
handle Success => OS.Process.success
     | Failure => OS.Process.failure
     | Lexer.LexError (c, s) =>
          err ("Lex error at " ^ Coord.toString c ^ "\n" ^ s ^ ".\n")
     | Parser.SyntaxError (NONE, s) =>
          err ("Parse error at end of file.\n")
     | Parser.SyntaxError (SOME pos, s) => 
          err ("Parse error at " ^ Pos.toString pos ^ "\n" ^ s ^ ".\n")
     | Types.TypeError (pos, s) =>
          err ("Type error at " ^ Pos.toString pos ^ "\n" ^ s ^ ".\n")
     | Worlds.WorldsError (pos, s) =>
          err ("World error at " ^ Pos.toString pos ^ "\n" ^ s ^ ".\n")
     | Modes.ModeError (pos, s) =>
          err ("Mode error at " ^ Pos.toString pos ^ "\n" ^ s ^ ".\n")
     | IO.Io {cause, function, name} =>
          err ( "I/O error trying to " ^ function ^ " " ^ name ^ ".\n"
                ^ exnMessage cause ^ "\n")
     | Fail s => err ("INTERNAL ERROR: `"^s^"'\n")
     | exn => err ( "Unexpected error: " ^ exnName exn ^ "\n" 
                    ^ exnMessage exn ^ "\n") 


end
