# Generate numbers 1-999 and their corresponding words
n="all_numbers.txt"
w="all_words.txt"
b="all_both.txt"

echo "Generating ${n}"
echo "generate_trees -depth=5 (pot2as3 ?) | l" | gf --run --path ../lib/ decimal.gf > /tmp/${n}
cat /tmp/${n} | grep -v "^$" | sed "s/ //g" | sort | uniq -c | sort -nr > ${n}
wc -l ${n}

echo "Generating ${w}"
echo "generate_trees -depth=5 (pot2as3 ?) | l" | gf --run --path ../lib/ estonian.gf > /tmp/${w}
cat /tmp/${w} | grep -v "^$" | sort | uniq -c | sort -nr > ${w}
wc -l ${w}

echo "Generating both"
echo "generate_trees -depth=5 (pot2as3 ?) | l" | gf --run --path ../lib/ decimal.gf estonian.gf > /tmp/${b}
cat /tmp/${b} | grep -v "^$" | sort | uniq -c | sort -nr > ${b}
wc -l ${b}
