(* Abstract syntax tree for L10 *)
(* Robert J. Simmons *)


structure Test = struct 
   datatype foo = Leaf | Next of bar
   and bar = Branch of foo * foo
end
structure Foo = struct datatype t = datatype Test.foo end
structure Bar = struct datatype t = datatype Test.bar end









