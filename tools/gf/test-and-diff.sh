for x in Go Numerals Unitconv; do
	echo "Testing $x";
	cd $x;
	sh test.sh > test_out.txt;
	diff test_gold.txt test_out.txt;
	cd ..
done
