echo "generate_trees -depth=5 | l " | gf --path ../lib/ decimal.gf estonian.gf > /tmp/all_numbers.txt
cat /tmp/all_numbers.txt | grep -v "^$" | sed "s/ //g" | sort -n > all_numbers.txt
wc -l all_numbers.txt
