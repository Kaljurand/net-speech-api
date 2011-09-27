abstract Unitconv = Numerals, Unit ** {

flags startcat = Main ;

cat
	Main ;
	Conv ;

fun
	-- Quantified unit conversion
	main : Numeral -> Conv -> Main ;

	-- Type-aware unit conversion
	-- TODO: use dependent types

	-- SI base units
	length : LengthUnit -> LengthUnit -> Conv ;
	mass : MassUnit -> MassUnit -> Conv ;
	time : TimeUnit -> TimeUnit -> Conv ;
	-- electric_current
	temperature: TemperatureUnit -> TemperatureUnit -> Conv ;
	-- amount of substance
	-- luminous intensity

	-- SI derived units
	area : AreaUnit -> AreaUnit -> Conv ;
	volume : VolumeUnit -> VolumeUnit -> Conv ;
	angle : AngleUnit -> AngleUnit -> Conv ;

}
