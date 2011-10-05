--# -path=Numerals

abstract Fraction = Numerals ** {

-- Fraction is an extension of Numeral which adds a function
-- for combining two numerals (e.g. with a decimal point).
-- It also adds a few numerals (null, half, pi, ...).
--
-- @author Kaarel Kaljurand
-- @version 2011-10-05

flags startcat = Fraction ;

cat Fraction;

fun
	null : Numeral;
	quarter : Fraction;
	half : Fraction;
	three_quarters : Fraction;
	one_and_half : Fraction;
	pi : Fraction;
	fraction : Numeral -> Numeral -> Fraction;
	copy : Numeral -> Fraction;
}
