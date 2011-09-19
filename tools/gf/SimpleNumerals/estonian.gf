concrete estonian of Numerals = {

-- TODO: not parsed: kaks tuhat kakskümmend kaksteist
-- TODO: bind -sada

flags coding = utf8;

param DForm = unit | teen | ten ;

lincat Numeral =    { s : Str } ;
oper LinDigit = {s : DForm => Str} ;
lincat Digit = LinDigit ;

lincat Sub10 = {s : DForm => Str} ;
lincat Sub100 =     { s : Str } ;
lincat Sub1000 =    { s : Str } ;
lincat Sub1000000 = { s : Str } ;

oper mkNum : Str -> Str -> Str -> LinDigit = 
  \x,y,z -> {s = table {unit => x ; teen => y ; ten => z}} ;

oper regNum : Str -> LinDigit = 
  \x -> mkNum x (x + "teist") (x + "kümmend") ;

oper ss : Str -> {s : Str} = \s -> {s = s} ;

lin num x = x ;
lin n2 = regNum "kaks" ;
lin n3 = regNum "kolm" ;
lin n4 = regNum "neli" ;
lin n5 = regNum "viis" ;
lin n6 = regNum "kuus" ;
lin n7 = regNum "seitse" ;
lin n8 = regNum "kaheksa" ;
lin n9 = regNum "üheksa" ;

lin pot01 = {s = table {f => "üks"}} ;
lin pot0 d = {s = table {f => d.s ! f}} ;
lin pot110 = ss "kümme" ;
lin pot111 = ss "üksteist" ;
lin pot1to19 d = {s = d.s ! teen} ;
lin pot0as1 n = {s = n.s ! unit} ;
lin pot1 d = {s = d.s ! ten} ;
lin pot1plus d e = {s = d.s ! ten ++ e.s ! unit} ;
lin pot1as2 n = n ;
lin pot2 d = {s = d.s ! unit ++ "sada"} ;
lin pot2plus d e = {s = d.s ! unit ++ "sada" ++ e.s} ;
lin pot2as3 n = n ;
lin pot3 n = {s = n.s ++ "tuhat"} ;
lin pot3plus n m = {s = n.s ++ "tuhat" ++ m.s} ;

}
