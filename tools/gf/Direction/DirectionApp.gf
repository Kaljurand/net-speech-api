concrete DirectionApp of Direction = AddressApp ** {

flags coding=utf8;

lincat Direction = Str;

lin
	direction x y = "FROM" ++ x ++ "TO" ++ y;
}
