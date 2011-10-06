abstract Direction = Address ** {

flags startcat = Direction;

cat Direction;

fun
	direction : Address -> Address -> Direction;

}
