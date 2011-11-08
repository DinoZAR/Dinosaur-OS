# This is the entry point from which scripts needing to do operations with the
# filesystem should go to. It can create new ones, write files to it, back it
# up, and repair it if needed be. It does all of its operations on an image,
# which does not include an MBR nor a partition table.
#
# The file system image is stored outside of the working directory and is saved 
# as Dinosaur_RAWR.img

import sys
import os

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
	pString += '-o dest: Saves backup to destination'
	return pString
	

def new():
	pass
	
def backup():
	pass

def check():
	pass

def write():
	pass

	
# ------------------------------------------------------------------------------
# PROGRAM EXECUTION STARTS HERE: Process my arguments
# ------------------------------------------------------------------------------

# Second argument should be my command
command_list = ["new", "backup", "check", "write"]
command = sys.argv[1]

# Check to see if command is a subset of my commands available
if not (command in command_list):
	print "You inputted an invalid command, you fool!"
	print "Here art what it to be!:\n"
	print properUse()
	sys.exit()
	
	
