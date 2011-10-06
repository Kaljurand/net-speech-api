abstract Action = Address, Direction, Calc ** {

flags startcat = Action;

cat Action;

fun
	f1 : Address -> Action;
	f2 : Direction -> Action;
	f3 : Calc -> Action;
}
