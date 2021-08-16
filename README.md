# Steps to install Arch Linux on my Thinkpad T400

## 1. Partitioning the disk, setting a file system and instaling its core

I can do the installation procedure by the steps down below or I can use
the installationScripts.



### 1.1 The correct keyboard layout

Unfortunately, the standard keyboard layouts, namely br-abnt2, it
doesn't seem to detect properly the key "/" on my pt-br keyboard whenever
I am working on the TTY. That is easy to fix, I just need to change a
couple of values on the file responsible for the br-abnt2 layout. The
layout can be found at

```
/usr/share/kbd/keymaps/i386/qwerty/br-abnt2.map.gz
```

which I change the *keycode 89 = slash question degree* for 
*keycode 97 = slash question degree*.

Then, I just need to do the following to get it working nicely

> cp conf.d/br-abnt2-thinkpad.map.gz -t /usr/share/kbd/keymaps/i386/qwerty
>
> loadkeys br-abnt2-thinkpad


### 1.2 Connect with the internet

The comand 

> iwctl

is quite easy to use it.


### 1.3 Formatting the disk and choosing the file system

Again, nothing difficult to do.

> fdisk -f

to list all disks or

> lsblk -f

In my case

> fdisk /dev/sda

and then just need to set the partitions. Since I am booting using the
Legacy system, I need to create a partition of **1MB** (if I recall it
properly) with a **boot flag**. The other partitions, sda2 and sda3,
just procedure as usual.

**Important**: set the GPT table, right at the beggining of this
process.

Finally, it is necessary to set the file system. Piece of cake:

> mkfs.ext4 /dev/sda2                                                              
>
> mkswap /dev/sda3


### 1.4 Mounting the partitions created and installing the core system

> mount /dev/sda2 /mnt
>
> swapon /dev/sda3

and installing the core system

> pacstrap /mnt base linux linux-firmware

Now the table of the partitions must be declared at the file **fstab**

> genfstab -U /mnt  >> /mnt/etc/fstab                                            

which I also insert instructions allowing me to mount a flash disk and
the cdrom without being root

> cat conf.d/my_fstab >> /mnt/etc/fstab

**Now i is time to play with the system**

> arch-chroot /mnt


## 2. After arch-chroot

Update the system

> pacman -Syu


### 2.1 Configuring the system

**Region and Time**

> ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
>
> hwclock --systohc

**locale variables**

> cp conf.d/locale.gen    -t /etc                                                  
>
> locale-gen                                                                       
>
> cp conf.d/locale.conf   -t /etc                                                  
>
> cp conf.d/vconsole.conf -t /etc 

**Internet - hostname and host**

> cp conf.d/hostname      -t /etc
>
> cp conf.d/hosts         -t /etc

**password for root**

> passwd

**Creating user rafael**

> useradd -m -U rafael
>
> passwd rafael

**Mounting places for usb sticks and cdrom**

> mkdir -p /media/pendrive
>
> mkdir -p /media/cdrom
>
> chown -R rafael: /media/pendrive
>
> chown -R rafael: /media/cdrom

### 2.2 Installing all packages

> pacman -S  grub intel-ucode os-prober
>
> pacman -S  iwd dhcpcd systemd firewalld firejail
>
> pacman -S  vim
>
> pacman -S  i3 xorg xdm-archlinux i3blocks ttf-dejavu
>
> pacman -S  rxvt-unicode bash-completion
>
> pacman -S  firefox polkit
>
> pacman -S  pulseaudio pavucontrol xbindkeys
>
> pacman -S  xorg-xrandr arandr
>
> pacman -S  tlp tlp-rdw ethtool smartmontools
>
> pacman -S  git openssh xclip
>
> pacman -S  sqlite3 perl-dbi
>
> pacman -S  texlive-core texlive-latexextra
>
> pacman -S  gnuplot octave graphviz
>
> pacman -S  ghc #haskell
>
> pacman -S  mutt
>
> pacman -S  mupdf feh imagemagick                           
>
> pacman -S  screenfetch                                                
>
> pacman -S  mplayer mencoder                                           
>
> pacman -S  gsl cmake                                                  
>
> pacman -S  --needed base-devel gi



### 2.3 Enabling Services

> systemctl enable iwd
>
> systemctl enable systemd-resolved
>
> systemctl enable firewalld
>
> systemctl enable xdm-archlinux
>
> systemctl enable tlp

> mkdir -p /etc/iwd                                                                
>
> cp conf.d/iwd_main.conf -t /etc/iwd/                                             
>
> mv /etc/iwd/iwd_main.conf  /etc/iwd/main.conf           

### 2.4 Grub for bios legacy

> grub-install --target=i386-pc /dev/sda
>
> grub-mkconfig -o /boot/grub/grub.cfg

The line below is a file which tells grub that I also have a freebsd on
my HD

> cat conf.d/40_custom >> /etc/grub.d/40_custom

# 3. Configurations at the user level

> ln -s /media/pendrive ~/pendrive                                                    
>
> ln -s /media/cdrom    ~/cdrom                                                       
                                                                                      
> mkdir -p ~/.config/i3                                                               
>
> rm ~/.bashrc                                                                        
                                                                                    
> git clone https://github.com/rafaelpcarneiro/dotfiles.git
>
> ln ~/dotfiles/bashrc        ~/.bashrc                            
>
> ln ~/dotfiles/vimrc         ~/.vimrc                             
>
> ln ~/dotfiles/xsession      ~/.xsession                       
>
> ln ~/dotfiles/Xresources    ~/.Xresources                     
>
> ln ~/dotfiles/i3config      ~/.config/i3/config 
>
> ln ~/dotfiles/i3blocks.conf ~/.i3blocks.conf
