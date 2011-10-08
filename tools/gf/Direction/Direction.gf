abstract Direction = Address ** {

flags startcat = Direction;

cat Direction;

fun
	direction_id : Address -> Direction;
	direction : Address -> Address -> Direction;

}
