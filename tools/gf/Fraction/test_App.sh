# Declare the name of the grammar and the paths to the used libraries
name="Fraction"

export GF_LIB_PATH="../"

# These you probably do not need to modify
l="${name}App"

l_f="${l}.gf"

examples="examples/"
e_f="${examples}App.txt"

# These are the actual tests
cat ${e_f} | sed "s/^/p -tr -lang=${l} \"/" | sed 's/$/" | l -all/' | gf --run ${l_f}
