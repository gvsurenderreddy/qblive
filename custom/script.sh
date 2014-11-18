#!/bin/bash

#warning. rough script.
#will not tolerate execution from alternative directories, no error checking, no cleanup

mkdir x86_64

##download tar.gz from AUR
wget https://aur.archlinux.org/packages/br/broadcom-wl-dkms/broadcom-wl-dkms.tar.gz
#unpack it:
tar -xzf broadcom-wl-dkms.tar.gz
pushd broadcom-wl-dkms
makepkg -s #-s resolves dependencies, but still, include them in packages.x86_64
popd
cp broadcom-wl-dkms/*.pkg.tar.xz x86_64
repo-add x86_64/custom.db.tar.gz x86_64/*.pkg.tar.xz


