#!/usr/bin/bash

# Monocle IT Solutions rev. 2021100203
#
# batt.sh
#
# Tested on Archlinux 2021.10.01 x86_64 (Kernel: 5.14.8)
# Script should be run manually from the terminal. Outputs battery status and capacity on demand in a clean at-a-glance format.
# Suggest adding 'batt' alias to .bashrc

battnum=`cat /sys/class/power_supply/BAT0/capacity`
battchargestate=`cat /sys/class/power_supply/BAT0/status`

red='\e[0;31m'
green='\e[0;32m'
normal='\e[0m'

if [ ${battchargestate} == "Charging" ]
then
	status="Charging";
	echo -n -e "\nBattery Capacity: $battnum%$green >>>$normal "
	echo -e "$status \n"
else
	if [ ${battchargestate} == "Discharging" ]
	then
		status="Discharging";
		echo -n -e "\nBattery Capacity: $battnum%$red <<<$normal "
		echo -e "$status \n"
	else
		status="Full";
		echo -n -e "\nBattery Capacity: $battnum%$green !!!$normal "
		echo -e "$status \n"
	fi
fi

exit 0
