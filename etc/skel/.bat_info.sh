#!/bin/bash

percent="$(acpi | cut -d, -f2)"
stat="$(acpi | awk '{print $3}')"
status_icon='.'
if [[ "$stat" == "Charging," ]]; then
	status_icon='+'
elif [[ "$stat" == "Discharging," ]]; then
	status_icon='-'
fi
echo "$percent$status_icon"

