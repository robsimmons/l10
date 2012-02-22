MLTON = mlton -verbose 1 -default-ann "redundantMatch error" -default-ann "sequenceNonUnit error" -output 
SML = sml

all:
	@echo "== Elton (a compiler from L10 to Standard ML) =="
	@echo "Installation instructions:"
	@echo ""
	@echo "From source: run 'make mlton' or 'make smlnj' or 'make check'"
	@echo "In Smackage:"
	@echo "   (1) Run 'smackage make elton mlton' (or '... smlnj')"
	@echo "   (2) Run 'smackage make elton install'"
	false

bin:
	mkdir bin

sml/l10.cmlex.sml: sml/l10.cmlex
	cmlex sml/l10.cmlex

sml/l10.cmyacc.sml: sml/l10.cmyacc
	cmyacc sml/l10.cmyacc

mlton: sml/*.sml sml/compile-sml/*.sml bin
	$(MLTON) bin/elton sml/elton.mlb

smlnj: sml/*.sml sml/compile-sml/*.sml bin
	$(SML) < sml/go-smlnj.sml
	bin/.mkexec `which sml` `pwd`/bin elton 

.PSEUDO: check
check: sml/*.sml sml/compile-sml/*.sml
	echo "Regression.checkDirs [ \"regression\", \"examples\" ]; Regression.reportAndReset ();" | sml -m sml/sources.cm

.PSEUDO: install
install:
	rm -f $(DESTDIR)/bin/smackage.new
	cp bin/smackage $(DESTDIR)/bin/smackage.new
	mv $(DESTDIR)/bin/smackage.new $(DESTDIR)/bin/smackage
