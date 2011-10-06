abstract Address = Town, StreetF, Numerals ** {

-- TODO: exclude numbers larger than 1000
-- because these don't occur
-- as part of Estonian street addresses.

flags startcat = Address;

cat Address;

fun
	address1 : Street -> Town -> Address;
	address2 : Street -> Numeral -> Town -> Address;

}
