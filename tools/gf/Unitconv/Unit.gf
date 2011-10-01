abstract Unit = Prefix ** {

-- Here one must register all the measurement units and their types.

cat
	Length ; LengthUnit ;
	Mass ; MassUnit ;
	Time ; TimeUnit ;
	Temperature ; TemperatureUnit ;
	Area ; AreaUnit ;
	Volume ; VolumeUnit ;
	Frequency ; FrequencyUnit ;
	AngleUnit ;
	Currency ; CurrencyUnit ;

fun
	-- Some simple units can be SI-prefixed to make a prefixed unit
	-- e.g. "meter" can be turned into "kilometer"
	-- TODO: maybe require that the 2nd argument is a SI unit
	prefixed_length_unit : Prefix -> Length -> LengthUnit ;
	prefixed_mass_unit : Prefix -> Mass -> MassUnit ;
	prefixed_time_unit : Prefix -> Time -> TimeUnit ;
	prefixed_temperature_unit : Prefix -> Temperature -> TemperatureUnit ;
	prefixed_area_unit : Prefix -> Area -> AreaUnit ;
	prefixed_volume_unit : Prefix -> Volume -> VolumeUnit ;
	prefixed_frequency_unit : Prefix -> Frequency -> FrequencyUnit ;

	-- TODO: maybe not use these rules and allow an empty prefix instead
	-- But note that here we have also units that cannot be prefixed, e.g.
	-- the currencies.
	length_unit : Length -> LengthUnit ;
	mass_unit : Mass -> MassUnit ;
	time_unit : Time -> TimeUnit ;
	temperature_unit : Temperature -> TemperatureUnit ;
	area_unit : Area -> AreaUnit ;
	volume_unit : Volume -> VolumeUnit ;
	frequency_unit : Frequency -> FrequencyUnit ;
	currency_unit : Currency -> CurrencyUnit ;

	-- The Length-unit (possibly prefixed) can be turned into
	-- an Area-unit (square) or VolumeUnit (cube).
	square : LengthUnit -> AreaUnit ;
	cube : LengthUnit -> VolumeUnit ;

	-- Simple units

	-- TODO: inch, yard
	meter, foot, mile : Length ;
	-- TODO: ounce
	gram, pound, ton, cup_flour : Mass ;
	second, minute, hour : Time ;
	celsius : Temperature;

	-- Only units which cannot be constructed from a length unit,
	-- i.e. we have `hectare` here but not `square meter`.
	hectare : Area ;
	-- TODO: gallon, pint
	liter, cup : Volume ;

	hertz : Frequency ;

	-- radian
	arcsecond, arcminute, degree : AngleUnit ;

	usd, cad, gbp, aud, nzd, eur, chf, jpy, nok : Currency ;
	eek : Currency ;

}
