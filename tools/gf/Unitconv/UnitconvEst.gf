concrete UnitconvEst of Unitconv = estonian ** {

	flags coding=utf8;

	param Case = SgPart | PlIn ;

	oper
		ss : Str -> {s : Str} = \x -> {s = x} ;
		f : Str -> Str -> { s : Case => Str } = \x,y ->
			{ s = table { SgPart => x ; PlIn => y } };
		mk : Str -> { s : Case => Str } = \w -> 
			let 
				ws : Str = case w of {
					_ + ("a" | "e" | "i" | "o") => w + "des" ; -- jalga + des
					_                           => w + "es"    -- liitrit + es
				} 
			in f w ws;

	lincat Main, Conv = {s : Str};
	lincat LengthUnit, VolumeUnit = {s : Case => Str};

	lin
		main x y = { s = x.s ++ y.s };
		length x y = { s = x.s ! SgPart ++ y.s ! PlIn };
		volume x y = { s = x.s ! SgPart ++ y.s ! PlIn };

		-- The f-function requires both forms
		meter = f "meetrit" "meetrites";

		-- The mk-function is smart and only requires the "base" form
		foot = mk "jalga";
		liter = mk "liitrit";

}
