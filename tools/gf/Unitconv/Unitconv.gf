abstract Unitconv = Numerals ** {

flags startcat = Main ;

cat
	Main ;
	Conv ;
	Unit ;

fun
	main : Numeral -> Conv -> Main ;
	conv : Unit -> Unit -> Conv ;
	meter, foot : Unit ;
	--liter : Unit ;

}
