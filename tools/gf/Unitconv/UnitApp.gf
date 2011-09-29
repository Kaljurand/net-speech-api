concrete UnitApp of Unit = open StringOper in {

flags coding=utf8;

lincat
	LengthUnit, MassUnit, TimeUnit, TemperatureUnit,
	AreaUnit, VolumeUnit, AngleUnit = {s : Str};

lin

--Length
meter = ss "m" ;
kilo_meter = ss "km" ;
centi_meter = ss "cm" ;
milli_meter = ss "mm" ;
foot = ss "ft" ;

--Mass
cup_flour = ss "flour-cup" ;

--Time
second = ss "s" ;
minute = ss "min" ;
hour = ss "h" ;

--Temperature
celsius = ss "°C";
milli_celsius = ss "m°C";

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
