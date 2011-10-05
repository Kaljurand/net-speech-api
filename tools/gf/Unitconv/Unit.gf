abstract Unit = Prefix, Currency ** {

-- This is a registry of the measurement units and their quantities.
-- Wikpedia: "Length is a physical quantity. Metre is a unit of length that
-- represents a definite predetermined length."

-- @author Kaarel Kaljurand
-- @version 2011-10-04

cat
	Length ; LengthUnit ;
	Mass ; MassUnit ;
	Time ; TimeUnit ;
	Temperature ; TemperatureUnit ;
	Area ; AreaUnit ;
	Volume ; VolumeUnit ;
	Frequency ; FrequencyUnit ;
	Speed ; SpeedUnit ;
	AccelerationUnit ;
	Energy ; EnergyUnit ;
	Power ; PowerUnit ;
	AngleUnit ;

fun
	-- Some simple units can be SI-prefixed to make a prefixed unit
	-- e.g. "meter" can be turned into "kilometer"
	-- Some quantities can not have prefixed units, e.g. speed and currency
	-- TODO: maybe require that the 2nd argument is a SI unit
	prefixed_length_unit : Prefix -> Length -> LengthUnit ;
	prefixed_mass_unit : Prefix -> Mass -> MassUnit ;
	-- TODO: maybe not prefix time (*kilo year)
	prefixed_time_unit : Prefix -> Time -> TimeUnit ;
	prefixed_temperature_unit : Prefix -> Temperature -> TemperatureUnit ;
	prefixed_area_unit : Prefix -> Area -> AreaUnit ;
	prefixed_volume_unit : Prefix -> Volume -> VolumeUnit ;
	prefixed_frequency_unit : Prefix -> Frequency -> FrequencyUnit ;
	prefixed_energy_unit : Prefix -> Energy -> EnergyUnit ;
	prefixed_power_unit : Prefix -> Power -> PowerUnit ;

	-- TODO: maybe not use these rules and allow an empty prefix instead
	-- But note that here we have also units that cannot be prefixed, e.g.
	-- the currencies.
	length_unit : Length -> LengthUnit ;
	mass_unit : Mass -> MassUnit ;
	time_unit : Time -> TimeUnit ;
	temperature_unit : Temperature -> TemperatureUnit ;
	area_unit : Area -> AreaUnit ;
	volume_unit : Volume -> VolumeUnit ;
	frequency_unit : Frequency -> FrequencyUnit ;
	energy_unit : Energy -> EnergyUnit ;
	power_unit : Power -> PowerUnit ;
	speed_unit : Speed -> SpeedUnit ;

	-- Length (possibly prefixed) can be turned into
	-- Area (by square) or Volume (by cube), e.g.
	-- m**2, cm**3
	square : LengthUnit -> AreaUnit ;
	cube : LengthUnit -> VolumeUnit ;

	-- Speed and Acceleration are expressed by combining Length and Time, e.g.
	-- km / h, km*m**-2
	speed : LengthUnit -> TimeUnit -> SpeedUnit ;
	acceleration : LengthUnit -> TimeUnit -> AccelerationUnit ;

	-- Simple units

	meter, foot, inch, yard, mile : Length ;
	gram, ounce, pound, ton, cup_flour : Mass ;
	second, minute, hour, day, week, month, year, decade, century : Time ;
	celsius : Temperature;

	-- Only the Area units which are not constructed from a length unit,
	-- i.e. we have `hectare` here but not `square meter`.
	hectare : Area ;

	-- Only the Volume units which are not constructed from Length (e.g. cm^3)
	liter, gallon, pint, cup : Volume ;

	hertz : Frequency ;

	-- TODO: maybe generalize: watt_hour
	joule, calorie, watt_hour : Energy ;

	watt : Power ;

	the_speed_of_light, knot : Speed ;

	radian, arcsecond, arcminute, degree : AngleUnit ;
}
