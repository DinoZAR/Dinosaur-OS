# Welcome to Dinosaur!

Dinosaur is a new operating system designed for multimedia production using the AMD64 architecture. It uses Assembly for the majority of the kernel, which should make for a fast and pleasent operating system.

## How do I get started?

It's recommended until Dinosaur matures to use a virtual machine in order to test out Dinosaur's capabilities. The build instructions assume that you are using VirtualBox as your virtual machine. Also, it is assumed you have a 64-bit processor (which if you don't, Dinosaur will not work for you).

Here is what you need:

 * VirtualBox
 * Python 2.x (some build scripts are in Python)
 * yasm (Assembler used in build scripts)
 
Not too bad, I would say.

However, in Windows, you have to set up your **Path** environment variable to point to yasm.exe and VirtualBox's VBoxManage.exe in order for the build scripts to work. Here's how to find both:

 * yasm.exe: Where ever you extracted yasm, that is where yasm.exe would be.
 * VBoxManage.exe: If you installed it like normal people, VBoxManage.exe would be under **C:\Program Files\Oracle\VirtualBox**.
 
After this is all set up, follow the build instructions below.

### Windows

1. Run build scripts provided in directory **build_win**. You may either double-click **run-all.bat** to run them all, or if you like to see debug info, you can use the command prompt and run **run-all.bat** from there. These scripts build all of the assembly files and creates a VirtualBox Disk Image, which is the virtual hard drive you will use in your Dinosaur virtual machine.

2. Create the Dinosaur virtual machine. Here's how you do that:
	* Click **New** in the upper left hand corner
	* In the wizard, click **Next**
	* Set the **Name** to **Dinosaur**, and under **OS Type**, set **Operating System** to **Other** and **Version** as **Other/Unknown**
	* Leave base memory size as it is for now. Click **Next**
	* Click **Use existing hard disk**, and click on the folder icon. In your Dinosaur-OS directory, travel to **Dinosaur/bootloader** and click on **Dinosaur.vdi** (the one with the red cube icon)
	* Click **Next**
	* This shows you a summary page. Click **Create**
	
3. Click on your new Dinosaur virtual machine and click **Start**! Easy!

4. If you want to update Dinosaur, pull from this repository and run **run-all.bat** again. Your virtual machine will automatically use the newly generated virtual hard drive to boot from.
	* WARNING: If you saved any data to this virtual hard drive, it will be gone in a heartbeat. To make sure this doesn't happen to you, create a secondary virtual hard drive and save your data in there. As of now, I haven't created the build script to generate a properly formatted file system on a hard drive yet.

### Linux

1. Follow Window's instructions to the letter, except build scripts are in **build_linux**, and you would run **run-all**. Everything's named the same, which makes everything consistent and maintenance a breeze.
