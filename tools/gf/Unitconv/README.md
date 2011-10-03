Unit conversion grammar
=======================

Introduction
------------

This grammar demonstrates:

  * modularity, e.g. numbers and SI prefixes are described in separate modules
  * compositionality, e.g.
    * SI prefixes can be easily applied to any units,
    * area and volume units can be built from any length units,
    * speed units are built by combining length and time units (km / h)
  * support for multiple wordforms of the same word (`meetrit', `meetrites')
  * using opers to share code
  * smart paradigms (i.e. generate PlIn automatically from SgPart)
  * unit type checking (meters and feet agree, but meters and liters do not)
  * ambiguity, e.g. "kaks minutit sekundites" gets two parse trees

TODO:

  * support numbers with a comma
  * combining Unitconv with Exp, possibilities:
    * simple union, creating a new language (Unitconv + Exp) (will need 2 startcats?);
    * Unitconv uses expressions instead of numbers;
    * Exp uses units instead of numbers, and Conv uses expressions (of the same type).
    instead of numbers in Unitconv, or
  * ambiguity as a UI technique
  * complex conversions, e.g. cost of a time-limited service (internet, parking):
    * "50 cents per 10 minutes in euros per 2 hours"
  * discuss if it makes sense to support variants like {naelades | naeltes},
    { meetritesse | meetriteks }. Since these variants sound similar, we can also
    rely on the speech recognizer robustness (i.e. it would convert a spoken
    /naeltes/ or /naelteks/ into "naelades")
  * "large" vocabulary (hundreds of terminals)
  * "large" grammar (many productions?)
  * handling rare (but legal?) forms like "kilo minut"
  * does attaching of probabilities work (in GF, in GF->JSGF, in JSGF->FSA)
  * lexing and unlexing (writing of numbers) (maybe use binding in the decimal grammar?)
  * exclude repetitions like "12 liters in liters"
  * use dependent types in unit type checking
  * demonstrate and discuss the limitations of FSA and CFG in expressivity (compared to GF)


How to add a new unit to the grammar
------------------------------------

### If the unit's physical quantity is already there

If the unit's quantity (e.g. Length, Mass, ...) is already present in the grammar,
then just edit the file Unit.gf to add the mapping of the new unit (e.g. `meter')
to the existing quantity:

    fun meter : Length;

and add the words of the unit to the concrete syntaxes (UnitEst.gf and UnitApp.gf):

    lin meter = mk "meetrit";
    lin meter = ss "m";

The functions `mk` and `ss` are predefined. They take a string and generate the internally
used lexicon structure, e.g. the `mk` function (defined in UnitEst.gf) also generates
the plural inessive (`PlIn`) form from the given singular partitive form (`SgPart`).
If it turnes out that the automatically generated form is incorrect then use
the `f`-function to provide both forms manually, e.g.

    lin euro = f "eurot" "eurodes" ;


### If you want to add a unit of new physical quantity

If the quantity of the unit is not already described in the grammar then
additionally add a new category to Unit.gf:

    cat Length ; LengthUnit;

and add some functions:

    length_unit : Length -> LengthUnit ;
    prefixed_length_unit : Prefix -> Length -> LengthUnit ; -- only if unit can be SI-prefixed

Into the concrete syntaxes (UnitEst.gf and UnitApp.gf) add the linearizations
of these functions, e.g. in the case of UnitEst.gf:

    length_unit = id CaseStr ;
    prefixed_length_unit = prefix ;

Also, add the corresponding conversion function to Unitconv.gf:

    length : LengthUnit -> LengthUnit -> Conv ;

and the linearization of the function (in both UnitconvEst.gf and UnitconvApp.gf)

    lin length = c ;
