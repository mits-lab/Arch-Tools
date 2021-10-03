#!/usr/bin/bash

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
