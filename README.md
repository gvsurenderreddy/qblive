QBLive
======
historically, i've always called the config files and scripts that make up my normal work environment 'qball'.
more recently, i've been using a customized archlinux livedisk as my primary os, and called it qblive.


Introduction
------------
livedisks are great because they're nonpersistent.
you can fearlessly hack on config files, experiment with the internal guts of linux, and generally break everything. and then fix it all by simply rebooting; everything is back to a normal, clean slate.
the environment is always clean and resists cruft from old, unused packages that have been forgotten about.
working in a nonpersistent operating system forces developers to keep track of dependencies, which helps ensure a smooth deployment process.

livedisks are annoying because premade disks (puppy, archbang, ...) are always missing essential packages and configurations. nonpersistence forces recreating any desired customizations every boot.
worse, if you have an .iso file and a USB drive, the standard way of making it a livedisk is to `dd if=/path/to/chosen.iso of=/dev/sdc`, which consumes the entire disk.
if your USB device is 32gb, and the iso only takes a small portion of that, you're wasting the remaining space on the device.

qblive is my response to these problems. it has all the packages i expect to find and use on a day-to-day basis (screen, vim, ...) and my own config files (.bashrc, .screenrc, ...)
it is generated using the archiso package in the archlinux repositories.

qblive instances consist of two partitions.

the iso image lives on the first partition, which cannot be written to while booted.
when qblive is booted, this readonly OS partition is mounted at /run/archiso/img_dev
since the image is not the only thing on disk, a bootloader is necessary. grub is used since syslinux and other bootloaders i've tried can't boot iso files

qblive relies on a second partition, which is automatically mounted at boot, for storing persistent data.
the only persistent data (by default) is the paccache, so if a desired package isn't included by default, it won't have to be downloaded multiple times.

*WARNING*: `/home/a` and `/root` will *_not_ persist* through reboots.


Creating QBLive ISO Image
-------------------------
* notes:
    * making an iso involves a lot of disk io, so best done on your fastest (PERSISTENT) device 
    * usb2 devices do not qualify as "fast", and reportedly have limited writes. recommended to use a hard drive for this
    * seriously, make sure you're working on a persistent storage device. or, at the very least, remember to move the created .iso to somewhere persistent before rebooting
    * /home/a and /root are *not* persistent directories
    * you cannot overwrite a qblive.iso that is currently booted 
* relies on archiso, which in turn requires 64-bit architecture; either use qblive (which has archiso) or archlinux with archiso installed
* the system's configured paccache will be used, which will help minimize downloads
* cd to root of a clone of this repository
* remove releng if it exists. hope to be able to reuse releng/work at some point, but not there yet. `sudo rm -rf releng`
* run `./mkiso.sh`
* when complete, the iso will be placed in releng/out/archlinux-$(date +%Y.%m.%d)-dual.iso


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
    ./gen_grubcfg.sh #creates a grub.cfg in the current directory.
	#either copy it to the device:
    sudo cp grub.cfg /mnt/qbl/boot/grub/grub.cfg
	#or use it as a template to manually update existing grub.cfg to use correct archisolabel & img_dev flags
* All done. Unmount and boot the device
    sudo umount /mnt/qbl
    sudo reboot


Updating
--------
since the OS partition cannot be changed while booted, it cannot be updated while running, and a secondary OS is required
i use two qblive instances to update each other. (one lives on my hdd, one on a usbstick)
* make a fresh iso (i always do this on my hdd)
* mount the target partition
    mkdir /mnt/qb2up
    mount /dev/sda7 /mnt/qb2up # change device here as needed; beware of using -L, as following these instructions to the letter will make all your OS partitions have the same 'qblive' label
* copy the iso to the target partition
    #note: use the correct filename....this won't work if file was not generated today
    sudo cp releng/out/archlinux-$(date +%Y.%m.%d)-dual.iso /mnt/qb2up/qblive.iso
    #alternatively, if currently in an up-to-date qblive instance, and need to copy this instance to /mnt/qb2up, can use this:
    sudo cp /run/archiso/img_dev/qblive.iso /mnt/qb2up/qblive.iso
* update grub.cfg
    * either regenerate the grub.cfg with `./gen_grubcfg.sh` and copy it `sudo cp grub.cfg /mnt/qb2up/boot/grub/grub.cfg`
    * or manually update the archisolabel flag to be correct (iso label is ARCH_YYYYMM, where YYYY is the current year, MM is the current month)


Troubleshooting
---------------
some problems i've run into while working with qblive, and solutions:

The usb device boots to a blank screen with a blinking cursor *instead of showing grub menu*
Install grub to the device (/dev/sdc), not the partition (/dev/sdc1) ; this is the last argument to the grub-install command

the usb device boots to a blank screen with a blinking cursor *after choosing an option from the grub menu*
three possibilities:
* you're impatient; loading an iso can take some time, especially on slow hardware using a slow disk. give it another minute
* you're trying to boot the 64-bit kernel on a 32-bit device. reboot and try again
* everything is horribly broken. good luck.

this madness could be one of two things; pay attention to which label can't be mounted:
> Waiting 30 seconds for device /dev/disk/by-label/qblive ...
> ERROR: `/dev/disk/by-label/qblive` device did not show up after 30 seconds...
> Falling back to interactive prompt
> You can try to fix the problem manually, log out when you are finished

if the qblive label is the problem: i only get this in one specific scenario (booting 32-bit from USB) and it essentially fixes itself.
once dropped into the shell, the device is immediately recognized; the /dev/disk/by-label/qblive simlink is created automatically.
everything works normally after exiting the shell without having to actually do anything.
still very annoying if you'll be booting into this frequently, so if this is the case, may want to consider
specifying the img_dev flag by UUID instead of label in your grub.cfg (EG: img_dev=/dev/disk/by-uuid/deadbeef-1010-bed5-eee8-fa57badcad42)

> ERROR: /dev/disk/by-label/ARCH_201407 device did not show up after 30 seconds...
this is the more common version of the previous error. the arch iso's label is dated for the month the iso was created, so if you've updated the iso and not also updated your grub.cfg this month, this will happen.
check that the grub.cfg file has the correct archisolabel flag.
to get an iso's label use this: `isoinfo -d -i /dev/qbl/qblive.iso | grep 'Volume id'`
(isotools is provided by cdrkit package, which is not installed by default. `sudo pacman -Sy cdrkit`).
i've also seen this problem happen with a grub.cfg that looks correct. in this case, rebuilding the device (including the partitioning) corrected the problem

pacman failures (404s) when running on 32-bit
edit /etc/pacman.conf and remove multilib repository. this repo is only valid for 64-bit systems

i can't mount devices!
did you `sudo pacman -Syu` and install kernel updates? don't do that...
necessary modules won't reload until you reboot, and rebooting will remove your updates.
upgrade qblive by following the instructions above

capslock is broken!
no it isn't. capslock is *fixed* -- meaning it has been turned into an additional ctrl key :-)

