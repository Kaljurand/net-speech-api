concrete GoEng of Go = {

	lincat Go, Number, Unit, Direction = {s : Str} ;

	lin
		go x y z = {s = "go" ++ x.s ++ y.s ++ z.s} ;

		back = { s = "back" } ;
		forward = { s = "forward" } ;

		n1 = { s = "one" } ;
		n2 = { s = "two" } ;
		n3 = { s = "three" } ;
		n4 = { s = "four" } ;
		n5 = { s = "five" } ;

		meter = { s = "meters" } ;

}
