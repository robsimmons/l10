MLTON = mlton -const "Exn.keepHistory true" -default-ann "redundantMatch error" -default-ann "sequenceNonUnit error" -output 

smlten: sml/*.sml sml/parse/l10.lex sml/parse/l10.grm
	mllex sml/parse/l10.lex
	mlyacc sml/parse/l10.grm
	$(MLTON) bin/smlten sml/sources.mlb

frontend-basic: sml/*.sml sml/l10.lex sml/l10.grm
	mlton -output bin/l10front sml/sources.mlb

l10toy: src/l10/lang/*.x10
	x10c++ -MAIN_CLASS=l10.lang.Go src/l10/lang/*.x10

