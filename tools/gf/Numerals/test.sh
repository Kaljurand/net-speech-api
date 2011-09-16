
# This is not needed for speech recognition
echo "parse -tr -lang=decimal \"9 8 7 5 4 1\" | l | ps -bind" | gf --run english.gf decimal.gf estonian.gf
echo "parse -tr -lang=decimal \"1 0 0\" | l | ps -bind" | gf --run english.gf decimal.gf estonian.gf
echo "parse -tr -lang=decimal \"1 1\" | l | ps -bind" | gf --run english.gf decimal.gf estonian.gf
echo "parse -tr -lang=decimal \"1 1 1\" | l | ps -bind" | gf --run english.gf decimal.gf estonian.gf
echo "parse -tr -lang=decimal \"3 9 8 7 5 4 1\" | l | ps -bind" | gf --run english.gf decimal.gf estonian.gf
echo "parse -tr -lang=decimal \"4 3 1 7\" | l | ps -bind" | gf --run english.gf decimal.gf estonian.gf

#echo "generate_trees -depth=4 | l" | gf --run decimal.gf estonian.gf


# Normalization: this is needed as a post-processing step after speech recognition"
# Need to write a lexer than splits off -sada, -kymmend, and -teist

echo "Normalizing: kaks tuhat kaks"
echo "ps \"kaks tuhat kaks\" | parse -tr -lang=estonian | l -lang=decimal | ps -unchars" | gf --run decimal.gf estonian.gf

echo "Normalizing: sada üksteist"
echo "parse -tr -lang=estonian \"sada üksteist\" | l -lang=decimal | ps -unchars" | gf --run decimal.gf estonian.gf

echo "Normalizing: kaks tuhat kakskümmend kakssada kaksteist"
echo "ps \"kaks tuhat kakskümmend kakssada kaksteist\" | parse -tr -lang=estonian | l -lang=decimal | ps -unchars" | gf --run decimal.gf estonian.gf
