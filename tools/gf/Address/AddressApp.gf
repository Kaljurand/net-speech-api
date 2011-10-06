concrete AddressApp of Address = TownApp, StreetFEst, decimal ** open StringOper in {

-- Using Estonian town and street names but "decimal" numerals.

flags coding=utf8;

lincat Address = SS;

lin
	address1 x y = ss (x ++ "," ++ y);
	address2 x y z = ss (x ++ y.s ++ "," ++ z);
}
