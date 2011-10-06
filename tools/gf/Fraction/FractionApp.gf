--# -path=lib:Numerals

concrete FractionApp of Fraction = decimal ** open StringOper in {

-- The simple combination by placing a dot between two numberals has the
-- following consequences for the lexical space:
--
--   * allowed: "1 . 200"
--   * not allowed: "1 . 002"
--
-- @author Kaarel Kaljurand
-- @version 2011-10-06


flags coding = utf8;

lincat Fraction, FractionBase, NumeralPair = SS;

lin
	null = ss "0";
	quarter = ss "0 . 2 5";
	half = ss "0 . 5";
	three_quarters = ss "0 . 7 5";
	one_and_half = ss "1 . 5";
	pi = ss "PI";
	pair x y = infixSS "." x y;
	neg1 x = prefixSS "-" x;
	neg2 x = prefixSS "-" x;
	copy1, copy2, fraction = id SS;
}
