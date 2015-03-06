#!/bin/bash

QBL_LABEL="ARCH_$(date +%Y%m)"
QBL_FILEPATH="/qblive.iso"
QBL_DEVICE="/dev/disk/by-label/qblive"

output_file="grub.cfg"
if [[ -f "$output_file" ]]; then
	read -p "overwrite existing? (y/n)" inpt
	if [[ "$inpt" != "y" ]]; then 
		echo "cancelling"
		exit
	fi
fi

cat<<EOF > $output_file
set timeout=-1
set default=0
EOF


for arch in x86_64 i686; do
	cat<<-EOF >> $output_file
		menuentry "QBLive ($arch)" {
		 set isofile="$QBL_FILEPATH"
		 set isolabel="$QBL_LABEL"
		 set imgdevice="$QBL_DEVICE"
		 loopback loop \$isofile
		 linux (loop)/arch/boot/$arch/vmlinuz archisolabel=\$isolabel img_dev=\$imgdevice img_loop=\$isofile earlymodules=loop
		 initrd (loop)/arch/boot/$arch/archiso.img
		}
	EOF
done

cat<<EOF >>$output_file
menuentry "Shutdown" {
 echo "shutting down..."
 halt
}

menuentry "Reboot" {
 echo "rebooting..."
 reboot
}
EOF

