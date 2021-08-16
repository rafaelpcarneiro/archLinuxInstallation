#!/bin/bash
# vim: set foldmethod=marker:

# |-- Configuring my user account {{{1
echo ""
str="--> Configuring my user account"
echo -e $_red $str $_close_color

ln -s /media/pendrive ~/pendrive
ln -s /media/cdrom    ~/cdrom

mkdir -p ~/.config/i3
rm ~/.bashrc

ln ~/arch_i3_config_files/dotfiles/bashrc      ~/.bashrc
ln ~/arch_i3_config_files/dotfiles/vimrc       ~/.vimrc
ln ~/arch_i3_config_files/dotfiles/xsession    ~/.xsession
ln ~/arch_i3_config_files/dotfiles/Xresources  ~/.Xresources
ln ~/arch_i3_config_files/dotfiles/i3config    ~/.config/i3/config
echo -e $_red "DONE" $_close_color
sleep 5
# END Configuring my user account 1}}}



echo "Finishing the script"
for i in {1..10..1}
do
	printf "."
done

echo "Now you can reboot and start the brand-new system"


