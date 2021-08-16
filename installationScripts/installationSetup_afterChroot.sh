#!/bin/bash
# vim: set foldmethod=marker:

pacman -Syy

# |-- Configuring the system {{{1
echo ""
str="--> Configuring the system"
echo -e $_red $str $_close_color

## Region and Time
echo ""
str="Region and time"
echo -e $_red $str $_close_color
ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

hwclock --systohc
echo -e $_red "DONE" $_close_color
sleep 5

## locale variables
echo ""
str="Locale"
echo -e $_red $str $_close_color
cp conf.d/locale.gen    -t /etc
locale-gen
cp conf.d/locale.conf   -t /etc
cp conf.d/vconsole.conf -t /etc
echo -e $_red "DONE" $_close_color
sleep 5

## Internet
echo ""
str="Hostname and host"
echo -e $_red $str $_close_color
cp conf.d/hostname      -t /etc
cp conf.d/hosts         -t /etc
echo -e $_red "DONE" $_close_color
sleep 5

## password for root
echo ""
echo -e $_red "ROOT password" $_close_color
passwd
echo -e $_red "DONE" $_close_color
sleep 5

## Creating rafael user
echo ""
echo -e $_red "creating user and setting passwd" $_close_color
useradd -m -U rafael
passwd rafael
echo -e $_red "DONE" $_close_color
sleep 5


## Mounting places for usb sticks and cdrom
echo ""
echo -e $_red "Mounting places for usb sticks and cdrom" $_close_color
mkdir -p /media/pendrive
mkdir -p /media/cdrom

chown -R rafael: /media/pendrive
chown -R rafael: /media/cdrom
echo -e $_red "DONE" $_close_color
sleep 5
# END Configuring the system 1}}}

# |-- Installing all packages that I will use {{{1
echo ""
str="--> Installing packages"
echo -e $_red $str $_close_color

pacman -S --noconfirm grub intel-ucode os-prober
pacman -S --noconfirm iwd dhcpcd systemd firewalld firejail
pacman -S --noconfirm vim
pacman -S --noconfirm i3 xorg xdm-archlinux i3status ttf-dejavu
pacman -S --noconfirm rxvt-unicode bash-completion
pacman -S --noconfirm firefox polkit
pacman -S --noconfirm pulseaudio pavucontrol xbindkeys
pacman -S --noconfirm xorg-xrandr arandr
pacman -S --noconfirm tlp tlp-rdw ethtool smartmontools
pacman -S --noconfirm git openssh xclip
pacman -S --noconfirm sqlite3 perl-dbi
pacman -S --noconfirm texlive-core texlive-latexextra 
pacman -S --noconfirm gnuplot octave graphviz
pacman -S --noconfirm ghc #haskell 				
pacman -S --noconfirm mutt
pacman -S --noconfirm mupdf feh imagemagick screenfetch
pacman -S --noconfirm screenfetch
pacman -S --noconfirm mplayer mencoder 
pacman -S --noconfirm warpinator
pacman -S --noconfirm gsl cmake
pacman -S --noconfirm --needed base-devel git 

echo -e $_red "DONE" $_close_color
sleep 5
# END Installing all packages that I will use 1}}}

# |-- Enabling services and setting their configs {{{1
echo ""
str="--> Enabling Services"
echo -e $_red $str $_close_color

systemctl enable iwd 
systemctl enable systemd-resolved
systemctl enable firewalld
systemctl enable xdm-archlinux
systemctl enable tlp

mkdir -p /etc/iwd
cp conf.d/iwd_main.conf -t /etc/iwd/
mv /etc/iwd/iwd_main.conf  /etc/iwd/main.conf 
echo -e $_red "DONE" $_close_color
sleep 5
# END Enabling services 1}}}

# |-- Grub for bios legact {{{1
echo ""
str="--> Installing Grub"
echo -e $_red $str $_close_color

grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

cat conf.d/40_custom >> /etc/grub.d/40_custom
# END Grub 1}}}


echo "Finishing the script"
for i in {1..10..1}
do
	printf "."
done

echo "Now run the script as the user rafael"
cp -r /arch_i3_config_files -t /home/rafael
rm -rf /arch_i3_config_files

chown -R rafael: /home/rafael/arch_i3_config_files
su - rafael

