gf=estonian

gf -make --output-format=jsgf ${gf}.gf

recode utf8..latin1 ${gf}.jsgf

sed -i "s/ UTF-8;/;/" ${gf}.jsgf
