L10 Logic Programming Language
==============================

This is a source repository for the L10 programming language. It contains a lot
of stuff, the most interesting of which (currently) is the 
[Elton compiler](https://github.com/robsimmons/l10/wiki/Elton-compiler)
from L10 to Standard ML. There are also lots of pieces of a compiler from L10 
to the X10 distributed programming language. See the 
[GitHub wiki](https://github.com/robsimmons/l10/wiki) for more.

# Elton, the L10-to-Standard ML Compiler

## Installation

Elton depends on [CMlib](https://github.com/standardml/cmlib) version 1, which 
can be installed with [Smackage](https://github.com/standardml/smackage). Once
you already have smackage, it's easiest to install Elton through smackage:

```code
$ smackage get elton
$ smackage make elton mlton # or "smackage make elton smlnj"
$ smackage make elton install
$ elton examples/EdgePath1.l10
````

You can also built Elton by downloading the source directly:

```code
$ make 
Elton - a compiler from L10 to Standard ML
Run 'make mlton' or 'make smlnj' or 'make check'
$ make mlton
$ bin/elton examples/EdgePath1.l10
```

## Use

The commands `elton examples/EdgePath1.l10` (Smackage installation) and 
`bin/elton examples/EdgePath1.l10` (source installation) read the file 
`EdgePath1.l10`...

```l10
edge: string -> string -> rel.
path: string -> string -> rel.

edge X Y -> path X Y.
edge X Y, path Y Z -> path X Z.

example = edge "a" "b", edge "b" "c", edge "b" "d", edge "a" "e", edge "d" "f".
```

... and create a file `EdgePath1.l10.sml`. This Elton-generated file
contains a structure `EdgePath1` satisfying the following signature:

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

The signature `EDGE_PATH1` appears at the top of the Elton-generated file
`EdgePath1.l10.sml`.

The generated code from Elton depends on the 
[CMlib](https://github.com/standardml/cmlib) version 1, which can be obtained
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

