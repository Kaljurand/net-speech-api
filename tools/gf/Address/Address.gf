abstract Address = StreetF, Numerals ** {

flags startcat = Address;

cat Address;

fun
	address1 : Street -> Address;
	address2 : Street -> Numeral -> Address;

}
