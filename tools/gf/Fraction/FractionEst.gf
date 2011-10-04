--# -path=lib:Numerals

concrete FractionEst of Fraction = estonian ** open StringOper in {

flags coding = utf8;

lincat Fraction = SS;

lin
	null = ss "null";
	fraction x y = infixSS "koma" x y;
	copy = id SS;
}
