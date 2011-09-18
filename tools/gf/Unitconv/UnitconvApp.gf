concrete UnitconvApp of Unitconv = decimal ** {

	lincat Main, Conv, Unit = {s : Str} ;

	lin
		main x y = {s = x.s ++ y.s} ;
		conv x y = {s = x.s ++ "in" ++ y.s} ;

		meter = { s = "m" } ;
		foot = { s = "f" } ;

}
