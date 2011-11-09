# This is the entry point from which scripts needing to do operations with the
# file system should go to. It can create new ones, write files to it, back it
# up, and repair it if needed be. It does all of its operations on an image,
# which does not include an MBR nor a partition table.
#
# The file system image is stored outside of the working directory and is saved 
# as Dinosaur_RAWR.img.
#
# This program only creates RAWR file systems, or Ridiculously Awesome Writer
# Reader file systems.

import sys
import os
import struct

# ------------------------------------------------------------------------------
# Functions used
# ------------------------------------------------------------------------------

def properUse():
	pString = ""
	
	pString += 'python rawr.py command [-o OPTIONS]\n\n'
	pString += 'Commands:\n\n'
	
	# New command
	pString += 'new - Creates a brand-new RAWR file system\n'
	pString += '[no options]\n\n'
	
	# Backup command
	pString += 'backup - Backs up your filesystem and saves it\n'
	pString += '-o dest: Saves backup to destination\n\n'
	
	# Write command
	pString += 'write - Writes a file to the filesystem\n'
	pString += '-w: Warn if this file already exists\n'
	pString += '-a: Append rather than overwrite an existing file\n'
	pString += '[Note: Files to be written must use Unix absolute paths]'
	
	return pString
	

def new():
	
	# Make a brand-new RAWR file system
	outFileName = os.path.abspath('../../../Dinosaur_RAWR.img')
	
	outFile = open(outFileName, 'wb')
	
	# Create a new RAWR entry defining the root entry
	# A RAWR Entry looks like this:
	# (Completed?) (Entry Type) (Name Length 32bit) (Name) (End LBA)
	#
	# Entry types can be of the following (a byte long enumeration)
	#
	# 1: File
	# 2: Directory
	# 3: Thunder-ectory (directories gauranteed to be sequential, good for
	#    streaming stuff)
	# 4: Link (used in directories to find files)
	#
	# RAWR is simple in that it only possesses Entries. The combination of those
	# entries and the algorithms used is what makes the RAWR file system. Making
	# everything as entries improves maintenance because not only can one add
	# more data to each entry when the filesystem becomes more advanced, they
	# can also add new kinds of entries without breaking what was there before.
	
	entry = struct.pack('BI', 2, 1)
	entry += struct.pack('s', '/')
	entry += struct.pack('II', 3)		# Root can have links to entries
										# from LBA 2 to 3
	outFile.write(entry)
	
	outFile.close()
	
	# To be honest, this wasn't a whole lot. But, that's the magic of RAWR
	
def backup(outputFile):
	pass

def write(file, warning, append):
	pass

	
# ------------------------------------------------------------------------------
# PROGRAM EXECUTION STARTS HERE: Process my arguments
# ------------------------------------------------------------------------------

# Second argument should be my command
command_list = ["new", "backup", "write"]
command = sys.argv[1]

# Check to see if command is a subset of my commands available
if not (command in command_list):
	print "You inputted an invalid command, you fool!"
	print "Here\'s how you do it:\n"
	print properUse()
	sys.exit()

# Heck, if the command is most definitely valid, then by golly process the thing
if command == 'new':
	new()
	sys.exit()
	
if command == 'backup':
	
	# Check for additional optional arguments and fill them with default values
	# if needed
	outputFile = os.path.abspath('../../../Dinosaur_RAWR_backup.img')
	
	if '-o' in sys.argv:
		# Find where the -o flag is, and use the argument after that
		outputFile = os.path.abspath(sys.argv[sys.argv.index('-o') + 1])
	
	# Run the method, then exit
	backup(outputFile)
	sys.exit()

if command == 'write':
	
	# Check for the other arguments
	outputFile = sys.argv[2]
	warning = False
	append = False
	
	if '-w' in sys.argv:
		warning = True
	
	if '-a' in sys.argv:
		append = True
		
	# Issue the command and exit
	write(outputFile, warning, append)
	sys.exit()