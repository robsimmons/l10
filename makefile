frontend: sml/*.sml sml/l10.lex sml/l10.grm
	mllex sml/l10.lex
	mlyacc sml/l10.grm
	mlton -output bin/l10front sml/sources.mlb

frontend-basic: sml/*.sml sml/l10.lex sml/l10.grm
	mlton -output bin/l10front sml/sources.mlb

l10toy: src/l10/lang/*.x10
	x10c++ -MAIN_CLASS=l10.lang.Go src/l10/lang/*.x10

