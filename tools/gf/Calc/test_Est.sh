
# Declare the name of the grammar and the paths to the used libraries
name="Calc"
path="../Exp/:../Unitconv/:../Numerals/:../lib/"

# These you probably do not need to modify
l="${name}Est"

l_f="${l}.gf"

examples="examples/"
e_f="${examples}Est.txt"

# These are the actual tests
cat ${e_f} | sed "s/^/p -tr -lang=${l} \"/" | sed 's/$/" | l -all/' | gf --run --path $path ${l_f}
