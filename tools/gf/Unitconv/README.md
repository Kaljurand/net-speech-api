Unit conversion grammar
=======================

Introduction
------------

This grammar demonstrates:

  * modularity, e.g. numbers and SI prefixes are described in separate modules
  * support for multiple wordforms of the same word (`meetrit', `meetrites')
  * using opers to share code
  * smart paradigms (i.e. generate PlIn automatically from SgPart)
  * unit type checking (meters and feet agree, but meters and liters do not)
  * ambiguity, e.g. "kaks minutit sekundites" gets two parse trees

TODO:

  * add units with s~/z~
  * "large" vocabulary (hundreds of terminals)
  * "large" grammar (many productions?)
  * refactor out `square` and `cube`
  * support "100 ruut senti meetrit sekundis ruut kilo meetrites tunnis" (requires support for SgIn)
  * handling rare (but legal?) forms like "kilo minut"
  * does attaching of probabilities work (in GF, in GF->JSGF, in JSGF->FSA)
  * lexing and unlexing (writing of numbers) (maybe use binding in the decimal grammar?)
  * exclude repetitions like "12 liters in liters"
  * use dependent types in unit type checking 
  * demonstrate and discuss the limitations of FSA and CFG in expressivity (compared to GF)


How to add a new unit to the grammar
------------------------------------

If the unit's type (e.g. LengthUnit, WeightUnit, ...) is already present in the grammar,
then just edit the file Unit.gf to add the mapping of the new unit (e.g. `meter')
to the existing type:

    fun meter : LengthUnit;

and add the words of the unit to the concrete syntaxes (UnitEst.gf and UnitApp.gf):

    lin meter = mk "meetrit";
    lin meter = ss "m";

The functions `mk` and `ss` are predefined. They take a string and generate the internally
used lexicon structure, e.g. `mk` also generates the plural inessive form from the given string.
You do not need to change these functions (unless it turns out that they do not work correctly).

If the type is not described in the grammar then additionally add the new category to Unit.gf:

    cat LengthUnit;

and the corresponding conversion function to Unitconv.gf:

    length : LengthUnit -> LengthUnit -> Conv ;

and the implementation of the function (in both UnitconvEst.gf and UnitconvApp.gf)

    lin length = c ;
