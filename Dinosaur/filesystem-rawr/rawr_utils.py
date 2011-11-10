# These are utility functions used by the rawr script. This shouldn't be called
# by itself, but I won't stop them

import struct

'''Extracts an entry at a specific point specified by the file handle. To extract
   entries from any area on the virtual hard drive, the file handle needs to be
   seeked first. The extracted entry will be formatted as the following:
   (entry_type, name_length, name, end_LBA_address)'''
def extract_entry_to_tuple(fileHandle):
	
	# Extract the entry type and the name length, which will be 5 bytes
	typeAndLength = struct.unpack('BI', fileHandle.read(5))
	
	print typeAndLength
