echo "Removing automatically generated files..."
ant clean

echo "Testing..."
for x in Go Numerals Unitconv; do
	echo " $x";
	cd $x;
	sh test.sh > test_out.txt;
	diff test_gold.txt test_out.txt;
	cd ..
done
echo "done."
