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
from rawr_utils import *

# ------------------------------------------------------------------------------
# MAIN FUNCTIONS
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
	pString += '[Note: Files to be written must use Unix absolute paths]\n\n'
	
	# Delete command
	pString += 'delete - Deletes the file from the file system\n'
	pString += '[no options]\n\n'
	
	return pString
	

def new():
	
	# Create a new RAWR file system disc image
	newRAWRPath = os.path.abspath('../../../RAWR.img')
	newRAWR = open(newRAWRPath, 'wb')
	
	# Say what I am doing
	print 'Creating file system in RAWR.img outside working directory...'
	
	# Create my RAWR header using default options below
	asciiLabel = 'RAWR File System'
	versionMajor = '0'
	versionMinor = '5'
	lastAccessTime = 0 # will change in future
	sectorSize = 512
	sizeOfFileSystem = 20971520 # in sectors, meaning size will be 10 GB.
	blockSize = 81920 # In sectors. This should make 256 blocks
	memoryUnitSize = 8192 # This will allow around 1,000 memory units in
			      		  # each block, creating up to 256,000 files total
	
	# Pack it all into a binary string to write to file
	rawrHeader = struct.pack('<16sccIIIII', asciiLabel, versionMajor, versionMinor, 
					lastAccessTime, sectorSize, sizeOfFileSystem, blockSize, 
					memoryUnitSize)
	
	newRAWR.write(rawrHeader)
	
	# Calculate the number of memory units possible in a single block.
	# Do this by finding a quotient and remainder. If the remainder is smaller
	# than the space required to store the memory allocation bitmap, then the
	# maximum possible memory units is the quotient - 1.
	quotient = (blockSize * sectorSize) / memoryUnitSize
	remainder = (blockSize * sectorSize) % memoryUnitSize
	
	numMemoryUnits = 0
	
	if (4 + quotient) > remainder:
		numMemoryUnits = quotient - 1
	else:
		numMemoryUnits = quotient
	
	# Now, I must begin formatting file system by writing blocks in correct
	# locations across the partition space.
	x = 0
	
	# Skip ahead of RAWR header
	x += len(rawrHeader)
	
	# Create a block header that will be the same in each block
	blockHeader = struct.pack('<4s', 'BLCK')
	
	numBytesNeeded = numMemoryUnits // 4
	if (numMemoryUnits % 4) > 0:
		numBytesNeeded += 1
	
	# Add bytes to end of block header that are all 0xFF, or 1111 in bytecode
	# This signifies that all memory unit slots are free.
	for i in range(numBytesNeeded):
		blockHeader += struct.pack('<B', 0xFF)
	
	# Paste that block header across the entire file system
	while x < (sizeOfFileSystem * sectorSize):
	
	
	# After we are done with everything, close the new RAWR file
	newRAWR.close()
		
	
def backup(outputFile):
	pass

def write(filePath, warning, append):
	pass

def delete(filePath):
	pass
	
# ------------------------------------------------------------------------------
# PROGRAM EXECUTION STARTS HERE: Process my arguments
# ------------------------------------------------------------------------------

# Second argument should be my command
command_list = ["new", "backup", "write", "delete"]
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

if command == 'delete':

	# Get my path argument
	filePath = sys.argv[2]
	
	# Issue the command and exit
	delete(filePath)
	sys.exit()
