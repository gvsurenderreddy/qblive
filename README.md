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

+ first partition recommended 2+GB

+ Build the iso with the `mkiso.sh` script.

+ Install grub2 to the device.

    #make mountpoint & mount partition
    sudo mkdir /mnt/qbl
    sudo mount -L qblive /mnt/qbl
    #install grub
    #note: the --force flag should only be needed if installing to a usb drive; real hard drives can omit it
	#note: this assumes you're targeting the device at /dev/sdc. change as appropriate
    sudo grub-install --force --no-floppy --boot-directory=/mnt/qbl/boot /dev/sdc

+ Copy the iso onto the qblive partition

    #note: use the correct source file name...
    sudo cp releng/out/archlinux-2014.07.04-dual.iso /mnt/qbl/qblive.iso

+ Generate and copy grub config to the device

    #generate grub config:
    ./gen_grubcfg.sh
    #copy to device
    sudo cp grub.cfg /mnt/qbl/boot/grub/grub.cfg

+ Unmount and boot the device

    sudo umount /mnt/qbl
    sudo reboot

Troubleshooting
---------------

The gizmo boots to a blank screen with a blinking cursor instead of showing grub menu

Install grub to the device (/dev/sdc), not the partition (/dev/sdc1)


> Waiting 30 seconds for device /dev/disk/by-label/qblive ...
> ERROR: `/dev/disk/by-label/qblive` device did not show up after 30 seconds...
> Falling back to interactive prompt
> You can try to fix the problem manually, log out when you are finished

with the `qblive` partition, once dropped into the shell to fix the problem manually the device was recognized, and the /dev/disk/by-label/qblive simlink was created automatically. everything worked normally after exiting the shell

> ERROR: /dev/disk/by-label/ARCH_201407 device did not show up after 30 seconds...

check that the grub.cfg file has the correct archisolabel flag (discover the iso's actual label by installing isotools (`sudo pacman -Sy cdrkit`) and running `isoinfo -d -i /dev/qbl/qblive.iso | grep 'Volume id'`
the correct label will be ARCH_YYYYMM from the date the image is generated
