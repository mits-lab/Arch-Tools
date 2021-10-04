#!/usr/bin/bash

# Monocle IT Solutions rev. 2021100203
#
# batt.sh
#
# Tested on Archlinux 2021.10.01 x86_64 (Kernel: 5.14.8)
# Script should be run manually from the terminal. Outputs battery status and capacity on demand in a clean at-a-glance format.
# Suggest adding 'batt' alias to .bashrc
#
#
# The MIT License (MIT)
# 
# Copyright (c) 2021 Monocle IT Solutions/batt.sh
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

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
