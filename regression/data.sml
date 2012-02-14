structure Mode = struct datatype t = Input | Output | Ignore end
struct A =
struct
   datatype foo = Leaf | Next of bar
   and bar = Branch of foo * foo
end
structure Foo = struct datatype t = datatype A.foo end
structure Bar = struct datatype t = datatype A.bar end
