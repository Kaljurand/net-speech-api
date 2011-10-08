resource Estonian = {

-- TODO: use overloading to share oper names

-- @author Kaarel Kaljurand
-- @version 2011-10-05

flags coding=utf8;

param Case = SgPart | SgIn | PlIn ;

-- The f-function requires both forms (`SgPart` and `PlIn`)
-- The mk-function is smart and only requires the "base" form (`SgPart`)
oper
	CaseStr : Type = { s : Case => Str } ;

	prefix : Str -> CaseStr -> CaseStr = \x,y -> add_prefix x y;

	f3 : Str -> Str -> Str -> CaseStr = \sg1,sg2,pl1 ->
		{
			s = table {
				SgPart => sg1 ;
				SgIn => sg2 ;
				PlIn => pl1
			}
	};

	f : Str -> Str -> CaseStr = \x,y ->
		{
			s = table {
				SgPart => x ;
				PlIn => y ;
				_ => "NOT_IMPLEMENTED"
			}
	};

	mk : Str -> CaseStr = \sg_part -> 
		let 
			pl_in : Str = case sg_part of {
				_ + ("a" | "e" | "i" | "o") => sg_part + "des" ; -- jalga + des
				_                           => sg_part + "es"    -- liitrit + es
			} ;
			sg_in : Str = case sg_part of {
				base + ("t" | "d")          => base + "s" ; -- sekundit -> sekundis
				_                           => sg_part + "s" -- raha + s
			} 
		in f3 sg_part sg_in pl_in;

	-- Places a prefix (`kilo`) in front of the given unit word (`meeter`).
	-- TODO: Maybe we should return a more complex structure with a field
	-- for the prefix, instead of doing string concatenation here.
	add_prefix : Str -> CaseStr -> CaseStr = \p,w ->
		{
			s = table {
				SgPart => p ++ (w.s ! SgPart) ;
				SgIn => p ++ (w.s ! SgIn) ;
				PlIn => p ++ (w.s ! PlIn)
			}
	};

	-- Note that the compound expressions do not have the SgIn-form
	-- so we will not implement it:
	-- SgPart: (kolm) meetrit sekundis
	-- PlIn: meetrites sekundis
	-- SgIn: * meetris sekundis
	-- Note the first argument is used to provide "ruut" in case of
	-- "meetrit ruut sekundis".
	mk_meter_per_second : Str -> CaseStr -> CaseStr -> CaseStr = \p,x,y ->
		{
			s = table {
				SgPart => (x.s ! SgPart) ++ p ++ (y.s ! SgIn) ;
				PlIn => (x.s ! PlIn) ++ p ++ (y.s ! SgIn) ;
				_ => "NOT_NEEDED"
			}
		};

}
