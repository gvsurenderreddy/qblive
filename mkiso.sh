#!/bin/bash

#recreate the entire thing every time.
#otherwise "run once" in the build.sh script gets all confused and nothing actually happens.

if [[ -d releng ]]; then
	echo "kill the old one first"
	exit 1
fi

echo "need sudo..."
sudo echo "got it"

#copy the provided archiso config
sudo cp -r /usr/share/archiso/configs/releng/ .

#overwrite default package list with our custom list
sudo cp packages.both releng
sudo cp packages.x86_64 releng

#move in custom config files
sudo cp -r etc/* releng/airootfs/etc
sudo cp -r root/* releng/airootfs/root

#copy in pacman conf that lists local custom repo
sudo cp pacman.conf releng/pacman.conf

#create the persistent mountpoint
sudo mkdir -p "releng/root-image/mnt/persist"

#cd to releng so generated directories out & work are contained.
pushd releng
sudo ./build.sh -v 
popd

