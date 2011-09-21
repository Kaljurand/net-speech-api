concrete estonian of Numerals = open StringOper in {

-- TODO: in the initial position 100 and 1000 are written without "üks", i.e.
--   * support "tuhat kaks" instead of "üks tuhat kaks"
--   * support "kaks tuhat ükssada" instead of "kaks tuhat sada"

flags coding = utf8;

param DForm = unit | teen | ten | w100 ;

oper LinDigit = {s : DForm => Str} ;

oper mkNum : Str -> Str -> Str -> Str -> LinDigit = 
	\x,y,z,w -> {s = table {unit => x ; teen => y ; ten => z ; w100 => w}} ;

oper regNum : Str -> LinDigit = 
	\x -> mkNum x (x + "teist") (x + "kümmend") (x + "sada");


lincat Numeral = SS ;
lincat Digit = LinDigit ;
lincat Sub10 = LinDigit ;
lincat Sub100 = SS ;
lincat Sub1000 = SS ;
lincat Sub1000000 = SS ;


lin num x = x ;

-- Digit
lin n2 = regNum "kaks" ;
lin n3 = regNum "kolm" ;
lin n4 = regNum "neli" ;
lin n5 = regNum "viis" ;
lin n6 = regNum "kuus" ;
lin n7 = regNum "seitse" ;
lin n8 = regNum "kaheksa" ;
lin n9 = regNum "üheksa" ;

-- Sub10
-- The terminals marked here as "_IGNORED" cannot be reached in this grammar
-- if I understand correctly. In order for them not to show up in JSGF one
-- needs to compile using optimize-pgf.
lin pot01 = mkNum "üks" "_IGNORED" "_IGNORED" "sada";

-- Digit -> Sub10
lin pot0 d = {s = table {f => d.s ! f}} ;

-- Sub100
lin pot110 = ss "kümme" ;
lin pot111 = ss "üksteist" ; -- TODO: can we reuse pot1to19 here?

-- Digit -> Sub100
lin pot1to19 d = {s = d.s ! teen} ;

-- Sub10 -> Sub100
lin pot0as1 n = {s = n.s ! unit} ;

-- Digit -> Sub100
lin pot1 d = {s = d.s ! ten} ;

-- Digit -> Sub10 -> Sub100
lin pot1plus d e = {s = d.s ! ten ++ e.s ! unit} ;

-- Sub100 -> Sub1000
lin pot1as2 n = n ;

-- Sub10 -> Sub1000
lin pot2 d = {s = d.s ! w100} ;

-- Sub10 -> Sub100 -> Sub1000
lin pot2plus d e = {s = d.s ! w100 ++ e.s} ;

-- Sub1000 -> Sub1000000
lin pot2as3 n = n ;
lin pot3 n = {s = n.s ++ "tuhat"} ;

-- Sub1000 -> Sub1000 -> Sub1000000
lin pot3plus n m = {s = n.s ++ "tuhat" ++ m.s} ;

}
