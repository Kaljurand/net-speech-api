--# -path=Numerals

abstract Fraction = Numerals ** {

-- Fraction is an extension of Numeral which adds a function
-- for combining two numerals (e.g. with a decimal point).
-- It also adds a few numerals (null, half, pi, ...).
--
-- @author Kaarel Kaljurand
-- @version 2011-10-06

flags startcat = Fraction ;

cat Fraction; FractionBase; NumeralPair;

fun
	null : Numeral;
	pair : Numeral -> Numeral -> NumeralPair;

	copy1 : Numeral -> FractionBase;
	copy2 : NumeralPair -> FractionBase;

	neg1 : Numeral -> FractionBase;
	neg2 : NumeralPair -> FractionBase;

	-- One cannot apply 'minus' to the result of 'quarter', e.g.
	-- "miinus veerand" is not possible, but one can of course say
	-- "miinus null koma viis".
	quarter : FractionBase;
	half : FractionBase;
	three_quarters : FractionBase;
	one_and_half : FractionBase;
	pi : FractionBase;

	-- There should be only one top node of the syntax tree.
	fraction : FractionBase -> Fraction;
}
