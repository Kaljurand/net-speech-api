concrete UnitEst of Unit = PrefixEst, CurrencyEst ** open StringOper, Estonian in {

-- This is a lexicon of the words of measurement units in Estonian.
-- Some examples:
--   * meetrit
--   * kilo meetrit
--   * ruut meetrit
--   * ruut kilo meetrit
--   * meetrit sekundis
--   * kilo meetrit sekundis
--   * dollarit
--   * ameerika dollarit
--   * ameerika raha
--
-- In principle two forms of each word must be provided
-- (singular partitiv and plural inessiv), but using the mk-function
-- you can only provide the partitive form, the inessive will be
-- generated automatically. If the mk-function fails to generate the
-- correct inessive form then use the f-function to provide both forms
-- (or improve the mk-function to handle the new paradigm).
-- In some cases also the singular inessiv is required (e.g. "kilomeetrites *tunnis*").
-- The mk-function generates that as well (and the f3-function allows one to
-- override it), but in most cases this form is not used (and does not even end up in JSGF).
--
-- @author Kaarel Kaljurand
-- @version 2011-10-04

flags coding=utf8;

lincat
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
	AngleUnit = CaseStr;

lin

length_unit, mass_unit, time_unit, temperature_unit,
area_unit,
volume_unit,
frequency_unit,
speed_unit,
energy_unit,
power_unit = id CaseStr ;

prefixed_length_unit, prefixed_mass_unit,
prefixed_time_unit, prefixed_temperature_unit,
prefixed_area_unit,
prefixed_volume_unit,
prefixed_energy_unit,
prefixed_power_unit,
prefixed_frequency_unit = prefix ;

square = prefix "ruut";
cube = prefix "kuup";

speed = mk_meter_per_second "";
acceleration = mk_meter_per_second "ruut";

--Length
meter = mk "meetrit";
inch = mk "tolli";
foot = mk "jalga";
yard = mk "jardi";
mile = mk "miili";

--Mass
gram = mk "grammi";
ounce = mk "untsi";
pound = mk "naela";
ton = mk "tonni";
cup_flour = f "tassi jahu" "jahu tassides";

--Time
-- TODO: replace "asja"
second = mk "sekundit";
minute = mk "minutit";
hour = f3 "tundi" "tunnis" "tundides";
day = mk "päeva";
week = mk "asja";
month = mk "kuud";
year = mk "aastat";
decade = mk "asja";
century = mk "asja";

--Temperature
celsius = mk "kraadi";

--Area
hectare = mk "hektarit";

--Volume
liter = mk "liitrit";
pint = mk "pinti";
gallon = mk "gallonit";
cup = mk "tassi";

--Frequency
hertz = mk "hertsi";

the_speed_of_light = mk "valgus kiirust";
knot = mk "sõlme";

-- Energy
-- TODO: use Unicode!
joule = mk "dz~auli";
calorie = mk "kalorit";
watt_hour = mk "vatt tundi";

-- Power
watt = mk "vatti";

--Angle
radian = mk "radiaani";
arcsecond = mk "sekundit";
arcminute = mk "minutit";
degree = mk "kraadi";

}
