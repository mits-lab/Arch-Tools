#!/usr/bin/bash

battnum=`cat /sys/class/power_supply/BAT0/capacity`

red='\e[0;31m'
green='\e[0;32m'
normal='\e[0m'

if [ ${battnum} > "15" ]
then
	echo -n -e "\n$red!!!$normal Connect Power Cable$red !!!$normal \n\n"
	aplay --buffer-size=10 -q ~/Scripts/lowbattery.wav
	exit 0
else
	exit 0
fi
