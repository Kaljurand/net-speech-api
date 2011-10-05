concrete UnitconvEst of Unitconv = FractionEst, UnitEst ** open Estonian in {

	flags coding=utf8;

	oper
		c : { s : Case => Str } -> { s : Case => Str } -> { s : Str }
			= \x,y -> { s = x.s ! SgPart ++ y.s ! PlIn };

	lincat Main, Conv = {s : Str};

	lin
		main num conv = { s = num.s ++ conv.s } ;
		length, mass, time, temperature, area, volume, angle, frequency,
		conv_speed, conv_acceleration,
		conv_energy, conv_power, currency = c ;

}
