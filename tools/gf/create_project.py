#! /usr/bin/env python

# Creates a GF application grammar project skeleton
#
# Example:
#
# python create_project.py --name="Test" --lang="Est,App"
#
# @author Kaarel Kaljurand
# @version 2011-10-03
#
import sys
import argparse
import os
import re
import time
import codecs
from os.path import join

placeholder_name_abstract = re.compile('<NAME_ABSTRACT>')
placeholder_name_lang = re.compile('<NAME_LANG>')
abstract = """abstract <NAME_ABSTRACT> = {

-- <NAME_ABSTRACT> is ...
--
-- @author
-- @version

flags startcat = Main ;

cat Main;

fun main : Main;
}
"""

concrete = """concrete <NAME_ABSTRACT><NAME_LANG> of <NAME_ABSTRACT> = {

-- <NAME_LANG> is ...
--
-- @author
-- @version

flags coding = utf8;

lincat Main = { s : Str };

lin main = { s = "main" };
}
"""

test = """
# Declare the name of the grammar and the paths to the used libraries
name="<NAME_ABSTRACT>"
path="../Numerals/:../lib/"

# These you probably do not need to modify
l="${name}<NAME_LANG>"

l_f="${l}.gf"

examples="examples/"
e_f="${examples}<NAME_LANG>.txt"

# These are the actual tests
cat ${e_f} | sed "s/^/p -lang=${l} \\"/" | sed 's/$/" | l -all/' | gf --run --path $path ${l_f}
"""


def write_string_into_file(dir, name, s):
	path = os.path.join(dir, name)
	f = open(path, 'w')
	f.write(s)
	f.close
	print 'Created: {:}'.format(path)


def create_project(name):
	"""
	"""
	print 'Create new project: {:}'.format(name)
	os.mkdir(name)
	path_examples = os.path.join(name, "examples")
	os.mkdir(path_examples)
	abstract_formatted = placeholder_name_abstract.sub(name, abstract)
	write_string_into_file(name, name + ".gf", abstract_formatted)
	for lang in args.lang.split(','):
		print 'Creating new concrete syntax: {:}'.format(lang)
		s = placeholder_name_abstract.sub(name, concrete)
		s = placeholder_name_lang.sub(lang, s)
		t = placeholder_name_abstract.sub(name, test)
		t = placeholder_name_lang.sub(lang, t)
		write_string_into_file(name, name + lang + ".gf", s)
		write_string_into_file(name, "test_" + lang + ".sh", t)
		write_string_into_file(path_examples, lang + ".txt", lang)


def get_args():
	p = argparse.ArgumentParser(description='Create a skeleton of a GF project.')
	p.add_argument('-n', '--name', type=str, action='store', dest='name', help='set the name of the project') 
	p.add_argument('-l', '--lang', type=str, action='store', dest='lang', default='C1,C2', help='set the languages (comma-separated) (default: C1,C2)')
	#p.add_argument('-s', '--simulate', action='store_true', dest='simulate', default=False, help='simulate the actions but do not carry them out (default: false)')
	p.add_argument('-v', '--version', action='version', version='%(prog)s v0.1')
	return p.parse_args()

args = get_args()

# TODO: there is probably a better way to do this
if args.name is None:
	print >> sys.stderr, 'ERROR: argument -n/--name is not specified'
	exit()

create_project(args.name)

#print 'Duration: {:.2f} sec'.format(time_end - time_start)
