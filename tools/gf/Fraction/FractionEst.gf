--# -path=lib:Numerals

concrete FractionEst of Fraction = estonian ** open StringOper in {

flags coding = utf8;

lincat Fraction, FractionBase, NumeralPair = SS;

lin
	null = ss "null";
	quarter = ss "veerand";
	half = ss "pool";
	three_quarters = ss "kolm veerand";
	one_and_half = ss "pool teist";
	pi = ss "Pii";
	pair x y = infixSS "koma" x y;
	neg1 x = prefixSS "miinus" x;
	neg2 x = prefixSS "miinus" x;
	copy1, copy2 = id SS;
	fraction = id SS;
}
