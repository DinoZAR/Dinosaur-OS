@ECHO off
cd ..
cd ..
IF EXIST Dinosaur.img DEL Dinosaur.img
IF EXIST Dinosaur.vdi DEL Dinosaur.vdi
cd Dinosaur-OS\Dinosaur\bootloader
echo Creating virtual image...
python create-image.py
cd ..
cd ..
cd ..
VBoxManage convertfromraw Dinosaur.img Dinosaur.vdi --uuid cb4350ce-f31a-4751-b3dd-603fa5601f50
cd Dinosaur-OS\build_win
