concrete UnitApp of Unit = open StringOper in {

lincat
	LengthUnit, MassUnit, TimeUnit, TemperatureUnit,
	AreaUnit, VolumeUnit, AngleUnit = {s : Str};

lin

--Length
meter = ss "m" ;
foot = ss "f" ;

--Mass
cup_flour = ss "flour-cup" ;

--Time
second = ss "s" ;
minute = ss "m" ;
hour = ss "h" ;

--Temperature
celsius = ss "C";

--Area
hectare = ss "ha";

--Volume
liter = ss "l" ;
cup = ss "cup" ;

--Angle
radian = ss "rad";
arcsecond = ss "\"";
arcminute = ss "'";
degree = ss "deg";

}
