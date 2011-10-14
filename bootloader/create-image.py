import struct

print "Creating raw disk image:"
diskSize = 2048		# in megabytes
print "Disk Size ->", diskSize, "megabytes"


imageFile = open('Dinosaur.img', 'wb')

# Add bootloader to first sector of "virtual" hard drive
bootFile = open('BOOT.bin', 'rb')
data = bootFile.read()
imageFile.write(data)
bootFile.close()


# Write out my general system block. Refer to "Dinosaur File System - RAWR" for specification


# Inject the kernel


imageFile.close()
print "Disk creation complete!"