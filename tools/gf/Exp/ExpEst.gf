concrete ExpEst of Exp = estonian ** open StringOper in {

flags coding=utf8;

lincat Exp = {s : Str};

lin
	e_plus = infixSS "pluss";
	e_minus = infixSS "miinus";
	e_mult = infixSS "korda";
	e_div = infixSS "jagatud";

	numeral x = x;
}
