@ECHO off
cd ..
cd Dinosaur\bootloader
echo Creating virtual image...
IF EXIST Dinosaur.img DEL Dinosaur.img
IF EXIST Dinosaur.vdi DEL Dinosaur.vdi
python create-image.py
VBoxManage convertfromraw Dinosaur.img Dinosaur.vdi
cd ..
cd ..
cd build_win