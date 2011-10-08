name="Estvrp"
path="../lib/:../Digit/:../Letter/"

# Testing the roundtrip: App -> Est -> App

cat examples/App.txt |\
sed "s/^/p -lang=App \"/" |\
sed 's/$/" | l -tr -lang=Est -all | p -lang=Est | l -lang=App/' |\
gf --run --path $path ${name}App.gf ${name}Est.gf
