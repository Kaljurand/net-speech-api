# Usage:
# cat tallinn3.htm  | sh filter.sh

grep "<br>" |\
grep -v "\." |\
sed -f filter.sed |\
sort |\
uniq
