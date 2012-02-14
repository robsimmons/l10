structure Go = 
struct

val () = OS.Process.exit 
            (Elton.go (CommandLine.name (), CommandLine.arguments ()))

end
