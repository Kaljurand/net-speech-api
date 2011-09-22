# Declare the name of the grammar and the paths to the used libraries
g="Exp"
path="../SimpleNumerals/:../lib/"

# These you probably do not need to modify
l_est="${g}Est"
l_estl="${g}Estl"
l_app="${g}App"

g_est="${l_est}.gf"
g_estl="${l_estl}.gf"
g_app="${l_app}.gf"

examples="examples/"
e_est="${examples}Est.txt"


# These are the actual tests
echo "read_file -file=\"${e_est}\" -lines | p -lang=${l_est} | l" | gf --run --path $path ${g_est} ${g_app}
echo "read_file -file=\"${e_est}\" -lines | p -lang=${l_estl} | l" | gf --run --path $path ${g_estl} ${g_app}
