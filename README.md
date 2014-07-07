QBLive
======
i've always called the config files and scripts that make up my normal work environment 'qball', or 'qb'.
more recently, i've been using a customized archlinux livedisk as my primary os, and called it qblive.


Introduction
------------

Livedisks are great because they're nonpersistent.
You can fearlessly hack on config files, experiment with the internal guts of linux, and generally break everything. And then fix it all by simply rebooting; everything is back to a normal, clean slate.
The environment is always clean and resists cruft from old, unused packages that have been forgotten about.
Working in a nonpersistent operating system forces developers to keep track of dependencies, which helps ensure a smooth deployment process.

Livedisks are annoying because premade disks (puppy, archbang, ...) are always missing essential packages and configurations. Nonpersistence forces recreating any desired customizations every boot.
Worse, if you have an .iso file and a USB drive, the standard way of making it a livedisk is to `dd if=/path/to/chosen.iso of=/dev/sdc`, which consumes the entire disk.
If your USB device is 32gb, and the iso only takes a small portion of that, you're wasting the remaining space on the device.

qblive is my response to these problems. It has all the packages i expect to find and use on a day-to-day basis (screen, vim, ...) and my own config files (.bashrc, .screenrc, ...)
It is generated using the archiso package in the archlinux repositories.

To minimize space wasted on a USB device, qblive instances consist of two partitions.
The iso image lives on the first partition, which cannot be written to while booted.
When qblive is booted, this readonly OS partition is mounted at `/run/archiso/img_dev`.
A second partition, which is automatically mounted at boot, is used for storing persistent data.
The only persistent data (by default) is the paccache, so if a desired package isn't included by default, it won't have to be downloaded multiple times.

*WARNING*: `/home/a` and `/root` will **not persist** through reboots.


Creating QBLive ISO Image
-------------------------

Some notes before starting:

* making an iso involves a lot of disk io, so best done on your fastest (**PERSISTENT**) device 
	* usb2 devices do not qualify as "fast". recommended to use a hard drive for this
	* seriously, make sure you're working on a persistent storage device. or, at the very least, remember to move the created .iso to somewhere persistent before rebooting
	* again, `/home/a/` and `/root/` are *not* persistent directories
	* `/mnt/persist` is persistent, or any other partitions you may have mounted yourself
* you cannot overwrite a qblive.iso that is currently booted (see section below for info about updating)
* this project relies on archiso, which in turn requires 64-bit architecture. you can boot qblive on a 32-bit machine, but cannot create isos
* the system's configured paccache will be used, which will help minimize downloads, but don't do a `sudo pacman -Syu` before updating, since kernel updates will effect your ability to mount devices

<!-- without this line, markdown formatting fucks up -->

	cd /path/to/qblive
	sudo rm -rf releng #if necessary
	./mkiso.sh

when complete, the iso will be placed in `releng/out/archlinux-$(date +%Y.%m.%d)-dual.iso`


Installing QBLive
-----------------

* Partition the target device with two partitions; one to hold the iso and boot loader (grub2), the other for persistent data. Label these partitions `qblive` and `qbpersist`, respectively.
	* first partition recommended at least 1.5GB
	* these directions, generated grub.cfg, and included fstab rely on these labels, specifically. if you chose different labels, be sure to update all relevant files.
	* changes to fstab (or any other files included in the image) require regenerating the .iso image to take effect
* Build the iso with the `mkiso.sh` script (see directions above for more detail)
* Install grub2 to the device.

		#make mountpoint & mount partition
		sudo mkdir /mnt/qbl
		sudo mount -L qblive /mnt/qbl
		#install grub
		#note: the --force flag should only be needed if installing to a usb drive; real hard drives can omit it
		#note: this assumes you're targeting the device at /dev/sdc. change as appropriate
		sudo grub-install --force --no-floppy --boot-directory=/mnt/qbl/boot /dev/sdc

* Copy the iso onto the qblive partition

		sudo cp releng/out/archlinux-$(date +%Y.%m.%d)-dual.iso /mnt/qbl/qblive.iso

* Generate and copy grub config to the device

	* `./gen_grubcfg.sh` creates a grub.cfg with correct flags in the current directory.
	* either copy it to the device: `sudo cp grub.cfg /mnt/qbl/boot/grub/grub.cfg`
	* or use it as a template to manually update existing grub.cfg to use correct `archisolabel` and `img_dev` flags

* All done. Unmount and boot the device

		sudo umount /mnt/qbl
		sudo reboot


Updating
--------

Since the OS partition cannot be changed while booted, it cannot be updated while running. A secondary OS is required.
I use two qblive instances (one on my hdd, one on a usbstick) to update each other.

* boot first (hdd) qblive device
* make a fresh iso and install it to the second (usb) device
	* note: beware of using -L to mount, as multiple qblive instances may result in multiple partitions with the same label
* boot the second (usb) device and test that everything works
* mount the first (hdd) device for updating. again, i'm mounting by specifying the device instead of the label

		sudo mkdir /mnt/qbl; sudo mount /dev/sda7 /mnt/qbl

* copy the running iso to the first device

		sudo cp /run/archiso/img_dev/qblive.iso /mnt/qbl/qblive.iso

* update `/mnt/qbl/boot/grub/grub.cfg` as needed



Troubleshooting
---------------
some problems i've run into while working with qblive, and solutions:

### The usb device boots to a blank screen with a blinking cursor *instead* of showing grub menu
Install grub to the device (/dev/sdc), not the partition (/dev/sdc1) ; this is the last argument to the grub-install command

###the usb device boots to a blank screen with a blinking cursor *after* choosing an option from the grub menu
three possibilities:

* you're impatient; loading an iso can take some time, especially on slow hardware using a slow disk. give it another minute
* you're trying to boot the 64-bit kernel on a 32-bit device. reboot and try again
* everything is horribly broken. good luck.

###"Waiting 30 seconds for device" on boot:
this madness could be one of two things; pay attention to which label can't be mounted:

	Waiting 30 seconds for device /dev/disk/by-label/qblive ...
	ERROR: `/dev/disk/by-label/qblive` device did not show up after 30 seconds...
	Falling back to interactive prompt
	You can try to fix the problem manually, log out when you are finished

If the qblive label is the problem: i only get this in one specific scenario (booting 32-bit from USB) and it essentially fixes itself.
Once dropped into the shell, the device is immediately recognized; the `/dev/disk/by-label/qblive` simlink is created automatically.
Everything works normally after exiting the shell without having to actually do anything.
Still very annoying if you'll be booting into this frequently, so if this is the case, may want to consider
specifying the `img_dev` flag by UUID instead of label in your grub.cfg (EG: `img_dev=/dev/disk/by-uuid/deadbeef-1010-bed5-eee8-fa57badcad42`)

	ERROR: /dev/disk/by-label/ARCH_201407 device did not show up after 30 seconds...

This is the more common version of the previous error. the arch iso's label is dated for the month the iso was created, so if you've updated the iso and not also updated your grub.cfg this month, this will happen.
Check that your grub.cfg has the correct archisolabel flag.
To get an iso's label use this: `isoinfo -d -i /dev/qbl/qblive.iso | grep 'Volume id'`
(isotools is provided by cdrkit package, which is not installed by default. `sudo pacman -Sy cdrkit`).
I've also seen this problem happen with a grub.cfg that looks correct. In this case, rebuilding the device (including the partitioning) corrected the problem.

### i can't mount devices!

Did you `sudo pacman -Syu` and install kernel updates? Don't do that...
Necessary modules won't reload until you reboot, and rebooting will remove your updates.
Upgrade qblive by building a new iso (rerunning the mkiso.sh script will fetch the latest version of all packages) and following the instructions above

### capslock is broken!

no it isn't. capslock is *fixed* -- meaning it has been turned into an additional ctrl key :-)

