MLTON = mlton -verbose 1 -const "Exn.keepHistory true" -default-ann "redundantMatch error" -default-ann "sequenceNonUnit error" -output 
SML = sml

all:
	@echo "Elton - a compiler from L10 to Standard ML"
	@echo "Run 'make mlton' or 'make smlnj' or 'make check'"

bin:
	mkdir bin

sml/l10.cmlex.sml:
	cmlex sml/l10.cmlex

sml/l10.cmyacc.sml:
	cmyacc sml/l10.cmyacc

mlton: sml/*.sml sml/compile-sml/*.sml
	$(MLTON) bin/elton sml/elton.mlb

smlnj: sml/*.sml sml/compile-sml/*.sml
	$(SML) < sml/go-smlnj.sml
	bin/.mkexec `which sml` `pwd`/bin elton 

.PSEUDO: check
check: sml/*.sml sml/compile-sml/*.sml
	echo "Regression.checkDirs [ \"regression\", \"examples\" ]; Regression.reportAndReset ();" | sml -m sml/sources.cm