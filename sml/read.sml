(* File input of L10 programs *)
(* Robert J. Simmons *)

structure Read:> sig
   (* Reads and checks a file or a list of files loads them into memory *)
   val file: string -> unit
   val files: string list -> unit
end = 
struct

(*[ val stream_front: Decl.decl_t Stream.stream -> 
       Decl.decl_t Stream.front ]*)
val stream_front = Stream.front

(*[ val stream_cons: Decl.decl_t * Decl.decl_t Stream.stream ->
       Decl.decl_t Stream.front ]*)
val stream_cons = Stream.Cons

(*[ val stream_map: (Decl.decl -> Decl.decl_t) ->
       Decl.decl Stream.stream -> Decl.decl_t Stream.stream ]*)
val stream_map = Stream.map


(* Core loading function! *)
(*[ val load: Decl.decl_t Stream.stream -> unit ]*)
fun load stream = 
   case stream_front stream of
      Stream.Nil => ()
    | Stream.Cons (decl as (Decl.Rule rule), stream) => 
         (* XXX Needs to bind the rule *and* the associated dependency *)
         ( Tab.bind decl
         ; Decl.print decl 
         ; load stream)
    | Stream.Cons (decl, stream) => 
         ( Tab.bind decl
         ; Decl.print decl
         ; load stream)


(* Not currently used *)
(*[ val split: Decl.decl_t Stream.stream -> 
       Decl.decl_t Stream.stream * Decl.decl_t Stream.stream]*)
fun split declstream = 
   let 
      fun waiton (Decl.Query _) = true
        | waiton (Decl.DB _) = true
        | waiton _ = false

      fun filter' f stream () = 
         case stream_front stream of 
            Stream.Nil => Stream.Nil
          | Stream.Cons (item, stream) => 
               if f item 
               then Stream.Cons (item, Stream.lazy (filter' f stream))
               else filter' f stream ()
 
      fun filter f stream = Stream.lazy (filter' f stream)
   in
      (filter (not o waiton) declstream, filter waiton declstream)
   end


(* Files *)
fun readfile filename = 
   let 
      val file = TextIO.openIn filename 
      val stream = 
         stream_map Types.check 
            (Parser.parse (Lexer.lex filename (Stream.fromInstream file)))
   in
      ( print ("[ == Opening " ^ filename ^ " == ]\n")
      ; load stream
        handle exn => ((TextIO.closeIn file handle _ => ()); raise exn)
      ; print ("[ == Closing " ^ filename ^ " == ]\n\n"))
   end
      handle Lexer.LexError (c, s) =>
                print ("Lex error at " ^ Coord.toString c ^ "\n" ^ s ^ ".\n")
           | Parser.SyntaxError (NONE, s) =>
                print ("Parse error at end of file.\n")
           | Parser.SyntaxError (SOME pos, s) => 
                print ("Parse error at " ^ Pos.toString pos ^ "\n" ^ s ^ ".\n")
           | Types.TypeError (pos, s) =>
                print ("Type errror at " ^ Pos.toString pos ^ "\n" ^ s ^ ".\n")
           | exn => print ("Unexpected error: " ^ exnName exn ^ "\n" 
                           ^ exnMessage exn ^ "\n") 

fun readfiles files = app readfile files

val file = readfile
val files = readfiles

end
