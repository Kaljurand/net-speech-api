abstract Unit = {

-- Here one must register all the measurement units and their types.

cat
	LengthUnit ;
	MassUnit ;
	TimeUnit ;
	TemperatureUnit ;
	AreaUnit ;
	VolumeUnit ;
	AngleUnit ;

fun
	meter, foot : LengthUnit ;
	cup_flour : MassUnit ;
	second, minute, hour : TimeUnit ;
	celsius : TemperatureUnit ;
	hectare : AreaUnit ;
	liter, cup : VolumeUnit ;
	radian, arcsecond, arcminute, degree : AngleUnit ;

}
