#!/usr/bin/bash

## Monocle IT Solutions Labs ##
## Server Baseline - Mount SMB via fstab ##
## smb-fstab-mount.sh
## Rev. 2022051509 ##

# Tested on Archlinux April 2022 x86_64 (archlinux-2022.03.01-x86_64.iso) connecting to a FreeNAS smb share.
#
# !!! CONNECT TO THE NETWORK BEFORE EXECUTING THIS SCRIPT !!!
#
# Script should be executed from Arch Linux terminal as the root user.
# 
# Script updates system fstab with your desired SMB mounts. Meant to be run after the configuration script completes, however can be run at any time.
#
# The MIT License (MIT)
# 
# Copyright (c) 2022 Monocle IT Solutions/smb-fstab-mount.sh
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

# standard alpha numeric user name
# password should include letter numbers and special character

cyan='\e[0;36m'
normal='\e[0m' # No Color / turn off colored text
bold=`tput bold`
normal=`tput sgr0`

# vars in use

# ${_smbserver}   - server domain or ip
# ${_smbshare}    - name of the smb share
# ${_smbmountdir} - name of directory under /mnt where the share will be mounted. Try to make this unique from any existing directory that may exist.
# ${_smbuser}     - smb username to connect to share
# ${_smbpassword} - smb password to connect to share
# ${_smbuid}      - set user for smb connection
# ${_smbgid}      - set group for smb connection (should match gid of smb server's dataset group)

# run as root user check.

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 69
fi

# Samba package installation check

if [[ -z `find /usr/sbin/ -executable -name smbd` ]]
then
	echo -n -e "\n\nSamba may be missing. Install the package and try again\n"
	exit 69
else
	echo -n -e "\n\nSamba is installed. Proceeding.. \n"
fi

# Present splash and request input.

clear

echo -n -e "\nMITS - Arch System - SMB automount via fstab\n"
echo -n -e "$cyan--------------------------------------------- $normal\n\n"

echo -n -e "Enter the SMB server's domain or ip.\n"
echo -n -e "SMB Server: "
read _smbserver
echo -n -e "\n"

echo -n -e "Enter the SMB share name.\n"
echo -n -e "SMB Share: "
read _smbshare
echo -n -e "\n"

echo -n -e "Name of directory under /mnt on your system where the share will be mounted.\n"
echo -n -e "Local directory name: "
read _smbmountdir
echo -n -e "\n"

echo -n -e "Enter the smb username to connect to share.\n"
echo -n -e "user: "
read _smbuser
echo -n -e "\n"

echo -n -e "Enter the smb password to connect to share.\n"
echo -n -e "password: "
read -s _smbpassword
echo -n -e "\n\n"

echo -n -e "Enter the SMB UID (user) name or number to assign to the share. This should match the dataset permissions on the SMB server.\n"
echo -n -e "SMB uid: "
read _smbuid
echo -n -e "\n"

echo -n -e "Enter the SMB GID (group) name or number to assign to the share. This should match the dataset permissions on the SMB server.\n"
echo -n -e "SMB gid: "
read _smbgid
echo -n -e "\n"

# ensure values for exist for each critical variable is specified, otherwise exit script.

if [ -z "$_smbserver" ]; then
    echo -n -e "\nMissing USER variable...exiting\n"
    exit 69
fi
if [ -z "$_smbshare" ]; then
    echo -n -e "\nMissing PASSWORD variable...exiting\n"
    exit 69
fi
if [ -z "$_smbmountdir" ]; then
    echo -n -e "\nMissing USER variable...exiting\n"
    exit 69
fi
if [ -z "$_smbuser" ]; then
    echo -n -e "\nMissing USER variable...exiting\n"
    exit 69
fi
if [ -z "$_smbpassword" ]; then
    echo -n -e "\nMissing PASSWORD variable...exiting\n"
    exit 69
fi
if [ -z "$_smbuid" ]; then
    echo -n -e "\nMissing user uid variable...exiting\n"
    exit 69
fi
if [ -z "$_smbgid" ]; then
    echo -n -e "\nMissing group gid variable...exiting\n"
    exit 69
fi

echo -n -e "\nWe have all the information to begin. Beginning fstab configuration.."

# create credentials file in root directory.

cat > /root/.smbcredentials <<EOL
username=${_smbuser}
password=${_smbpassword}
EOL

chmod 600 /root/.smbcredentials

# Create local directory to mount to.

mkdir -p /mnt/${_smbmountdir}

# apply mount string to fstab

cat >> /etc/fstab <<EOL
# Added smb share with linux-mount-smb-fstab.sh script. Credentials in '/root/.smbcredentials' file.
//${_smbserver}/${_smbshare}		/mnt/${_smbmountdir}		auto		_netdev,credentials=/root/.smbcredentials,,uid=${_smbuid},gid=${_smbgid},iocharset=utf8,rw 0 0
EOL

echo -n -e ".$cyan Complete$normal \n\n"

echo -n -e "\nWould you like to reboot your PC to test the mount? Otherwise the script will attempt to mount the smb share without rebooting.\n\n"

read -p "  Reboot now?(y/n) " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo -n -e "\n\n"
else
	echo -n -e "\n\nRebooting.. \n"
	reboot
	exit 0
fi

# attempt to mount immediately.

mount -a

exit 0
