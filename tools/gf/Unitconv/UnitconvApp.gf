concrete UnitconvApp of Unitconv = decimal, UnitApp ** {

	oper
		c : { s : Str } -> { s : Str } -> { s : Str }
			= \x,y -> { s = x.s ++ "in" ++ y.s };


	lincat Main, Conv = {s : Str} ;

	lin
		main x y = {s = x.s ++ y.s} ;

		length = c ;
		volume = c ;
		weight = c ;
		time = c ;

}
