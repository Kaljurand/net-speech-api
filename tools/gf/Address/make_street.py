#! /usr/bin/env python

# Creates two GF files, abstract and concrete, containing the words
# found in STDIN.

# Usage:
#
# cat tallinn3.htm | sh filter.sh | python make_street.py
#

import sys

name_abstract = "StreetF.gf"
name_concrete = "StreetFEst.gf"

header_abstract = """abstract StreetF = {

flags startcat = Street ;

cat Street;
fun
"""

header_concrete = """concrete StreetFEst of StreetF = {

flags coding=utf8;
lincat Street = Str;

lin
"""

footer_abstract = ": Street;}"
footer_concrete = "}"

f = open(name_concrete, 'w')
f.write(header_concrete)
i = 0
names = {}
for line in sys.stdin.readlines():
	i = i + 1
	street_id = "s" + str(i)
	# TODO: don't use explicit \n
	f.write('{:} = {:}\n'.format(street_id, line.rstrip()))
	names[street_id] = 1
f.write(footer_concrete)
f.close()

f = open(name_abstract, 'w')
f.write(header_abstract)
l = len(names)
i = 0
for name in names:
	i = i + 1
	# TODO: don't use explicit \n
	if i < l:
		f.write('{:},\n'.format(name))
	else:
		f.write('{:}\n'.format(name))
f.write(footer_abstract)
f.close()
