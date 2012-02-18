rm -f transitive1
rm -f transitive1.l10.sml
../../bin/elton transitive1.l10

echo "== Transitive Edge/Path test with MLton (building) ============"
time mlton transitive1.mlb

for i in 128 256 512 1024 2048 4096 # 8192 16384
do
    echo ""
    echo "== $i ============"
    time ./transitive1 $i
done
