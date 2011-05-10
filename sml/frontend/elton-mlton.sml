val () =
   let in 
      Elton.go (CommandLine.name (), CommandLine.arguments ())
      ; OS.Process.exit OS.Process.success
   end handle Elton.Die status => OS.Process.exit status 

