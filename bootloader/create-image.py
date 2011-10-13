from struct import Struct

print "Creating raw disk image:"

with open('Dinosaur.img', 'wb') as imageFile:

	print "1: Bootloader"
	
	bootFile = open('BOOT.bin', 'rb')
	data = bootFile.read()
	
	
	bootFile.close()
	
	
	print "2: Partition Table"
	
	
	
	print "3: Kernel"
	
	
	print "Disk creation complete!"