concrete AddressApp of Address = StreetFEst, decimal ** {

-- Using Estonian street names but "decimal" numerals.

flags coding=utf8;

lincat Address = Str;

lin
	address1 x = x ++ "," ++ "Tallinn";
	address2 x y = x ++ y.s ++ "," ++ "Tallinn";
}
