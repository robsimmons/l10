../../bin/elton --directory=/tmp --prefix=cyk cyk.l10

for i in 10 20 50 100 200 500 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000
do
    echo "== $i ============"
    echo "val SIZE = $i;" > tmp
    time cat tmp cyk.sml  | sml > /dev/null
done
rm tmp