OS.FileSys.chDir "../sml-cidre/src/cm2mlb";
CM.make "../Cidre/cidre.cm";

OS.FileSys.chDir "../../lib/refined-basis";
R.refine_file "bool.sml";
R.refine_file "option.sml";
R.refine_file "list.sml";

OS.FileSys.chDir "../../../cmlib/lib";
R.refine_file "coord.sig";
R.refine_file "coord.sml";
R.refine_file "hash-inc.sig";
R.refine_file "hash-inc.sml";
R.refine_file "iqueue.sig";
R.refine_file "iqueue.sml";
R.refine_file "ordered.sig";
R.refine_file "ordered.sml";
R.refine_file "pos.sig";
R.refine_file "pos.sml";
R.refine_file "quasilist.sig";
R.refine_file "quasilist.sml";
R.refine_file "red-black-tree.sml";
R.refine_file "sort.sig";
R.refine_file "splay-tree.sml";
R.refine_file "susp.sig";
R.refine_file "susp.sml";

R.refine_file "dict.sig";
R.refine_file "dict-list.sml";
R.refine_file "dict-red-black.sml";
R.refine_file "dict-splay.sml";
R.refine_file "mergesort.sml";
R.refine_file "set.sig";
R.refine_file "set-list.sml";
R.refine_file "set-red-black.sml";
R.refine_file "set-splay.sml";
R.refine_file "stream.sig";
R.refine_file "stream.sml";
R.refine_file "streamable.sig";
R.refine_file "streamable.sml";

R.refine_file "hashable.sig";
R.refine_file "hashable.sml";
R.refine_file "hash-table.sig";
R.refine_file "hash-table.sml";
R.refine_file "lex-engine.sig";
R.refine_file "lex-engine.sml";
R.refine_file "markstream.sml";
R.refine_file "multi-table.sig";
R.refine_file "multi-table-dict.sml";
R.refine_file "parsing.sig";
R.refine_file "parsing.sml";
R.refine_file "table.sig";
R.refine_file "table-dict.sml";
R.refine_file "table-hash.sml";

R.refine_file "parse-engine.sig";
R.refine_file "parse-engine.sml";
R.refine_file "symbol.sig";
R.refine_file "symbol.sml";

OS.FileSys.chDir "../../l10/sml";
R.refine_file "bogus-intinf.sml";

R.refine_file "cmlib-defaults.sml";

R.refine_file "syntax.sml";
R.refine_file "l10.cmlex.sml";
R.refine_file "lexer.sml";
R.refine_file "l10.cmyacc.sml";
R.refine_file "parser.sml";

R.refine_file "tab.sml";
R.refine_file "check-types.sml";

R.Flags.DEBUG_REFOBJECTS := true;
