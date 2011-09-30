abstract Unit = Prefix ** {

-- Here one must register all the measurement units and their types.

cat
	Length ; LengthUnit ;
	Mass ; MassUnit ;
	Time ; TimeUnit ;
	Temperature ; TemperatureUnit ;
	AreaUnit ;
	VolumeUnit ;
	AngleUnit ;

fun
	prefixed_length_unit : Prefix -> Length -> LengthUnit ;
	prefixed_mass_unit : Prefix -> Mass -> MassUnit ;
	prefixed_time_unit : Prefix -> Time -> TimeUnit ;
	prefixed_temperature_unit : Prefix -> Temperature -> TemperatureUnit ;

	-- TODO: maybe not use these rules and allow an empty prefix instead
	length_unit : Length -> LengthUnit ;
	mass_unit : Mass -> MassUnit ;
	time_unit : Time -> TimeUnit ;
	temperature_unit : Temperature -> TemperatureUnit ;

	meter, foot : Length ;
	gram, cup_flour : Mass ;
	second, minute, hour : Time ;
	celsius : Temperature;

	hectare, square_meter, square_kilo_meter : AreaUnit ;
	liter, cup, cubic_foot : VolumeUnit ;
	-- radian
	arcsecond, arcminute, degree : AngleUnit ;

}
