concrete ExpApp of Exp = FractionApp ** open StringOper in {

flags coding=utf8;

lincat Exp = {s : Str};

lin
	e_plus = infix "+";
	e_minus = infix "-";
	e_mult = infix "*";
	e_div = infix "/";
	e_pow = infix "^";

	numeral x = x;
}
