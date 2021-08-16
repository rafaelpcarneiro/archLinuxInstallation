#!/bin/bash
# vim: set foldmethod=marker:

# |-- Variables {{{1
_red="\e[0;31m"
_close_color="\e[m"

tmp=""
str=""
checkConnection=""

netInterface=$1
netPass=$2
# END Variables 1}}}

# |-- Set keyboard br thinkpad {{{1
str="--> Inserting correct keyboard layout to my thinkpad from Brazil"
echo -e $_red $str $_close_color
cp conf.d/br-abnt2-thinkpad.map.gz -t /usr/share/kbd/keymaps/i386/qwerty
loadkeys br-abnt2-thinkpad
echo -e $_red "DONE" $_close_color
sleep 5
# END Set keyboard br thinkpad 1}}}

# |-- Connecting with internet {{{1
echo ""
str="--> Connecting with internet. You will have to insert your authentication"
echo -e $_red $str $_close_color


iwctl --passphrase $netPass station wlan0 connect $netInterface 
printf "Connecting  "
for i in {1..10..1} 
do
	printf "."
	sleep 1
done

checkConnection=`ip a|grep -o -P "inet.*wlan0"`

if [ -n "$checkConnection" ]
then 
	echo "Connected"
	tmp=`echo "$checkConnection"|grep -o -P "[^\w][\d./]*"|grep "/"`
	echo "Ip = $tmp"
else
	echo "Problems to connect with Internet."
	echo "Aborting scipt"
	break
fi
echo -e $_red "DONE" $_close_color
sleep 5
# END Connecting with internet 1}}}

# TODO set the filesystem with a script sfdisk
# Now I will just use what I've configured


# |-- Formatting the partitions and mounting on /mnt {{{1
echo ""
str="--> Formatting the partitions, mounting to /mnt, pacstrap and arch-chroot"
echo -e $_red $str $_close_color

echo -e $_red "make fs" $_close_color
mkfs.ext4 /dev/sda2
mkswap /dev/sda3
echo -e $_red "DONE" $_close_color
sleep 5

echo -e $_red "mounting partitions" $_close_color
mount /dev/sda2 /mnt
swapon /dev/sda3
echo -e $_red "DONE" $_close_color
sleep 5

echo -e $_red "Pacstrap" $_close_color
pacstrap /mnt base linux linux-firmware
echo -e $_red "DONE" $_close_color
sleep 5

echo -e $_red "fstab" $_close_color
genfstab -U /mnt    >> /mnt/etc/fstab
cat conf.d/my_fstab >> /mnt/etc/fstab
echo -e $_red "DONE" $_close_color
sleep 5

echo -e $_red "arch-chroot" $_close_color
cp -r /arch_i3_config_files /mnt/
arch-chroot /mnt
echo -e $_red "DONE" $_close_color
sleep 5
# END Formatting the partitions and mounting on /mnt 1}}}

