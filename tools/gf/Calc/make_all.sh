# TODO: specify these on the commandline
dir_jsgf=../../../lm/
path="../Exp/:../Unitconv/:../Numerals/:../lib/"
name="Calc"
lang="Est"

echo "Generating JSGF"
sh make_jsgf.sh ${name}${lang}.gf $path

echo "Making indexed PGF"
gf -make -s -optimize-pgf -mk-index --path $path ${name}???.gf

echo "Deploying"
mv ${name}${lang}.jsgf ${dir_jsgf}
