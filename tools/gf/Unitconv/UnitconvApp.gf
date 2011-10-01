concrete UnitconvApp of Unitconv = decimal, UnitApp ** {

	oper
		c : { s : Str } -> { s : Str } -> { s : Str }
			= \x,y -> { s = x.s ++ "in" ++ y.s };


	lincat Main, Conv = {s : Str} ;

	lin
		main x y = {s = x.s ++ y.s} ;

		length, mass, time, temperature, area, volume, angle, frequency,
		conv_speed, conv_acceleration, currency = c ;
}
