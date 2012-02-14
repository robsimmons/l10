for i in 1 2 4 8 16 32 64 128 256 512 1024 # 2048 4096 8192 16384
do
    echo "== $i ============"
    echo "val SIZE: IntInf.int = $i;" > tmp
    time cat tmp transitive2.sml  | sml > /dev/null
done
rm tmp
