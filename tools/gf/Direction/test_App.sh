name=$1
path=$2

# These you probably do not need to modify
l="${name}App"

l_f="${l}.gf"

examples="examples/"
e_f="${examples}App.txt"

# These are the actual tests
cat ${e_f} | sed "s/^/p -tr -lang=${l} \"/" | sed 's/$/" | l -all/' | gf --run --path $path ${l_f}
