concrete AddressEst of Address = StreetFEst, estonian ** {

flags coding=utf8;

lincat Address = Str;

lin
	address1 x = x ++ "Tallinn";
	address2 x y = x ++ y.s ++ "Tallinn";
}
