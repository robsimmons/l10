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

These two commands create a file `examples/EdgePath1.l10.sml`, which implements 
a structure EdgePath1 satisfying the following signature:

```sml
signature EDGE_PATH1 =
sig
   type db (* Type of L10 databases *)
   val empty: unit -> db
   
   type t         = Symbol.symbol (* extensible *)
   type rel    (* = Rel.t *)
   type world  (* = World.t *)
   type string    = String.string (* builtin *)
   type nat       = IntInf.int (* builtin *)
   
   structure Assert:
   sig
      val path: (t * t) * db -> db
      val edge: (t * t) * db -> db
   end
   
   structure Query:
   sig
      val path: db -> (t * t) -> bool
      val edge: db -> (t * t) -> bool
   end
end
```

The generated code from Elton depends on the CMlib v1, which can be obtained
with [Smackage](https://github.com/standardml/smackage). It can be run like 
this:

```code
$ sml '$SMACKAGE/cmlib/v1/cmlib.cm' examples/EdgePath1.l10.sml
<snip>
- val [a,b,c,d] = map Symbol.fromValue ["a","b","c","d"];
val a = - : StringSymbol.symbol
val b = - : StringSymbol.symbol
val c = - : StringSymbol.symbol
val d = - : StringSymbol.symbol
- foldr EdgePath1.Assert.edge (EdgePath1.empty ()) [(a,b), (c,d), (b,c)];
val it = - : db
- val db = it;
val db = - : db
- EdgePath1.Query.edge db (a, d);
val it = false : bool
- EdgePath1.Query.path db (a, d);
val it = true : bool
```

