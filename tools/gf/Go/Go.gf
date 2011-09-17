abstract Go = {

flags startcat = Go ;

cat
	Go ;
	Number ;
	Unit ;
	Direction ;

fun
	go : Number -> Unit -> Direction -> Go ;
	back, forward : Direction ;
	n1, n2, n3, n4, n5 : Number ;
	meter : Unit ;

}
