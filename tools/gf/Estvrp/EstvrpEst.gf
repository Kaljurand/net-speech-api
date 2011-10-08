concrete EstvrpEst of Estvrp = DigitEst, LetterEst ** open StringOper in {

flags coding = utf8;

lincat Estvrp = SS;

lin
	estvrp d1 d2 d3 l1 l2 l3 = ss (d1 ++ d2 ++ d3 ++ l1 ++ l2 ++ l3);
}
