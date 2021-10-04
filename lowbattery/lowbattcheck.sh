#!/usr/bin/bash

# Monocle IT Solutions rev. 2021100203
#
# lowbattcheck.sh
#
# Tested on Archlinux 2021.10.01 x86_64 (Kernel: 5.14.8)
# Script should be run from root's cron or a systemd timer on a 5 minute repeat. Notifies the terminal when your battery is running low.

battnum=`cat /sys/class/power_supply/BAT0/capacity`

red='\e[0;31m'
green='\e[0;32m'
normal='\e[0m'

if [ ${battnum} > "15" ]
then
	echo -n -e "\n$red!!!$normal Connect Power Cable$red !!!$normal \n\n" | wall -n
	aplay --buffer-size=10 -q ~/Scripts/lowbattery.wav
	exit 0
else
	exit 0
fi
