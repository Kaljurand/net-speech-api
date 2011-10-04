concrete UnitconvApp of Unitconv = FractionApp, UnitApp ** {

	oper
		c : { s : Str } -> { s : Str } -> { s : Str }
			= \x,y -> { s = x.s ++ "IN" ++ y.s };


	lincat Main, Conv = {s : Str} ;

	lin
		main num conv = {s = num.s ++ conv.s} ;

		length, mass, time, temperature, area, volume, angle, frequency,
		conv_speed, conv_acceleration,
		conv_energy, conv_power,
		currency = c ;
}
