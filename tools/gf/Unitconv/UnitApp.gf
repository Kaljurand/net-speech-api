concrete UnitApp of Unit = PrefixApp ** open StringOper in {

flags coding=utf8;

oper
	prefix : Str -> {s : Str} -> {s : Str} = \x,y -> ss (x ++ y.s);

lincat
	-- TODO: why do we use { s : Str } and not Str?
	Length, LengthUnit,
	Mass, MassUnit,
	Time, TimeUnit,
	Temperature, TemperatureUnit,
	AreaUnit, VolumeUnit, AngleUnit = {s : Str};

lin

length_unit, mass_unit, time_unit, temperature_unit = id {s : Str};
prefixed_length_unit, prefixed_mass_unit, prefixed_time_unit, prefixed_temperature_unit = prefix ;


--Length
meter = ss "m" ;
foot = ss "ft" ;

--Mass
gram = ss "g" ;
cup_flour = ss "flour-cup" ;

--Time
second = ss "s" ;
minute = ss "min" ;
hour = ss "h" ;

--Temperature
celsius = ss "°C";

--Area
hectare = ss "ha";
square_meter = ss "m**2";
square_kilo_meter = ss "km**2";

--Volume
liter = ss "l" ;
cup = ss "cup_us" ;
cubic_foot = ss "cft_i" ;

--Angle
--radian = ss "rad";
arcsecond = ss "''";
arcminute = ss "'";
degree = ss "deg";

}
