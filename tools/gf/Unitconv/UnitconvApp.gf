concrete UnitconvApp of Unitconv = decimal ** {

	lincat Main, Conv, LengthUnit, VolumeUnit = {s : Str} ;

	lin
		main x y = {s = x.s ++ y.s} ;

		-- TODO: share code
		length x y = {s = x.s ++ "in" ++ y.s} ;
		volume x y = {s = x.s ++ "in" ++ y.s} ;

		meter = { s = "m" } ;
		foot = { s = "f" } ;
		liter = { s = "l" } ;

}
