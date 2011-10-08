abstract Action = Direction, Calc ** {

flags startcat = Action;

cat Action;

fun
	f1 : Direction -> Action;
	f2 : Calc -> Action;
}
