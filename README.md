QBLive
======

Description
-----------

This project contains my working environment. Archiso is used to build a custom iso with all the packages and configuration files I expect to find.

The iso is nonpersistent, so changes made will be reverted by rebooting. This keeps my development environment clean and honest about dependencies.

A second partition is automatically mounted for persisting data, such as a paccache and project files.

Creating 


Creating QBLive Device
----------------------

Partition the device with two partitions; one to hold the iso and boot loader (grub2), the other for persistent data. Label these partitions `qblive` and `qbpersist`, respectively.
* first partition recommended 2+GB

* Build the iso with the `mkiso.sh` script.

* Install grub2 to the device.

    #make mountpoint & mount partition
    sudo mkdir /mnt/qbl
    sudo mount -L qblive /mnt/qbl
    #install grub
    #note: the --force flag should only be needed if installing to a usb drive; real hard drives can omit it
	#note: this assumes you're targeting the device at /dev/sdc. change as appropriate
    sudo grub-install --force --no-floppy --boot-directory=/mnt/qbl/boot /dev/sdc

* Copy the iso onto the qblive partition

    #note: use the correct source file name...
    sudo cp releng/out/archlinux-2014.07.04-dual.iso /mnt/qbl/qblive.iso

* Generate and copy grub config to the device

    #generate grub config:
    ./gen_grubcfg.sh
    #copy to device
    sudo cp grub.cfg /mnt/qbl/boot/grub/grub.cfg

* Unmount and boot the device

    sudo umount /mnt/qbl
    sudo reboot

Troubleshooting
---------------
The gizmo boots to a blank screen with a blinking cursor instead of showing grub menu

Install grub to the device (/dev/sdc), not the partition (/dev/sdc1)


Device Label not found, waiting 30 seconds... / try to fix the problem manually.

This may happen with either the qblive partition or the iso itself.

* with the `qblive` partition, once dropped into the shell to fix the problem manually, the device was recognized, the /dev/disk/by-label/qblive simlink was created automatically, and everything worked after exiting the shell

* with the `ARCH_201407` error, check that the grub.cfg file has the correct archisolabel flag (discover the iso's actual label by installing isotools (`sudo pacman -Sy cdrkit`) and running `isoinfo -d -i /dev/qbl/qblive.iso | grep 'Volume id'`


