abstract Unitconv = Numerals ** {

flags startcat = Main ;

cat
	Main ;
	Conv ;
	LengthUnit ;
	VolumeUnit ;

fun
	-- Quantified unit conversion
	main : Numeral -> Conv -> Main ;

	-- Unit types
	meter, foot : LengthUnit ;
	liter : VolumeUnit ;

	-- Type-aware unit conversion
	-- TODO: use dependent types
	length : LengthUnit -> LengthUnit -> Conv ;
	volume : VolumeUnit -> VolumeUnit -> Conv ;

}
