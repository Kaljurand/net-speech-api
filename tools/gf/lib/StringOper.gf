resource StringOper = {

-- Note. Some of these opers come from GF libraries Prelude and Formal,
-- i.e. one could take them directly from there.

-- Note: Predef (that provides Int and Ints) seems to be available
-- without having to point to it.

-- Note: the implementation of precedence is explained in the GF Tutorial
-- http://www.grammaticalframework.org/doc/tutorial/gf-tutorial.html

param
	Bool = True | False ;

oper

	-- Note that '4' is hard-coded in a few places below, therefore
	-- if you change highestPrec to something else then
	-- look for FIXME below for places than additionally need
	-- an update.
	highestPrec = 4 ;

	-- Numbers from 0 to highestPrec
	Prec : PType = Predef.Ints highestPrec ;
	-- Structure: string (e.g. "pluss") + precedence number (e.g. "3")
	TermPrec : Type = {s : Str ; p : Prec} ;


	SS : Type = {s : Str} ;

	ss : Str -> SS = \s -> {s = s} ;

	infixSS : Str -> SS -> SS -> SS
		= \f,x,y -> ss (x.s ++ f ++ y.s) ;

	infix : Str -> SS -> SS -> SS
		= \f,x,y -> ss (parenth (x.s ++ f ++ y.s)) ;

	mkPrec : Prec -> Str -> TermPrec = \p,s -> {s = s ; p = p} ;

	constant : Str -> TermPrec = mkPrec highestPrec ;

	infixl : Prec -> Str -> (_,_ : TermPrec) -> TermPrec = \p,f,x,y ->
		mkPrec p (usePrec p x ++ f ++ usePrec (nextPrec p) y) ;

	infixr : Prec -> Str -> (_,_ : TermPrec) -> TermPrec = \p,f,x,y ->
		mkPrec p (usePrec (nextPrec p) x ++ f ++ usePrec p y) ;

	parenth : Str -> Str = \s -> "(" ++ s ++ ")" ;
	parenthOpt : Str -> Str = \s -> variants {s ; "(" ++ s ++ ")"} ;

	usePrec : Prec -> TermPrec -> Str = \p,x ->
		case lessPrec x.p p of {
			True => parenth x.s ;
			False => x.s
		} ;

	-- FIXME: Assuming that highestPrec = 4
	lessPrec : Prec -> Prec -> Bool = \p,q ->
		case <<p,q> : Prec * Prec> of {
			<3,4> | <2,3> | <2,4> => True ;
			<1,1> | <1,0> | <0,0> => False ;
			<1,_> | <0,_>         => True ;
			_ => False
		} ;

	-- FIXME: Assuming that highestPrec = 4
	nextPrec : Prec -> Prec = \p -> case <p : Prec> of {
		4 => highestPrec ;
		n => Predef.plus n 1
	} ;

}
