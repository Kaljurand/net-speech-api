cd Numerals
sh test.sh > test_out.txt
diff test_gold.txt test_out.txt
cd ..
cd Go
sh test.sh > test_out.txt
diff test_gold.txt test_out.txt
cd ..
