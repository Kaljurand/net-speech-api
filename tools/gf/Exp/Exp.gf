abstract Exp = Numerals ** {

flags startcat = Exp ;

cat
	Exp ;

fun
	e_plus, e_minus, e_mult, e_div : Exp -> Exp -> Exp;
	numeral : Numeral -> Exp;
}
