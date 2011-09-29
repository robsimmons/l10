MLTON = mlton -const "Exn.keepHistory true" -default-ann "redundantMatch error" -default-ann "sequenceNonUnit error" -output 

bin:
	mkdir bin

.PHONY:lexyacc
lexyacc:
	mllex sml/syntax/l10.lex
	mlyacc sml/syntax/l10.grm

.PHONY: smlten
smlten: lexyacc
	$(MLTON) bin/smlten sml/sources.mlb

.PHONY: elton
elton: lexyacc bin
	$(MLTON) bin/elton sml/elton.mlb

frontend-basic: sml/*.sml sml/l10.lex sml/l10.grm
	mlton -output bin/l10front sml/sources.mlb

l10toy: src/l10/lang/*.x10
	x10c++ -MAIN_CLASS=l10.lang.Go src/l10/lang/*.x10

