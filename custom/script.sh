#!/bin/bash

#warning. rough script.
#will not tolerate execution from alternative directories, no error checking, etc.

mkdir x86_64
mkdir i686 #note, since we're building on a 64bit system, this will be empty.
#package will be unavailable on 32bit builds, so only include in packages.x86_64

##download tar.gz from AUR
#unpack it:
tar -xzf broadcom-wl-dkms.tar.gz
pushd broadcom-wl-dkms
makepkg -s #-s resolves dependencies, but still, include them in packages.x86_64
popd
cp broadcom-wl-dkms/*.pkg.tar.xz x86_64
repo-add x86_64/custom.db.tar.gz x86_64/*.pkg.tar.xz


