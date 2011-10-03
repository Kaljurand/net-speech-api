abstract Calc = Exp, Unitconv ** {

-- Calc is a union of Exp and Unitconv.
--
-- @author Kaarel Kaljurand
-- @version 2011-10-03

flags startcat = Calc;

cat Calc;

fun
	exp : Exp -> Calc;
	unitconv : Main -> Calc;
}
