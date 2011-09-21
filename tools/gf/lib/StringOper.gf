resource StringOper = {

-- Note. Some of these opers come from GF Prelude,
-- i.e. one could take them directly from there.

oper
	SS : Type = {s : Str} ;
	ss : Str -> SS = \s -> {s = s} ;
	infixSS : Str -> SS -> SS -> SS
		= \f,x,y -> ss (x.s ++ f ++ y.s) ;
	infix : Str -> SS -> SS -> SS
		= \f,x,y -> ss ("(" ++ x.s ++ f ++ y.s ++ ")") ;

}
