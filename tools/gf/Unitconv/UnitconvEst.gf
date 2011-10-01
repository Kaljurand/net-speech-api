concrete UnitconvEst of Unitconv = estonian, UnitEst ** {

	flags coding=utf8;

	oper
		c : { s : Case => Str } -> { s : Case => Str } -> { s : Str }
			= \x,y -> { s = x.s ! SgPart ++ y.s ! PlIn };

	lincat Main, Conv = {s : Str};

	lin
		main x y = { s = x.s ++ y.s };
		length, mass, time, temperature, area, volume, angle, frequency, conv_speed, currency = c ;

}
