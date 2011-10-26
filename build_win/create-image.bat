@ECHO off
cd ..
cd Dinosaur\bootloader
echo Creating virtual image...
IF EXIST Dinosaur.img DEL Dinosaur.img
IF EXIST Dinosaur.vdi DEL Dinosaur.vdi
python create-image.py
VBoxManage convertfromraw Dinosaur.img Dinosaur.vdi --uuid cb4350ce-f31a-4751-b3dd-603fa5601f50
cd ..
cd ..
cd build_win
