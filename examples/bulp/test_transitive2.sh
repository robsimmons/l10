rm -f transitive2
rm -f transitive2.l10.sml
../../bin/elton transitive2.l10

echo "== Transitive Path/Path test with MLton (building) ============"
time mlton transitive2.mlb

for i in 64 128 256 512 1024 # 2048 4096 8192 16384
do
    echo ""
    echo "== $i ============"
    time ./transitive2 $i
done
