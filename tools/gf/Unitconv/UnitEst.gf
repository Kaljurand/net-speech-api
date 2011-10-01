concrete UnitEst of Unit = PrefixEst ** open StringOper in {

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
-- @version 2011-10-01

flags coding=utf8;

param Case = SgPart | SgIn | PlIn ;

-- The f-function requires both forms (`SgPart` and `PlIn`)
-- The mk-function is smart and only requires the "base" form (`SgPart`)
oper
	CaseStr : Type = { s : Case => Str } ;

	prefix : Str -> CaseStr -> CaseStr = \x,y -> add_prefix x y;

	f3 : Str -> Str -> Str -> CaseStr = \sg1,sg2,pl1 ->
		{
			s = table {
				SgPart => sg1 ;
				SgIn => sg2 ;
				PlIn => pl1
			}
	};

	f : Str -> Str -> CaseStr = \x,y ->
		{
			s = table {
				SgPart => x ;
				PlIn => y ;
				_ => "NOT_IMPLEMENTED"
			}
	};

	mk : Str -> CaseStr = \sg_part -> 
		let 
			pl_in : Str = case sg_part of {
				_ + ("a" | "e" | "i" | "o") => sg_part + "des" ; -- jalga + des
				_                           => sg_part + "es"    -- liitrit + es
			} ;
			sg_in : Str = case sg_part of {
				base + ("t")                => base + "s" ; -- sekundit -> sekundis
				_                           => sg_part + "s" -- raha + s
			} 
		in f3 sg_part sg_in pl_in;

	mk_raha : Str -> CaseStr = \x ->
		f (x ++ "raha") (x ++ "rahas") ;

	-- Generates 3 variants, from two input strings, e.g.:
	-- Input: "ameerika", "dollarit"
	-- Output:
	-- dollarit/dollarites
	-- ameerika dollarit / ameerika dollarites
	-- ameerika raha / ameerika rahas
	mk_currency_variants_3 : Str -> Str -> CaseStr = \x,y ->
		variants { mk y ; mk (x ++ y); mk_raha x };

	mk_currency_variants_2 : Str -> Str -> CaseStr = \x,y ->
		variants { mk (x ++ y); mk_raha x };

	-- Places a prefix (`kilo`) in front of the given unit word (`meeter`).
	-- TODO: Maybe we should return a more complex structure with a field
	-- for the prefix, instead of doing string concatenation here.
	add_prefix : Str -> CaseStr -> CaseStr = \p,w ->
		{
			s = table {
				SgPart => p ++ (w.s ! SgPart) ;
				SgIn => p ++ (w.s ! SgIn) ;
				PlIn => p ++ (w.s ! PlIn)
			}
	};

	-- Note that the compound expressions do not have the SgIn-form
	-- so we will not implement it:
	-- SgPart: (kolm) meetrit sekundis
	-- PlIn: meetrites sekundis
	-- SgIn: * meetris sekundis
	-- Note the first argument is used to provide "ruut" in case of
	-- "meetrit ruut sekundis".
	mk_meter_per_second : Str -> CaseStr -> CaseStr -> CaseStr = \p,x,y ->
		{
			s = table {
				SgPart => (x.s ! SgPart) ++ p ++ (y.s ! SgIn) ;
				PlIn => (x.s ! PlIn) ++ p ++ (y.s ! SgIn) ;
				_ => "NOT_NEEDED"
			}
		};

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
	Currency, CurrencyUnit,
	AngleUnit = CaseStr;

lin

length_unit, mass_unit, time_unit, temperature_unit,
area_unit,
volume_unit,
frequency_unit,
speed_unit,
energy_unit,
power_unit,
currency_unit = id CaseStr ;

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
--inch = mk "tolli";
foot = mk "jalga";
--yard = mk "jardi";
mile = mk "miili";

--Mass
gram = mk "grammi";
--ounce = mk "untsi";
pound = mk "naela";
ton = mk "tonni";
cup_flour = f "tassi jahu" "jahu tassides";

--Time
second = mk "sekundit";
minute = mk "minutit";
hour = f3 "tundi" "tunnis" "tundides";

--Temperature
celsius = mk "kraadi";

--Area
hectare = mk "hektarit";

--Volume
liter = mk "liitrit";
--pint = mk "pinti";
--gallon = mk "gallonit";
cup = mk "tassi";

--Frequency
-- TODO: fix PlIn form once the server supports it
hertz = f "hertsi" "hertsi";

-- TODO: temporary hack (using f) because 'kiirustes' is not in dict
the_speed_of_light = f "valgus kiirust" "valgus kiirustest";
knot = mk "sõlme";

-- Energy
-- TODO: fix bugs
joule = mk "viga";
calorie = mk "viga";
watt_hour = mk "vatt tundi";

-- Power
-- TODO: fix bugs
watt = mk "viga";

--Angle
--radian = mk "radiaani";
arcsecond = mk "sekundit";
arcminute = mk "minutit";
degree = mk "kraadi";

-- Currency
usd = mk_currency_variants_3 "ameerika" "dollarit";
gbp = mk_currency_variants_3 "inglise" "naela";
jpy = mk_currency_variants_3 "jaapani" "jeeni";
rub = mk_currency_variants_3 "vene" "rubla";

cad = mk_currency_variants_2 "kanada" "dollarit";
nzd = mk_currency_variants_2 "uus mere maa" "dollarit";
aud = mk_currency_variants_2 "austraalia" "dollarit";
nok = mk_currency_variants_2 "norra" "krooni";
sek = mk_currency_variants_2 "rootsi" "krooni";
dkk = mk_currency_variants_2 "taani" "krooni";
isk = mk_currency_variants_2 "islandi" "krooni";

-- This gradation does not seem to be very regular
-- e.g. meetrit -> *meetrides; dollarit -> *dollarides
-- TODO: what does it depend on?
eur = f "eurot" "eurodes";

-- TODO: use Unicode!
chf = mk_currency_variants_3 "s~veitsi" "franki";

eek = variants {
		mk "krooni" ;
		mk "eesti krooni";
		mk_raha "eesti";
		f "vana raha" "vanas rahas"
	};
}
