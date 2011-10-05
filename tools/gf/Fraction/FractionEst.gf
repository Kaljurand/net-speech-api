--# -path=lib:Numerals

concrete FractionEst of Fraction = estonian ** open StringOper in {

flags coding = utf8;

lincat Fraction = SS;

lin
	null = ss "null";
	quarter = ss "veerand";
	half = ss "pool";
	three_quarters = ss "kolm veerand";
	one_and_half = ss "pool teist";
	pi = ss "Pii";
	fraction x y = infixSS "koma" x y;
	copy = id SS;
}
