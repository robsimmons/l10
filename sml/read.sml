(* File input of L10 programs *)
(* Robert J. Simmons *)

structure Read:> sig
   (* Reads and checks a file or a list of files loads them into memory *)
   val file: string -> unit
   val files: string list -> unit
end = 
struct

open Util

(*[ val stream_front: 
       Decl.decl_t Stream.stream 
       -> Decl.decl_t Stream.front ]*)
val stream_front = Stream.front

(*[ val stream_cons: 
       Decl.decl_t * Decl.decl_t Stream.stream
       -> Decl.decl_t Stream.front ]*)
val stream_cons = Stream.Cons

(*[ val stream_map: 
       (Decl.decl -> Decl.decl_t)
       -> Decl.decl Stream.stream
       -> Decl.decl_t Stream.stream ]*)
val stream_map = Stream.map

(* Core loading function! *)
(*[ val load: Decl.decl_t Stream.stream -> unit ]*)
fun load stream = 
   case stream_front stream of
      Stream.Nil => ()
    | Stream.Cons (decl as (Decl.Rule (pos, rule, fv)), stream) => 
      let 
         val depend = Worlds.ofRule rule 
         val fvWorld = Atom.fv (#2 (#1 depend))
         val _ = Modes.checkDepend depend
         val _ = Modes.checkRule rule fvWorld 
      in 
         ( Tab.bind (Decl.Depend (pos, depend, fv))
         ; Tab.bind decl
         ; Decl.print decl 
         ; load stream)
      end
    | Stream.Cons (decl as (Decl.Depend (_, depend, _)), stream) => 
         ( Modes.checkDepend depend
         ; Tab.bind decl
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
   (*[ val waiton: Decl.decl_t -> bool ]*)
   fun waiton (Decl.Query _) = true
     | waiton (Decl.DB _) = true
     | waiton _ = false

   (*[ val filter': 
          (Decl.decl_t -> bool)
          -> Decl.decl_t Stream.stream
          -> unit
          -> Decl.decl_t Stream.front ]*)
   fun filter' f stream () = 
      case stream_front stream of 
         Stream.Nil => Stream.Nil
       | Stream.Cons (item, stream) => 
            if f item 
            then Stream.Cons (item, Stream.lazy (filter' f stream))
            else filter' f stream ()
 
   (*[ val filter: 
          (Decl.decl_t -> bool) 
          -> Decl.decl_t Stream.stream
          -> Decl.decl_t Stream.stream ]*)
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
         (Parser.parse (Lexer.lex filename (Stream.fromTextInstream file))) 
in
 ( print ("[ == Opening " ^ filename ^ " == ]\n")
 ; load stream
   handle exn => ((TextIO.closeIn file handle _ => ()); raise exn)
 ; print ("[ == Closing " ^ filename ^ " == ]\n\n"))
end 

fun readfiles files = app readfile files

fun file s = readfile s 
fun files s = readfiles s

end
