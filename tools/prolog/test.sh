
cat test_lines.txt | swipl -f words_to_numbers.pl -g main -t halt -q > test_lines.out
#cat test_lines.txt | yap -l words_to_numbers.pl -g main -q > test_lines.out
git diff test_lines.out
