# Welcome to Dinosaur!

Dinosaur is a new operating system designed for multimedia production using the AMD64 architecture. It uses Assembly for the majority of the kernel, which should make for a fast and pleasent operating system.

## How do I get started?

It is recommended until Dinosaur matures to use a virtual machine in order to test out Dinosaur's capabilities. The build instructions assume that you are using VirtualBox as your virtual machine. Also, it is assumed you have a 64-bit processor (which if you don't, Dinosaur will not work for you).

### Windows

1. Run build scripts provided in directory **build_win**. You may either double-click **run-all.bat** to run it, or if you like to see debug info, you can use the command prompt and run **run-all.bat** from there.

2. Create the Dinosaur virtual machine. Here's how you do that
	* Click **New** in the upper left hand corner
	* In the wizard, click **Next**
	* Set the **Name** to **Dinosaur**, and under **OS Type**, set **Operating System** to **Other** and **Version** as **Other/Unknown**
	* Leave base memory size as it is for now. Click **Next**
	* Click **Use existing hard disk**, and click on the folder icon. In your Dinosaur-OS directory, travel to **Dinosaur/bootloader** and click on **Dinosaur.vdi** (the one with the red cube icon)
	* Click **Next**
	* This shows you a summary page. Click **Create**
	
3. Click on your new Dinosaur virtual machine and click **Start**
