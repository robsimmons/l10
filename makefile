MLTON = mlton -const "Exn.keepHistory true" -default-ann "redundantMatch error" -default-ann "sequenceNonUnit warn" -output 

bin:
	mkdir bin

sml/l10.cmlex.sml:
	cmlex sml/l10.cmlex

sml/l10.cmyacc.sml:
	cmyacc sml/l10.cmyacc

elton: sml/*.sml sml/compile-sml/*.sml
	$(MLTON) bin/elton sml/sources.mlb
