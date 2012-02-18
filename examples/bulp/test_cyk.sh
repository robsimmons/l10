rm -f cyk
rm -f cyk.l10.sml
../../bin/elton cyk.l10

echo "== CYK test with MLton (building) ============"
time mlton cyk.mlb

for i in 2000 4000 6000 8000 10000 12000 14000 16000 18000 20000
do
    echo ""
    echo "== $i ============"
    time ./cyk $i 
done
