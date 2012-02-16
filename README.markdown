L10 Logic Programming Language
==============================

This is a source repository for the L10 programming language. It contains a lot
of stuff, the most interesting of which (currently) is the 
[Elton compiler](https://github.com/robsimmons/l10/wiki/Elton-compiler)
from L10 to Standard ML. There are also lots of pieces of a compiler from L10 
to the X10 distributed programming language.

See the [wiki](https://github.com/robsimmons/l10/wiki) for more.

# Compiling Elton

```code
$ make elton
$ bin/elton examples/EdgePath1.l10
```

These two commands read the file `EdgePath1.l10`...

```l10
edge: string -> string -> rel.
path: string -> string -> rel.

edge X Y -> path X Y.
edge X Y, path Y Z -> path X Z.

example = edge "a" "b", edge "b" "c", edge "b" "d", edge "a" "e", edge "d" "f".
```

... and create a file `EdgePath1.l10.sml`, which implements 
a structure EdgePath1 satisfying the following signature, which appears
at the top of the generated file:

```sml
signature EDGE_PATH1 =
sig
   type db (* Type of L10 databases *)
   val empty: db
   val example: db
   
   type string    = String.string (* builtin *)
   type nat       = IntInf.int (* builtin *)
   
   structure Assert:
   sig
      val path: (string * string) * db -> db
      val edge: (string * string) * db -> db
   end
   
   structure Query:
   sig
      val path: db -> (string * string) -> bool
      val edge: db -> (string * string) -> bool
   end
end
```

The generated code from Elton depends on the CMlib v1, which can be obtained
with [Smackage](https://github.com/standardml/smackage). It can be run like 
this:

```code
$ sml '$SMACKAGE/cmlib/v1/cmlib.cm' examples/EdgePath1.l10.sml
<snip>
- EdgePath1.Query.edge EdgePath1.example ("a", "f");
val it = false : bool
- EdgePath1.Query.path EdgePath1.example ("a", "f");
val it = true : bool
```

