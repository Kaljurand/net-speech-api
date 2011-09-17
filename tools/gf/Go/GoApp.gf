concrete GoApp of Go = {

	lincat Go, Number, Unit, Direction = {s : Str} ;

	lin
		go x y z = {s = x.s ++ y.s ++ z.s} ;

		back = { s = "<" } ;
		forward = { s = ">" } ;

		n1 = { s = "1" } ;
		n2 = { s = "2" } ;
		n3 = { s = "3" } ;
		n4 = { s = "4" } ;
		n5 = { s = "5" } ;

		meter = { s = "m" } ;

}
