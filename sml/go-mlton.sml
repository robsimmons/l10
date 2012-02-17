structure Go = 
struct

val () = Elton.go_no_handle (CommandLine.name (), CommandLine.arguments ())

(*
val () = OS.Process.exit
            (Elton.go (CommandLine.name (), CommandLine.arguments ()))
*)

end
