concrete UnitconvEst of Unitconv = estonian ** {

	flags coding=utf8;

	lincat Main, Unit = {s : Str};

	lin
		main x y z = {s = x.s ++ y.s ++ z.s};

		-- TODO: meetrites, jalgades
		meter = { s = "meetrit" };
		foot = { s = "jalga" };

}
