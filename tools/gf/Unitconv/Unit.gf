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
	kilo_meter, centi_meter, milli_meter, meter, foot : LengthUnit ;
	cup_flour : MassUnit ;
	second, minute, hour : TimeUnit ;
	milli_celsius, celsius : TemperatureUnit ;
	hectare, square_meter, square_kilo_meter : AreaUnit ;
	liter, cup, cubic_foot : VolumeUnit ;
	-- radian
	arcsecond, arcminute, degree : AngleUnit ;

}
