# Generates JSGF from a GF concrete syntax.
# Applies some post-processing to make the JSGF compatible
# with the speech recognition server.
# Tested with GF 3.2.9.
#
# Usage:
#
# sh make_jsgf.sh Action/ActionEst.gf "lib:Calc:Direction:Address:Exp:Fraction:Numerals:Unitconv"
#
# Note: because of `recode` this script can only
# be applied to files that are in the same directory with it.
# TODO: fix this problem
#
# @author Kaarel Kaljurand
# @version 2011-10-06

output_dir="../../lm/"

if [ $# -ne 2 ]
then
	echo "Usage: sh make_jsgf.sh <gf-file> <path>"
	exit
fi

basename=${1##*/}

jsgf="${output_dir}${basename%.*}.jsgf"
path=$2

# Generate JSGF for the given concrete syntax
echo "Generating ${jsgf}..."
gf -make --optimize-pgf --path $path --output-format=jsgf --output-dir ${output_dir} $1


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
