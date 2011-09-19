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
	length : LengthUnit -> LengthUnit -> Conv ;
	volume : VolumeUnit -> VolumeUnit -> Conv ;
	weight : WeightUnit -> WeightUnit -> Conv ;
	time : TimeUnit -> TimeUnit -> Conv ;

}
