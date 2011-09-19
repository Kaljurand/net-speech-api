export GF_LIB_PATH="../lib/"

echo "Testing: decimal -> ALL"
echo

echo "read_file -file=\"examples/decimal.txt\" -lines | p -tr -lang=decimal | l | ps -bind" | gf --run decimal.gf estonian.gf

echo "Testing: estonian -> decimal"
echo
echo "read_file -file=\"examples/estonian.txt\" -lines | p -tr -lang=estonian | l -lang=decimal | ps -unchars" | gf --run decimal.gf estonian.gf
