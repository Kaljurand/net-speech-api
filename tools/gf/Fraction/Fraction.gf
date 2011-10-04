abstract Fraction = Numerals ** {

-- Fraction is an extension of Numeral which adds two functions
--
--   * null: to be linerazied as `0` or `null`
--   * fraction: combines two numerals (e.g. with a decimal point)
--
-- @author Kaarel Kaljurand
-- @version 2011-10-04

flags startcat = Fraction ;

cat Fraction;

fun
	null : Numeral;
	fraction : Numeral -> Numeral -> Fraction;
	copy : Numeral -> Fraction;
}
