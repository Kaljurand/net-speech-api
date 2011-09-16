--# -path=.:prelude

concrete estonian of Numerals = open Prelude in {

flags coding=utf8;

param Place = indep | attr  ;
param Nm = sg  | pl  ;
oper sata : Nm => Str =
  table {sg => "sada" ; pl => "sada"} ;
oper tuhat : Nm => Str =
  table {sg => "tuhat" ; pl => "tuhat"} ;
lincat Numeral = {s : Str} ;
lincat Digit = {s : Str} ;
lincat Sub10 = {inh : Nm ; s : Place => Str} ;
lincat Sub100 = {inh : Nm ; s : Place => Str} ;
lincat Sub1000 = {inh : Nm ; s : Place => Str} ;
lincat Sub1000000 = {s : Str} ;
lin num x0 =
  {s = x0.s} ;
lin n2  =
  {s = "kaks"} ;
lin n3  =
  {s = "kolm"} ;
lin n4  =
  {s = "neli"} ;
lin n5  =
  {s = "viis"} ;
lin n6  =
  {s = "kuus"} ;
lin n7  =
  {s = "seitse"} ;
lin n8  =
  {s = "kaheksa"} ;
lin n9  =
  {s = "üheksa"} ;
lin pot01  =
  {inh = sg ; s = table {attr => [] ; indep => "üks"}} ;
lin pot0 d =
  {inh = pl ; s = table {p => d.s}} ;
lin pot110  =
  {inh = pl ; s = table {p => "kümme"}} ;
lin pot111  =
  {inh = pl ; s = table {p => "üksteist"}} ;
lin pot1to19 d =
  {inh = pl ; s = table {p => Prelude.glue d.s "teist"}} ;
lin pot0as1 n =
  {inh = n.inh ; s = table {p => n.s ! p}} ;
lin pot1 d =
  {inh = pl ; s = table {p => Prelude.glue d.s "kümmend"}} ;
lin pot1plus d e =
  {inh = pl ; s = table {p => Prelude.glue d.s "kümmend" ++ e.s ! indep}} ;
lin pot1as2 n =
  {inh = n.inh ; s = table {p => n.s ! p}} ;
lin pot2 d =
  {inh = pl ; s = table {p => Prelude.glue (d.s ! attr) (sata ! (d.inh))}} ;
lin pot2plus d e =
  {inh = pl ; s = table {p => Prelude.glue (d.s ! attr) (sata ! (d.inh)) ++ e.s ! indep}} ;
lin pot2as3 n =
  {s = n.s ! indep} ;
lin pot3 n =
  {s = (n.s ! attr) ++ tuhat ! (n.inh)} ;
lin pot3plus n m =
  {s = (n.s ! attr) ++ (tuhat ! (n.inh)) ++ m.s ! indep} ;

}
