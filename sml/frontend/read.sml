(* File input of L10 programs *)
(* Robert J. Simmons *)

structure Read:> sig

   (* Reads and checks a file or a list of files loads them into memory *)
   val file: string -> unit
   val files: string list -> unit

end = 
struct

(* Reads a file, *)
fun run filein force =
   let 
      fun loop NONE = print ("[ == Closing " ^ filein ^ " == ]\n")
        | loop (SOME stream) = 
          let 
             val (decl, stream) = force stream
          in 
             Types.checkDecl decl
             ; Load.loadDecl decl
             ; loop stream
          end
   in
      loop
   end handle Parse.Parse s =>
              raise Fail ("Error parsing " ^ filein ^ ".\nProblem: " ^ s)

fun readfile filein = 
   let
      val () = print ("[ == Opening " ^ filein ^ " == ]\n\n")
      val (stream, force) = Parse.parse filein
         handle IO.Io {name, function, cause} =>
         raise Fail ("unable to open " ^ name ^ " (error " ^ function ^ ")")
   in 
      run filein force stream 
   end 

fun readfiles files = app readfile files

val file = readfile
val files = readfiles

end
