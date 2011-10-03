concrete UnitApp of Unit = PrefixApp ** open StringOper in {

flags coding=utf8;

oper

	simple_product : Str -> SS -> SS -> SS
        = \n1,x,y -> ss (x.s ++ "*" ++ y.s ++ "**" ++ n1) ;

	product : Str -> Str -> SS -> SS -> SS
        = \n1,n2,x,y -> ss (x.s ++ "**" ++ n1 ++ "*" ++ y.s ++ "**" ++ n2) ;


lincat
	-- TODO: why do we use SS and not Str?
	Length, LengthUnit,
	Mass, MassUnit,
	Time, TimeUnit,
	Temperature, TemperatureUnit,
	Area, AreaUnit,
	Volume, VolumeUnit,
	Frequency, FrequencyUnit,
	Speed, SpeedUnit,
	AccelerationUnit,
	Energy, EnergyUnit,
	Power, PowerUnit,
	Currency, CurrencyUnit,
	AngleUnit = SS;

lin

length_unit, mass_unit, time_unit, temperature_unit,
area_unit,
volume_unit,
frequency_unit,
speed_unit,
energy_unit,
power_unit,
currency_unit = id SS;

prefixed_length_unit, prefixed_mass_unit, prefixed_time_unit,
prefixed_temperature_unit,
prefixed_area_unit, prefixed_volume_unit,
prefixed_energy_unit,
prefixed_power_unit,
prefixed_frequency_unit = prefixSS ;

square = postfixSS "**2";
cube = postfixSS "**3";

speed = infixSS "/";
-- m*s-2, m/s², m·s-², m*s**-2
--acceleration = product "1" "-2";
acceleration = simple_product "-2";

--Length
meter = ss "m";
foot = ss "ft";
mile = ss "mile";
inch = ss "in";
yard = ss "yard";

--Mass
gram = ss "g";
ounce = ss "oz";
pound = ss "lb";
ton = ss "t";
cup_flour = ss "flour-cup";

--Time
second = ss "s";
minute = ss "min";
hour = ss "h";
day = ss "day";
week = ss "week";
month = ss "month";
year = ss "year";
decade = ss "decade";
century = ss "century";


--Temperature
celsius = ss "°C";

--Area
hectare = ss "ha";

--Volume
liter = ss "L";
pint = ss "pint";
gallon = ss "gal";
cup = ss "cup_us";

--Frequency
hertz = ss "Hz";

--Speed
the_speed_of_light = ss "c";
knot = ss "knot";

-- Energy
joule = ss "J";
calorie = ss "cal";
-- watt_hour = infixSS "⋅" watt hour;
watt_hour = infixSS "" watt hour;

-- Power
watt = ss "W";

--Angle
radian = ss "rad";
arcsecond = ss "''";
arcminute = ss "'";
degree = ss "°";

--Currency
usd = ss "USD";
cad = ss "CAD";
nzd = ss "NZD";
aud = ss "AUD";
eur = ss "EUR";
gbp = ss "GBP";
chf = ss "CHF";
nok = ss "NOK";
jpy = ss "JPY";
eek = ss "EEK";
rub = ss "RUB";
sek = ss "SEK";
dkk = ss "DKK";
isk = ss "ISK";

}
