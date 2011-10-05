concrete CalcEst of Calc = ExpEst, UnitconvEst ** open StringOper in {

-- CalcEst is a union of ExpEst and UnitconvEst.
--
-- @author Kaarel Kaljurand
-- @version 2011-10-05

lincat Calc = SS;
lin exp, unitconv = id SS;
}
