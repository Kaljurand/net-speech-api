concrete ExpEstl of Exp = estonian ** open StringOper in {

-- Unambiguous Estonian arithmetical expression grammar which implements the
-- left-associative semantics, where the precedence of operators is the following:
--
--   * highest: numbers (note: the highest is defined in `StringOper`)
--   * 0: plus, minus, mult, div, pow (note: all are equal)
--
-- Such semantics seems appropriate for speech applications,
-- because speech happens one token at a time and one has no means
-- to express bracketing, i.e. one shouldn't give higher precedence to
-- operators that come later.
-- If you are unhappy with this semantics then it is easy to change.
--
-- Example: the sentence
--
--     kaks pluss kolm astmel neli korda viis
--
-- is parsed into (a single tree):
--
--     ((n2 + (n3 ^ n4)) * n5)
--
-- @author Kaarel Kaljurand
-- @version 2011-10-03

flags coding=utf8;

lincat Exp = TermPrec;

lin
	e_plus = infixl 0 "pluss";
	e_minus = infixl 0 "miinus";
	e_mult = infixl 0 "korda";
	e_div = infixl 0 "jagatud";

	e_pow = infixl 0 "astmel";

	-- Making "pow" right-assoc and of higher precedence
	--e_pow = infixr 2 "astmel";

	numeral x = constant x.s ;
}
