concrete UnitEst of Unit = PrefixEst ** open StringOper in {

-- This is a lexicon of the words of measurement units in Estonian.
-- In principle two forms of each word must be provided
-- (singular partitiv and plural inessiv), but using the mk-function
-- you can only provide the partitive form, the inessive will be
-- generated automatically. If the mk-function fails to generate the
-- correct inessive form then use the f-function to provide both forms
-- (or improve the mk-function to handle the new paradigm).

flags coding=utf8;

param Case = SgPart | PlIn ;

-- The f-function requires both forms (`SgPart` and `PlIn`)
-- The mk-function is smart and only requires the "base" form (`SgPart`)
oper
	CaseStr : Type = { s : Case => Str } ;

	prefix : Str -> CaseStr -> CaseStr = \x,y -> add_prefix x y;

	f : Str -> Str -> CaseStr = \x,y ->
		{ s = table { SgPart => x ; PlIn => y } };
	mk : Str -> CaseStr = \w -> 
		let 
			ws : Str = case w of {
				_ + ("a" | "e" | "i" | "o") => w + "des" ; -- jalga + des
				_                           => w + "es"    -- liitrit + es
			} 
		in f w ws;

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
		{ s = table { SgPart => p ++ (w.s ! SgPart) ; PlIn => p ++ (w.s ! PlIn) } };

lincat
	Length, LengthUnit,
	Mass, MassUnit,
	Time, TimeUnit,
	Temperature, TemperatureUnit,
	Currency, CurrencyUnit,
	AreaUnit, VolumeUnit, AngleUnit = CaseStr;

lin

length_unit, mass_unit, time_unit, temperature_unit, currency_unit = id CaseStr ;
prefixed_length_unit, prefixed_mass_unit, prefixed_time_unit, prefixed_temperature_unit = prefix ;

--Length
meter = mk "meetrit";
foot = mk "jalga";

--Mass
gram = mk "grammi";
cup_flour = f "tassi jahu" "jahu tassides";

--Time
second = mk "sekundit";
minute = mk "minutit";
hour = mk "tundi";

--Temperature
celsius = mk "kraadi";

--Area
hectare = mk "hektarit";
square_meter = mk "ruut meetrit";
square_kilo_meter = mk "ruut kilo meetrit";

--Volume
liter = mk "liitrit";
cubic_foot = mk "kuup jalga";
cup = mk "tassi";

--Angle
--radian = mk "radiaani";
arcsecond = mk "sekundit";
arcminute = mk "minutit";
degree = mk "kraadi";

-- Currency
usd = mk_currency_variants_3 "ameerika" "dollarit";
gbp = mk_currency_variants_3 "inglise" "naela";
jpy = mk_currency_variants_3 "jaapani" "jeeni";
eek = mk_currency_variants_3 "eesti" "krooni";

cad = mk_currency_variants_2 "kanada" "dollarit";
nzd = mk_currency_variants_2 "uus mere maa" "dollarit";
aud = mk_currency_variants_2 "austraalia" "dollarit";
nok = mk_currency_variants_2 "norra" "krooni";

-- This gradation does not seem to be very regular
-- e.g. meetrit -> *meetrides; dollarit -> *dollarides
-- TODO: what does it depend on?
eur = f "eurot" "eurodes";

chf = mk "franki";
-- TODO: use Unicode!
--chf = f "s~veitsi raha" "s~veitsi rahas";
}
