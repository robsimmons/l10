val () =
   let in 
      Elton.go (CommandLine.name (), CommandLine.arguments ())
      ; OS.Process.Exit OS.Process.success
   end handle Die status => OS.Process.Exit status 

