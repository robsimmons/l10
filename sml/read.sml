(* File input of L10 programs *)
(* Robert J. Simmons *)

structure Read:> sig
   (* Reads and checks a file or a list of files loads them into memory *)
   val file: string -> unit
   val files: string list -> unit
end = 
struct

(* Reads a file, *)

(*[ val readdecls: Decl.decl_t Stream.stream -> unit ]*)
fun readdecls stream = 
   case (Stream.front 
           (*[ <: Decl.decl_t Stream.stream -> Decl.decl_t Stream.front ]*)) 
           stream of
      Stream.Nil => ()
    | Stream.Cons (Decl.Rule (rule as (pos, _, _)), stream) => 
         (* Needs to bind two decls: the rule and the associated dependency *)
         ( raise Types.TypeError (pos, "Not prepared to handle rule decls"))
    | Stream.Cons (decl, stream) => 
         ( Tab.bind decl
         ; Decl.print decl
         ; readdecls stream)

fun readfile filename = 
   let 
      val file = TextIO.openIn filename 
      val stream = 
         (Stream.map
            (*[ <: (Decl.decl -> Decl.decl_t)
                      -> Decl.decl Stream.stream 
                      -> Decl.decl_t Stream.stream ]*)) 
            Types.check 
            (Parser.parse (Lexer.lex filename (Stream.fromInstream file)))
   in
      ( print ("[ == Opening " ^ filename ^ " == ]\n\n")
      ; readdecls stream
        handle exn => (TextIO.closeIn file; raise exn)
      ; print ("[ == Closing " ^ filename ^ " == ]\n\n"))
   end

fun readfiles files = app readfile files

val file = readfile
val files = readfiles

end
