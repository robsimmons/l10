L10 Logic Programming Language
==============================

This is a source repository for the L10 programming language. Currently, the
repository contains a working version of the interpreter, for L10; a compiler 
to Standard ML and the X10 parallel programming language are in development.

For information on L10 see the 
[preliminary design document](http://robsimmons.bitbucket.org/l10/spec.html),
or the [examples](robsimmons.bitbucket.org/l10/examples.html) page.

Running the SML Interpreter (smlten)
====================================

The following is an example of loading two different L10 programs in the SML
interpreter for L10. For the first example, a standard edge/path example, we
run the program to saturation and use PredSet.printSet to print out the
entire database. For the second example, a regular expression matcher, we 
use PredSet.match to selectively query the resulting database of facts. 

    bash-3.2$ cd l10
    bash-3.2$ sml -m sml/smlten.cm   
    - Go.readfiles ["examples/EdgePath1.l10"];
    - val db1 = Deduce.deduceStored "db1";
    - PredSet.printSet db1;
    - Reset.reset ();
    - Go.readfiles ["examples/Regexp.l10", 
                    "examples/RegexpQuery.l10", 
                    "examples/RegexpNot.l10", 
                    "examples/RegexpNot2.l10"];
    - fun matches db = 
         let 
            open Ast
            open Symbol
         in 
            print "Regexp matches for the full string:\n";
            app (fn x => print (Subst.to_string x ^ "\n")) 
               (PredSet.match (db, Subst.empty,
                  (symbol "match", [ Var (SOME (symbol "RE")), 
                                     NatConst 0,
                                     NatConst 3 ])))
          end;
    - matches (Deduce.deduceStored "db1");
    - matches (Deduce.deduceStored "db2");
    - matches (Deduce.deduceStored "db3c");
    - matches (Deduce.deduceStored "db4c");
    - Reset.reset ();
    - Go.readfiles ["examples/ProgAnalysisA.l10", 
                    "examples/ProgAnalysisB.l10", 
                    "examples/ProgAnalysisC.l10", 
                    "examples/ProgAnalysisD.l10", 
                    "examples/ProgAnalysisE.l10"];
