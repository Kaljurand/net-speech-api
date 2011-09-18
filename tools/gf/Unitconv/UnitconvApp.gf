concrete UnitconvApp of Unitconv = decimal ** {

	lincat Main, Unit = {s : Str} ;

	lin
		main x y z = {s = x.s ++ y.s ++ "in" ++ z.s} ;

		meter = { s = "m" } ;
		foot = { s = "f" } ;

}
