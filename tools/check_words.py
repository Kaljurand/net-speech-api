#! /usr/bin/env python

# Generates a list of words that are declared in the given JSGF grammars but not
# present in the given dict-file (that maps words to their pronunciations).
#
# @author Kaarel Kaljurand
# @version 2011-09-26
#
# Example:
#
# python check_words.py -d all_words.dict -i .
#
import sys
import argparse
import os
import re
from os.path import join

extension_pattern='\.jsgf'

def index_words(file):
	"""
	Dict-file parser. Converts the given dict-file
	into a set of all the words in the file, and
	returns this set.
	TODO: support abbreviations, e.g. USA[uuessaa]
	"""
	legal_words = {}
	line_num = 0
	for line in open(file):
		line_num = line_num + 1
		splits = line.split()
		if (len(splits) > 1):
			entry = splits[0]
			legal_words[entry] = 1
		else:
			print >> sys.stderr, 'Warning: ignored line', line_num
	return legal_words


def jsgf_line_to_words(line):
	"""
	Parses a line in a JSGF file and returns all the terminals.
	TODO: this is a bit of a hack, and does not work completely/correctly
	"""
	pattern_word = re.compile('^[a-z]')
	for token in line.split():
		if re.match(pattern_word, token):
			yield token


def ignore(line):
	"""
	Describes JSGF lines which do not contain any terminals
	and which should thus be ignored.
	"""
	comment = re.compile('^//')
	name = re.compile('^grammar ')
	decl = re.compile('^#JSGF')
	return re.match(comment, line) or re.match(name, line) or re.match(decl, line)


def dir_to_files(top):
	"""
	Generates relative pathnames that correspond to
	files with the extension $extension_pattern in the given directory.
	"""
	for root, dirs, files in os.walk(top):
		for name in files:
			path = os.path.join(root, name)
			basename, extension = os.path.splitext(path)
			if re.match(extension_pattern, extension):
				yield path


parser = argparse.ArgumentParser(description='Check for illegal words in JSGF files')

parser.add_argument('-i', '--in', type=str, action='store', dest='dir_in',
                   help='set the directory that contains the input JSGF files (OBLIGATORY)')

parser.add_argument('-d', '--dict', type=str, action='store', dest='dict',
                   help='set the dictionary file (OBLIGATORY)')

parser.add_argument('-v', '--version', action='version', version='%(prog)s v0.1')

args = parser.parse_args()

# TODO: there is probably a better way to do this
if args.dir_in is None:
	print >> sys.stderr, 'ERROR: argument -i/--in is not specified'
	exit()

# TODO: there is probably a better way to do this
if args.dict is None:
	print >> sys.stderr, 'ERROR: argument -d/--dict is not specified'
	exit()

legal_words = index_words(args.dict)

gen_files = dir_to_files(args.dir_in)

for file in gen_files:
	for line in open(file):
		if ignore(line):
			continue
		for word in jsgf_line_to_words(line):
			if word not in legal_words:
				print '{:}: {:}'.format(file, word)
