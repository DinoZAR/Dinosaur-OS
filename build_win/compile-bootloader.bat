@ECHO off
echo Compiling bootloader...
cd ..
cd Dinosaur\bootloader
yasm bootloader.asm -f bin -o BOOT.bin
cd ..
cd ..
cd build_win
