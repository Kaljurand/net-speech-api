concrete UnitconvEst of Unitconv = estonian ** {

	flags coding=utf8;

	param Case = SgPart | PlIn ;

	oper
		ss : Str -> {s : Str} = \x -> {s = x} ;
		f : Str -> Str -> { s : Case => Str } = \x,y -> { s = table { SgPart => x ; PlIn => y } };

	lincat Main, Conv = {s : Str};
	lincat LengthUnit, VolumeUnit = {s : Case => Str};

	lin
		main x y = { s = x.s ++ y.s };
		length x y = { s = x.s ! SgPart ++ y.s ! PlIn };
		volume x y = { s = x.s ! SgPart ++ y.s ! PlIn };

		meter = f "meetrit" "meetrites";
		foot = f "jalga" "jalgades";
		liter = f "liitrit" "liitrites";

}
