concrete UnitApp of Unit = PrefixApp ** open StringOper in {

flags coding=utf8;

lincat
	-- TODO: why do we use { s : Str } and not Str?
	Length, LengthUnit,
	Mass, MassUnit,
	Time, TimeUnit,
	Temperature, TemperatureUnit,
	Area, AreaUnit,
	Volume, VolumeUnit,
	Frequency, FrequencyUnit,
	Currency, CurrencyUnit,
	AngleUnit = {s : Str};

lin

length_unit, mass_unit, time_unit, temperature_unit,
area_unit,
volume_unit,
frequency_unit, currency_unit = id SS;

prefixed_length_unit, prefixed_mass_unit, prefixed_time_unit,
prefixed_temperature_unit,
prefixed_area_unit, prefixed_volume_unit,
prefixed_frequency_unit = prefixSS ;

square = postfixSS "**2";
cube = postfixSS "**3";


--Length
meter = ss "m";
foot = ss "ft";
mile = ss "mile";

--Mass
gram = ss "g";
pound = ss "lb";
ton = ss "t";
cup_flour = ss "flour-cup";

--Time
second = ss "s";
minute = ss "min";
hour = ss "h";

--Temperature
celsius = ss "°C";

--Area
hectare = ss "ha";

--Volume
liter = ss "L";
cup = ss "cup_us";

hertz = ss "Hz";

--Angle
--radian = ss "rad";
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

}
