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
	fraction x y = infixSS "." x y;
	copy = id SS;
}
