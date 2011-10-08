concrete DirectionApp of Direction = AddressApp ** open StringOper in {

flags coding=utf8;

lincat Direction = SS;

lin
	direction_id = id SS;
	direction x y = ss ("FROM" ++ x.s ++ "TO" ++ y.s);
}
