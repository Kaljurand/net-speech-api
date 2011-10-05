--# -path=lib:Numerals

concrete FractionApp of Fraction = decimal ** open StringOper in {

-- The simple combination by placing a dot between two numberals has the
-- following consequences for the lexical space:
--
--   * allowed: "1 . 200"
--   * not allowed: "1 . 002"
--
-- @author Kaarel Kaljurand
-- @version 2011-10-04


flags coding = utf8;

lincat Fraction = SS;

lin
	null = ss "0";
	quarter = ss "0 . 2 5";
	half = ss "0 . 5";
	three_quarters = ss "0 . 7 5";
	one_and_half = ss "1 . 5";
	-- TODO: we could represent Pi also with the symbol π
	-- in order to be more accurate.
	pi = ss "3 . 1 4 1 5 9 2 6 5";
	fraction x y = infixSS "." x y;
	copy = id SS;
}
