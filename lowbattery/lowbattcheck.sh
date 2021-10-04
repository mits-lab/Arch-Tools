#!/usr/bin/bash

# Monocle IT Solutions rev. 2021100408
#
# lowbattcheck.sh
#
# Tested on Archlinux 2021.10.01 x86_64 (Kernel: 5.14.8)
# Script should be run from root's cron or a systemd timer on a 5 minute repeat. Notifies the terminal when your battery is running low.
#
#
# The MIT License (MIT)
# 
# Copyright (c) 2021 Monocle IT Solutions/lowbattcheck.sh
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
battstatus=`cat /sys/class/power_supply/BAT0/status`

if [[ ${battnum} -lt "15" && ${battstatus} == "Discharging" ]]
then
	echo -n -e "\n\n\t\t!!!   Connect Power Cable   !!! \n\n" | wall -n
	aplay --buffer-size=10 -q ./lowbattery.wav
else
fi
	exit 0
