# Generates JSGF from a GF concrete syntax.
# Applies some post-processing to make the JSGF compatible
# with the speech recognition server.
# Tested with GF 3.2.9.
#
# @author Kaarel Kaljurand
# @version 2011-09-17

if [ $# -ne 1 ]
then
	echo "Usage: sh make_jsgf.sh <gf-file>"
	exit
fi

jsgf="${1%.*}.jsgf"

# Generate JSGF for the given concrete syntax
echo "Generating ${jsgf}..."
gf -make --output-format=jsgf $1

echo "Converting it to Latin1 encoding..."
# Convert the JSGF grammar from UTF8 to Latin1 to be compatible
# with the server.
# TODO: handle s^ and z^ as well
recode utf8..latin1 $jsgf
sed -i "s/ UTF-8;/;/" $jsgf

echo "Removing superfluous public-keywords..."
# Delete all the "public" keywords and put only one back,
# before the MAIN-rule.
sed -i "s/^public //" $jsgf
sed -i "s/^<MAIN>/public <MAIN>/" $jsgf
echo "done."
