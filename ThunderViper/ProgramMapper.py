import re

class ProgramMap:
	
	# Since Python is an interpreted language, each line can be interpreted as
	# independent except for statements executed before.
	
	# The only thing this does not apply to is calling functions, which can be
	# defined in later portions of the file. However, reading ahead should not
	# be necessary in interpreting Python.
	
	# Mapping program constructs involves accumulating data from each line, deducing
	# where operators, variables, methods, and other data are, and then adding each
	# as an object to a program tree. The program tree defines how the program is
	# constructed, and from there, an Assembly representation will be created from
	# it.
	
	def __init__(self):
		
		# Current line it is parsing
		line = ''
		
		# Program tree object list
		progObjList = []
		
		
	def parse(self, line):
		
		# Scan the line for a single equals sign. This should assign what is on
		# the right to what is on the left.
	
	def dump(self, outFile):
		'''Prints out the contents of the program tree in a specially formatted HTML page.
		Outfile defines where the HTML output should be saved.'''
		
		print 'Dumping contents of program tree!'
