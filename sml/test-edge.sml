CM.make "sml/elton.cm";
 
fun smlfile name = "/tmp/" ^ SMLCompileUtil.getPrefix false "." ^ name ^ ".sml";

fun test (prefix, files) = 
  (CompilerState.reset ()
   ; SMLCompileUtil.setPrefix prefix
   ; Read.files files
   ; CompilerState.load ()
   ; SMLCompileUtil.write (smlfile "terms-sig") SMLCompileTerms.termsSig
   ; SMLCompileUtil.write (smlfile "terms") SMLCompileTerms.terms
   ; SMLCompileUtil.write (smlfile "tables") SMLCompileTables.tables
   ; SMLCompileUtil.write (smlfile "search-sig") SMLCompileSearch.searchSig
   ; SMLCompileUtil.write (smlfile "search") SMLCompileSearch.search);

test ("edge", [ "examples/EdgePath1.l10" ]);
use (smlfile "terms-sig");
use (smlfile "terms");
use (smlfile "tables");
use (smlfile "search-sig");
use (smlfile "search");

val () = 
   (EdgeTables.assertEdge (Symbol.symbol "a", Symbol.symbol "b")
    ; EdgeTables.assertEdge (Symbol.symbol "b", Symbol.symbol "c")
    ; EdgeTables.assertEdge (Symbol.symbol "c", Symbol.symbol "d")
    ; EdgeTables.assertEdge (Symbol.symbol "d", Symbol.symbol "e")
    ; EdgeTables.assertEdge (Symbol.symbol "a", Symbol.symbol "b2")
    ; EdgeTables.assertEdge (Symbol.symbol "b2", Symbol.symbol "c2")
    ; EdgeTables.assertEdge (Symbol.symbol "a", Symbol.symbol "b3"));

map Symbol.name 
   (EdgeTables.path_1_lookup (!EdgeTables.path_1, Symbol.symbol "a"));

ignore (EdgeSearch.saturateW1 EdgeTerms.MapWorld.empty);

map Symbol.name 
   (EdgeTables.path_1_lookup (!EdgeTables.path_1, Symbol.symbol "a"));
