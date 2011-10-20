#! /usr/bin/python

import argparse
import os
import ProgramMapper


# Parse command line arguments
parser = argparse.ArgumentParser(description='ThunderViper: Thunderizes Python code into Assembly using real lightening!')
parser.add_argument('file', metavar='file.py', type=str, 
					help='The Python file with which to Thunderize.')\

args = parser.parse_args()


# Tell the world what job ThunderViper is doing
print 'Thunderizing file:', args.file
print 'In mode: AMD64'


# Open file for reading
completeFileName = os.path.abspath(args.file)
inFile = open(completeFileName, 'r')


# Get my program lines as a list of lines for me to use
progLines = inFile.readlines()
inFile.close()


# Clean out the trailing whitespaces, which makes it easier to parse
for i in range(len(progLines)):
	progLines[i] = progLines[i].rstrip()
	

# Create a ProgramMap, which is an in-memory graph of the program flow of the
# program, by parsing every line
progMap = ProgramMapper.ProgramMap()
for line in progLines:
	progMap.parse(line)
	
	
# After parsing the file, for debug purposes, print out an HTML page detailing the
# program flow.
progMap.dump('DEBUG_ProgramMap.html')


# After everything is all said and done, say that ThunderViper is finished
print "Done!"
