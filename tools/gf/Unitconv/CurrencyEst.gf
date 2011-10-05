concrete CurrencyEst of Currency = open StringOper, Estonian in {

-- @author Kaarel Kaljurand
-- @version 2011-10-05

flags coding=utf8;

oper

	mk_raha : Str -> CaseStr = \x ->
		f (x ++ "raha") (x ++ "rahas") ;

	-- Generates 3 variants, from two input strings, e.g.:
	-- Input: "ameerika", "dollarit"
	-- Output variants:
	--   * dollarit/dollarites
	--   * ameerika dollarit / ameerika dollarites
	--   * ameerika raha / ameerika rahas
	mk_currency_variants_3 : Str -> Str -> CaseStr = \x,y ->
		variants { mk y ; mk (x ++ y); mk_raha x };

	mk_currency_variants_2 : Str -> Str -> CaseStr = \x,y ->
		variants { mk (x ++ y); mk_raha x };


lincat CurrencyUnit = CaseStr;

lin

-- TODO: get the country names from the Country-module
usd = mk_currency_variants_3 "ameerika" "dollarit";
gbp = mk_currency_variants_3 "inglise" "naela";
jpy = mk_currency_variants_3 "jaapani" "jeeni";
rub = mk_currency_variants_3 "vene" "rubla";
huf = mk_currency_variants_3 "ungari" "forintit";

cad = mk_currency_variants_2 "kanada" "dollarit";
nzd = mk_currency_variants_2 "uus mere maa" "dollarit";
aud = mk_currency_variants_2 "austraalia" "dollarit";
nok = mk_currency_variants_2 "norra" "krooni";
sek = mk_currency_variants_2 "rootsi" "krooni";
dkk = mk_currency_variants_2 "taani" "krooni";
isk = mk_currency_variants_2 "islandi" "krooni";

-- This gradation does not seem to be very regular
-- e.g. meetrit -> *meetrides; dollarit -> *dollarides
-- TODO: what does it depend on?
eur = f "eurot" "eurodes";

-- TODO: use Unicode!
chf = mk_currency_variants_3 "s~veitsi" "franki";

eek = variants {
		mk "krooni" ;
		mk "eesti krooni";
		mk_raha "eesti";
		f "vana raha" "vanas rahas"
	};
}
