abstract Estvrp = Digit, Letter ** {

-- Vehicle registration plates (vrp) of Estonia are composed of
-- three digits and three letters (e.g. 123 ABC).

flags startcat = Estvrp;

cat Estvrp;

fun
	estvrp : (_, _, _ : Digit) -> (_, _, _ : Letter) -> Estvrp;
}
