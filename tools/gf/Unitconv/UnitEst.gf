concrete UnitEst of Unit = {

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
	f : Str -> Str -> { s : Case => Str } = \x,y ->
		{ s = table { SgPart => x ; PlIn => y } };
	mk : Str -> { s : Case => Str } = \w -> 
		let 
			ws : Str = case w of {
				_ + ("a" | "e" | "i" | "o") => w + "des" ; -- jalga + des
				_                           => w + "es"    -- liitrit + es
			} 
		in f w ws;

lincat
	LengthUnit, MassUnit, TimeUnit, TemperatureUnit,
	AreaUnit, VolumeUnit, AngleUnit = {s : Case => Str};

lin

--Length
meter = mk "meetrit";
foot = mk "jalga";

--Mass
cup_flour = f "tassi jahu" "jahu tassides";

--Time
second = mk "sekundit";
minute = mk "minutit";
hour = mk "tundi";

--Temperature
celsius = mk "kraadi";

--Area
hectare = mk "hektarit";

--Volume
liter = mk "liitrit";
cup = mk "tassi";

--Angle
radian = mk "radiaani";
arcsecond = mk "sekundit";
arcminute = mk "minutit";
degree = mk "kraadi";
}
