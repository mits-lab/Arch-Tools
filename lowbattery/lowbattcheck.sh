#!/usr/bin/bash

# Monocle IT Solutions rev. 2021100203
#
# lowbattcheck.sh
#
# Tested on Archlinux 2021.10.01 x86_64 (Kernel: 5.14.8)
# Script should be run from root's cron or a systemd timer on a 5 minute repeat. Notifies the terminal when your battery is running low.

battnum=`cat /sys/class/power_supply/BAT0/capacity`
battstatus=`cat /sys/class/power_supply/BAT0/status`

if [[ ${battnum} > "15" && ${battstatus} == "Discharging" ]]
then
	echo -n -e "\n\n\t\t!!!   Connect Power Cable   !!! \n\n" | wall -n
	aplay --buffer-size=10 -q ~/Scripts/lowbattery.wav
	exit 0
else
	exit 0
fi
