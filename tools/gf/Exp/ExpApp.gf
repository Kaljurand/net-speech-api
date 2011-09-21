concrete ExpApp of Exp = decimal ** open StringOper in {

flags coding=utf8;

lincat Exp = {s : Str};

lin
	e_plus = infix "+";
	e_minus = infix "-";
	e_mult = infix "*";
	e_div = infix "/";

	numeral x = x;
}
