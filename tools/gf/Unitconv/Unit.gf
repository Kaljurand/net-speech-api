abstract Unit = {

-- Here one must register all the measurement units and their types.

cat
	LengthUnit ;
	VolumeUnit ;
	WeightUnit ;
	TimeUnit ;

fun
	meter, foot : LengthUnit ;
	liter, cup : VolumeUnit ;
	cup_flour : WeightUnit ;
	second, minute, hour : TimeUnit ;

}
