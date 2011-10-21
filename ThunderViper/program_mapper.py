
class ProgramMap:

	def __init__(self):
		
		# Current line in question
		currLine = ''
		
		# List of program objects
		# Each object will be represented as [parent, obj]
		# The list will not be nested, but instead, everything is referenced to another, from
		# which the tree structure can be generated.
		#
		# The root is defined as 0.
		progObjs = []
		
	def parse(self, line):
		pass
		
	
	def dump(self, filename):
		pass
		