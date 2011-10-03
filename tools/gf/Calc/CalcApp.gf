concrete CalcApp of Calc = ExpApp, UnitconvApp ** open StringOper in {

-- CalcApp is a union of ExpApp and UnitconvApp.
--
-- @author Kaarel Kaljurand
-- @version 2011-10-03

lincat Calc = SS;
lin exp, unitconv = id SS;

}
