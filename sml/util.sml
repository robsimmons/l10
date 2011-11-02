(* Generally useful utilities, primarily used for emitting code *)
(* Robert J. Simmons *)

structure Util:> sig
   (* Stateful; set or unset the indent *)
   val emit: string list -> unit
   val incr: unit -> unit
   val decr: unit -> unit

   (* Write: output to a particular stream *)
   val write: TextIO.outstream -> (unit -> unit) -> unit

   (* Annotate a listwith ints *)
   val mapi: (int * 'a -> 'b) -> 'a list -> 'b list
   val intify: 'a list -> (int * 'a) list 

   (* Application utility functions *)
   val appSuper:
      (unit -> unit)                                (* There are no items *)
      -> ('a -> unit)                               (* There is one item *)
      -> ('a -> unit) * ('a -> unit) * ('a -> unit) (* First, middle, last *)
      -> 'a list                                    (* List *) 
      -> unit

   val appFirst: 
      (unit -> unit)       (* Function if there are no items *)
      -> ('a * 'b -> unit) (* Function for each item *)
      -> ('a * 'a)         (* Data for first item, data for other items *)
      -> 'b list           (* List of items *)
      -> unit 
end =
struct

fun mapi' f n [] alloc = rev alloc
  | mapi' f n (x :: xs) alloc = mapi' f (n+1) xs (f (n, x) :: alloc)

fun mapi f xs = mapi' f 0 xs []

fun intify xs = mapi (fn x => x) xs

fun 'a appSuper none one (first, middle, last) xs: unit = 
let 
   (*[ val loop: ('a conslist) -> unit ]*)
   fun loop [ x ] = last x
     | loop (x :: y :: xs) = (middle x; loop (y :: xs))
in case xs of 
      [] => none ()
    | [ x ] => one x
    | x :: y :: xs => (first x; loop (y :: xs))
end

fun appFirst none some (first, rest) = 
let 
   fun first' x = some (first, x)
   fun rest' x = some (rest, x)
in
   appSuper none first' (first', rest', rest') 
end

local 
   val outstream: TextIO.outstream option ref = 
      (ref NONE (*[ <: TextIO.outstream option ref ]*))
   val ind = ref ""
in
   fun emit1 s = 
   let val s' = !ind ^ s ^ "\n"
   in case !outstream of 
         NONE => print s'
       | SOME stream => TextIO.output (stream, s')
   end

   val emit = app emit1

   fun incr () = ind := !ind ^ "   "

   fun decr () = 
      case !ind of 
         "" => raise Fail "Unbalanced increment/decrement"
       | s => ind := String.extract (!ind, 3, NONE)

   fun write stream f = 
      case !outstream of 
         NONE => 
         let in
          ( outstream := SOME stream 
          ; f ()
          ; outstream := NONE) 
         handle exn => (outstream := NONE; raise exn)
         end
       | SOME _ => raise Fail "Nested calls to write"
end

end

(*
structure SMLCompileUtil:> sig
   
   (* Prefix, concatenated onto the beginning of structures and filenames. 
    * Must be alphanumeric starting with a character, default is "L10" *)
   val setPrefix: string -> unit

   (* getPrefix inUppercase separator
    * Outputs the preface in uppercase or lowercase, separator is included
    * if the prefix is nonempty.
    * 
    * After running setPreface "l10" 
    * preface false "." ^ "types.sml" = "l10.types.sml" 
    * preface true "_" ^ "TYPES" = "L10_TYPES"
    *
    * After running setPreface ""
    * preface false "." ^ "types.sml" = "types.sml" 
    * preface true "_" ^ "TYPES" = "TYPES" *)
   val getPrefix: bool -> string -> string

   (* Output functions for emitting code or setting/unsetting the indent *)
   val emit: string -> unit
   val incr: unit -> unit
   val decr: unit -> unit

   (* Write redirects the "emit" side effects of the unit -> unit code into
    * the file with the given filename. *)
   val write: string -> (unit -> unit) -> unit

   (* Capitalizes the first character in a string; must be lower case *)
   val embiggen: string -> string

   (* Create a tuple: optTuple emits nothing on unit *)
   val tuple: ('a -> string) -> 'a list -> string
   val optTuple: ('a -> string) -> 'a list -> string
      

   (* Fiddly utility functions *)
   val appFirst: 
      (unit -> unit)        (* Function if there are no items *)
      -> ('a -> 'b -> unit) (* Function for each item *)
      -> ('a * 'a)          (* Data for first item, data for other items *)
      -> 'b list            (* List of items *)
      -> unit 
   val mapi: 'a list -> (int * 'a) list (* Annotate a list with ints *)
   val repeat: int * char -> string     (* Length n string of chars  *)
   val bigName: Symbol.symbol -> string (* embiggen o Symbol.name    *)
   val nameOfExec: int * int -> string

end = 
struct

fun mapi' n [] = []
  | mapi' n (x :: xs) = (n, x) :: mapi' (n+1) xs

fun mapi xs = mapi' 0 xs

fun appFirst g _ _ [] = g ()
  | appFirst _ f (fst, rest) (x :: xs) = (f fst x; app (f rest) xs)

val prefix = ref "l10"

val Prefix = ref "L10"

fun embiggen' s = 
   let 
      val len = size s
      val fst = if len = 0 then raise Domain else String.sub (s, 0)
      val rest = String.substring (s, 1, len - 1)
   in
      str (Char.toUpper fst) ^ rest
   end

fun embiggen s = 
   let 
      val len = size s
      val fst = if len = 0 then raise Domain else String.sub (s, 0)
      val rest = String.substring (s, 1, len - 1)
   in
      if not (Char.isLower fst) 
      then raise Fail ("Function 'embiggen' called on string with " 
                       ^ "first character '" ^ str fst ^ "'")
      else str (Char.toUpper fst) ^ rest
   end

val bigName = embiggen o Symbol.name


fun setPrefix str = 
   if List.all Char.isAlphaNum (explode str)
   then (prefix := String.map Char.toLower str
         ; Prefix := embiggen str)
   else raise Fail ("String \"" ^ String.toCString str ^ "\" not alphanumeric")

fun getPrefix false postfix = if !prefix = "" then "" else !prefix ^ postfix
  | getPrefix true  postfix = if !Prefix = "" then "" else !Prefix ^ postfix

val outstream = ref TextIO.stdOut
val ind = ref 0 

fun emit s = 
   let val buffer = implode (List.tabulate (!ind, fn _ => #" "))
   in TextIO.output (!outstream, buffer ^ s ^ "\n") end

fun incr () = ind := !ind + 3

fun decr () = ind := !ind - 3

fun write filename (f: unit -> unit) = 
   let val started = ref false in
      (outstream := TextIO.openOut filename
       ; started := true
       ; ind := 0
       ; f ()
       ; TextIO.closeOut (!outstream)
       ; outstream := TextIO.stdOut)
      handle exn => (if !started then TextIO.closeOut (!outstream) else ()
                     ; outstream := TextIO.stdOut
                     ; print ("Error while outputting " ^ filename ^ "\n")
                     ; raise exn)
   end



fun repeat (n, c) = String.implode (List.tabulate (n, fn _ => c))

fun tuple f [ x ] = f x
  | tuple f xs = "(" ^ String.concatWith ", " (map f xs) ^ ")"

fun optTuple f [] = ""
  | optTuple f xs = " " ^ tuple f xs

fun nameOfExec (n, 0) = "exec" ^ Int.toString n
  | nameOfExec (n, m) = "exec" ^ Int.toString n ^ "_" ^ Int.toString m



end
*)
