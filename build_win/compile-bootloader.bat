@ECHO off
echo Compiling bootloader...
cd ..
cd bootloader
yasm bootloader.asm -f bin -o BOOT.bin
cd ..
cd Build_Windows
echo Done!