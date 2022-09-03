#!/bin/sh
#Phase 1

echo "This script/command must be run directly as root user not via sudo. (ie: entering sudo -i first)"
echo "If you have not ran as root user, please exit now, root, and run again."


echo "Set your Username."
read user00
user01=$user00

echo "Set your drive ('nvmeXn1 or sdX')"
read drive
pfx="/dev/"
drive0=$pfx$drive

echo "Set your Boot Partition ('p1 or 1')."
read boot
boot0=$drive0$boot

echo "Set your Swap Partition ('p2 or 2')."
read swap
swap0=$drive0$swap

echo "Set your System/Home Partition ('p3 or 3')."
read system
system0=$drive0$system

echo "What dektop environment would you like? ('gnome, kde, or cinnamon (case-sensitive)')."
read desktopenvironment
desktop0=$desktopenvironment

if [ $desktop0 != 'gnome' ] || [ $desktop0 != 'kde' ] || [ $desktop0 != 'cinnamon' ]
then
echo 'Desktop check failed, Aborting now...' && exit
elif [ $desktop0 == 'gnome' ]
then
#
echo 'Starting Gnome version install'
echo 'Partition the Disk' && 
fdisk $drive0 && 
#partitionthedisk && 
echo 'Formatting Partitions' && 
mkfs.fat -F32 $boot0 && 
mkswap $swap0 && 
mkfs.btrfs -L CoffeePot $system0 && 
echo 'Mounting Disks' && 
swapon $swap0 && 
mount $system0 /mnt && 
mkdir /mnt/boot && 
mount $boot0 /mnt/boot
echo 'Enable Repos' &&
nano /etc/pacman.conf && 
pacman -Sy && 
pacman -Sy --noconfirm archlinux-keyring && 
echo 'Installing Kernel Frameworks' && 
pacman -Syy && 
pacman -Sy --noconfirm archlinux-keyring && 
pacstrap /mnt base intel-ucode linux linux-firmware linux-headers btrfs-progs net-tools networkmanager dhcpcd iwd man-pages man-db texinfo && 
#cp --dereference coffeelinux/opt/os-release /mnt/etc/ && 
echo 'Installing Gnome' && 
arch-chroot /mnt /bin/bash <<"EOT"
echo 'Setting Locale' && 
#read -n 1 -s -r -p "Press any key to continue" &&
ln -sf ../usr/share/zoneinfo/America/Los_Angeles /etc/localtime && 
hwclock --systohc && 
echo 'en_US ISO-8859-1' >> /etc/locale.gen && 
echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && 
echo 'KEYMAP=us' > /etc/vconsole.conf && 
echo 'LANG=en_US.UTF-8' > /etc/locale.conf && 
export LANG=en_US.UTF-8 && 
locale-gen &&  
echo 'Setting Hostname' && 
#read -n 1 -s -r -p "Press any key to continue" &&
echo 'Coffee-Linux' > /etc/hostname && 
echo '127.0.0.1 localhost' >> /etc/hosts && 
echo '::1 localhost' >> /etc/hosts && 
echo '127.0.1.1 Coffee-Linux' >> /etc/hosts && 
echo $$
EOT
#
arch-chroot /mnt pacman -Sy sudo nano git base-devel dkms xed xreader vlc udev dbus gstreamer systemd ntp gst-libav gst-plugins-base gst-plugins-good gst-plugins-ugly gst-plugins-bad gtk4 gdm gnome gnome-extra &&  
echo 'Creating Links' && 
genfstab -U /mnt >> /mnt/etc/fstab &&
echo 'Set Root Password' && 
arch-chroot /mnt passwd && 
echo 'Adding User Account' && 
arch-chroot /mnt useradd -m -G wheel,audio,video,power,users,storage --badname $user01 && 
echo 'Set User Password' && 
arch-chroot /mnt passwd $user01 
echo 'Set Temporary User Password' && 
arch-chroot /mnt useradd -m -G wheel,audio,video,power,users,storage --badname user02 && 
arch-chroot /mnt passwd user02 && 
#Phase 2
echo 'Setting repos in new destination' &&
arch-chroot /mnt pacman -Syy &&
arch-chroot /mnt pacman -Sy --noconfirm archlinux-keyring &&
cp /etc/pacman.conf /mnt/etc/pacman.conf && 
cp --dereference /etc/resolv.conf /mnt/etc/ &&
arch-chroot /mnt pacman -Syy &&
echo 'Installing a bunch of stuff for gaming and general prettiness.' && 
arch-chroot /mnt pacman -Sy power-profiles-daemon qt6 go meson xorg xorg-server xorg-apps nvidia-dkms virtualbox virtualbox-guest-utils git xdg-utils gettext ufw libva-utils libva-vdpau-driver neofetch wine winetricks lib32-vkd3d vkd3d innoextract giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo libxcomposite lib32-libxcomposite libxinerama lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader jre-openjdk-headless jre-openjdk jdk-openjdk openjdk-doc openjdk-src steam lib32-opencl-nvidia zenity discord gst-plugin-pipewire lib32-pipewire lib32-pipewire-jack pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber firewalld shotwell && 
arch-chroot /mnt archlinux-java set java-18-openjdk && 
#Phase 3
arch-chroot /mnt /bin/bash <<"EOT"
mkdir -p /tmp/arch &&
cd /tmp/arch &&
ls -l && 
cd / &&  
echo '%wheel ALL=(ALL:ALL) ALL' > /etc/sudoers.d/wheel &&
mkinitcpio -P && 
echo Installing Bootloader &&
#read -n 1 -s -r -p "Press any key to continue" &&  
bootctl install && 
echo 'default arch.conf' > /boot/loader/loader.conf && 
echo 'timeout 5' >> /boot/loader/loader.conf && 
echo 'console-mode max' >> /boot/loader/loader.conf && 
echo 'editor no' >> /boot/loader/loader.conf && 
echo 'title Coffee-Linux' > /boot/loader/entries/arch.conf && 
echo 'linux /vmlinuz-linux' >> /boot/loader/entries/arch.conf && 
echo 'initrd /intel-ucode.img' >> /boot/loader/entries/arch.conf && 
echo 'initrd /initramfs-linux.img' >> /boot/loader/entries/arch.conf && 
echo 'options root="LABEL=CoffeePot" rw nvidia-drm.modeset=1' >> /boot/loader/entries/arch.conf && 
echo 'Presetting default services.' && 
#read -n 1 -s -r -p "Press any key to continue" &&
systemctl enable gdm && 
systemctl enable dhcpcd && 
systemctl enable NetworkManager && 
systemctl --global enable pipewire.service pipewire-pulse.service wireplumber.service && 
systemctl enable firewalld
echo $$
EOT
#
echo 'Attempting to fix the home directory automatically now...' && 
arch-chroot /mnt pacman -Sy --noconfirm xdg-user-dirs &&
arch-chroot /mnt xdg-user-dirs-update &&
echo 'Installing yay for AUR support' &&
arch-chroot /mnt /bin/bash <<"EOT"
mkdir -p /tmp/arch/stage2 &&
cd /tmp/arch/stage2 &&
ls -l && 
cd /opt &&
echo "AUR apps installation" &&
sudo -Su user02 sudo git clone https://aur.archlinux.org/yay.git && 
sudo -Su user02 sudo chown -hR user02:users ./yay &&  
cd /opt/yay &&
sudo -Su user02 makepkg -f -s --install --noconfirm --clean
echo $$
EOT
#
echo 'Installing Coffee-QOL-Extras' &&
arch-chroot /mnt userdel user02 &&  
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y pamac-aur && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y libva-vdpau-driver-vp9-git && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y protontricks && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y nvidia-vaapi-driver &&  
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y game-devices-udev &&   
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y google-chrome && 
rm -R /mnt/usr/share/backgrounds/gnome/ && 
mkdir /mnt/usr/share/backgrounds/gnome/ && 
cp coffeelinux/opt/backgrounds/coffee/coffeewall03.jpg /mnt/usr/share/backgrounds/gnome/adwaita-d.jpg && 
cp coffeelinux/opt/backgrounds/coffee/coffeewall05.jpg /mnt/usr/share/backgrounds/gnome/adwaita-l.jpg && 
cp coffeelinux/opt/backgrounds/coffee/coffeewall04.jpg /mnt/usr/share/backgrounds/gnome/libadwaita-l.jpg && 
cp coffeelinux/opt/backgrounds/coffee/coffeewall06.jpg /mnt/usr/share/backgrounds/gnome/libadwaita-d.jpg &&
cp coffeelinux/opt/backgrounds/coffee/coffeewall02.jpg /mnt/usr/share/backgrounds/gnome/disco-l.jpg && 
cp coffeelinux/opt/backgrounds/coffee/coffeewall07.jpg /mnt/usr/share/backgrounds/gnome/disco-d.jpg && 
cp coffeelinux/opt/backgrounds/coffee/coffeewall08.jpg /mnt/usr/share/backgrounds/gnome/wood-l.jpg && 
cp coffeelinux/opt/backgrounds/coffee/coffeewall01.jpg /mnt/usr/share/backgrounds/gnome/wood-d.jpg && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y humanity-icon-theme && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y gnome-shell-extension-ubuntu-dock && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y gnome-shell-extension-impatience && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y gnome-shell-extension-appindicator && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y gnome-shell-extension-user-themes && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y gnome-browser-connector && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y mutter-dynamic-buffering && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y extension-manager &&
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y yaru-gtk-theme && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y yaru-icon-theme && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y yaru-gnome-shell-theme && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y yaru-session && 
rm /mnt/usr/share/xsessions/gnome* && 
echo 'Ensuring correct DM is set.' &&  
arch-chroot /mnt pacman -Syu && 
arch-chroot /mnt systemctl enable gdm && 
echo 'Attempting to fix the home directory automatically now...' && 
arch-chroot /mnt pacman -Sy --noconfirm xdg-user-dirs &&
arch-chroot /mnt xdg-user-dirs-update && 
#
#Phase 5
echo 'Cleaning up' &&
rm -R /mnt/home/user02/ && 
cp coffeelinux/opt/chrome-flags.conf /mnt/home/$user01/.config/ && 
cp coffeelinux/opt/chrome-flags.conf /mnt/opt/ && 
cp coffeelinux/opt/coffeebrewer.sh /mnt/opt/ && 
cp coffeelinux/opt/os-release /mnt/usr/lib/ && 
cp coffeelinux/opt/os-release /mnt/etc/ && 
cp coffeelinux/opt/chrome-pnkcfpnngfokcnnijgkllghjlhkailce-Default.desktop /mnt/opt/ && 
#
echo "Installation Complete, Please Reboot to use your OS." && 
read -n 1 -s -r -p "Press any key to continue" && 
umount -R /mnt &&
reboot
#
elif [ $desktop0 == 'kde' ]
then
echo 'starting KDE version install'
echo 'Partition the Disk' && 
fdisk $drive0 && 
#partitionthedisk && 
echo 'Formatting Partitions' && 
mkfs.fat -F32 $boot0 && 
mkswap $swap0 && 
mkfs.btrfs -L CoffeePot $system0 && 
echo 'Mounting Disks' && 
swapon $swap0 && 
mount $system0 /mnt && 
mkdir /mnt/boot && 
mount $boot0 /mnt/boot
echo 'Enable Repos' &&
nano /etc/pacman.conf && 
pacman -Sy && 
pacman -Sy --noconfirm archlinux-keyring && 
echo 'Installing Kernel Frameworks' && 
pacman -Syy && 
pacman -Sy --noconfirm archlinux-keyring && 
pacstrap /mnt base intel-ucode linux linux-firmware linux-headers btrfs-progs net-tools networkmanager dhcpcd iwd man-pages man-db texinfo && 
#cp --dereference coffeelinux/opt/os-release /mnt/etc/ && 
echo 'Installing KDE' && 
arch-chroot /mnt /bin/bash <<"EOT"
echo 'Setting Locale' && 
#read -n 1 -s -r -p "Press any key to continue" &&
ln -sf ../usr/share/zoneinfo/America/Los_Angeles /etc/localtime && 
hwclock --systohc && 
echo 'en_US ISO-8859-1' >> /etc/locale.gen && 
echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && 
echo 'KEYMAP=us' > /etc/vconsole.conf && 
echo 'LANG=en_US.UTF-8' > /etc/locale.conf && 
export LANG=en_US.UTF-8 && 
locale-gen &&  
echo 'Setting Hostname' && 
#read -n 1 -s -r -p "Press any key to continue" &&
echo 'Coffee-Linux' > /etc/hostname && 
echo '127.0.0.1 localhost' >> /etc/hosts && 
echo '::1 localhost' >> /etc/hosts && 
echo '127.0.1.1 Coffee-Linux' >> /etc/hosts && 
echo $$
EOT
# 
arch-chroot /mnt pacman -Sy qt6 dkms kde-applications-meta sddm plasma-meta sudo nano git base-devel xed xreader vlc udev dbus gstreamer systemd ntp gst-libav gst-plugins-base gst-plugins-good gst-plugins-ugly gst-plugins-bad && 
installthedm && 
echo 'Creating Links' && 
genfstab -U /mnt >> /mnt/etc/fstab &&
echo 'Set Root Password' && 
arch-chroot /mnt passwd && 
echo 'Adding User Account' && 
arch-chroot /mnt useradd -m -G wheel,audio,video,users --badname $user01 && 
echo 'Set User Password' && 
arch-chroot /mnt passwd $user01 
echo 'Set Temporary User Password' && 
arch-chroot /mnt useradd -m -G wheel,audio,video,users --badname user02 && 
arch-chroot /mnt passwd user02 && 
#Phase 2
echo 'Setting repos in new destination' &&
arch-chroot /mnt pacman -Syy &&
arch-chroot /mnt pacman -Sy --noconfirm archlinux-keyring &&
cp /etc/pacman.conf /mnt/etc/pacman.conf && 
cp --dereference /etc/resolv.conf /mnt/etc/ &&
arch-chroot /mnt pacman -Syy &&
echo 'Installing a bunch of stuff for gaming and general prettiness.' && 
arch-chroot /mnt pacman -Sy power-profiles-daemon go meson xorg xorg-server xorg-apps nvidia-dkms virtualbox virtualbox-guest-utils git xdg-utils gettext ufw libva-utils libva-vdpau-driver neofetch wine winetricks lib32-vkd3d vkd3d innoextract giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo libxcomposite lib32-libxcomposite libxinerama lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader jre-openjdk-headless jre-openjdk jdk-openjdk openjdk-doc openjdk-src steam lib32-opencl-nvidia zenity discord gst-plugin-pipewire lib32-pipewire lib32-pipewire-jack pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber firewalld shotwell && 
arch-chroot /mnt archlinux-java set java-18-openjdk && 
#Phase 3
arch-chroot /mnt /bin/bash <<"EOT"
mkdir -p /tmp/arch &&
cd /tmp/arch &&
ls -l && 
cd / &&  
echo '%wheel ALL=(ALL:ALL) ALL' > /etc/sudoers.d/wheel &&
mkinitcpio -P && 
echo Installing Bootloader &&
#read -n 1 -s -r -p "Press any key to continue" &&  
bootctl install && 
echo 'default arch.conf' > /boot/loader/loader.conf && 
echo 'timeout 5' >> /boot/loader/loader.conf && 
echo 'console-mode max' >> /boot/loader/loader.conf && 
echo 'editor no' >> /boot/loader/loader.conf && 
echo 'title Coffee-Linux' > /boot/loader/entries/arch.conf && 
echo 'linux /vmlinuz-linux' >> /boot/loader/entries/arch.conf && 
echo 'initrd /intel-ucode.img' >> /boot/loader/entries/arch.conf && 
echo 'initrd /initramfs-linux.img' >> /boot/loader/entries/arch.conf && 
echo 'options root="LABEL=CoffeePot" rw nvidia-drm.modeset=1' >> /boot/loader/entries/arch.conf && 
echo 'Presetting default services.' && 
#read -n 1 -s -r -p "Press any key to continue" &&
systemctl enable sddm && 
systemctl enable dhcpcd && 
systemctl enable NetworkManager && 
systemctl --global enable pipewire.service pipewire-pulse.service wireplumber.service && 
systemctl enable firewalld
echo $$
EOT
#
echo 'Attempting to fix the home directory automatically now...' && 
arch-chroot /mnt pacman -Sy --noconfirm xdg-user-dirs &&
arch-chroot /mnt xdg-user-dirs-update &&
echo 'Installing yay for AUR support' &&
arch-chroot /mnt /bin/bash <<"EOT"
mkdir -p /tmp/arch/stage2 &&
cd /tmp/arch/stage2 &&
ls -l && 
cd /opt &&
echo "AUR apps installation" &&
sudo -Su user02 sudo git clone https://aur.archlinux.org/yay.git && 
sudo -Su user02 sudo chown -hR user02:users ./yay &&  
cd /opt/yay &&
sudo -Su user02 makepkg -f -s --install --noconfirm --clean
echo $$
EOT
#
echo 'Installing Coffee-QOL-Extras' &&
arch-chroot /mnt userdel user02 &&   
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y libva-vdpau-driver-vp9-git && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y protontricks && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y nvidia-vaapi-driver &&  
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y game-devices-udev &&   
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y google-chrome && 
mkdir /mnt/usr/share/backgrounds/coffee/ && 
cp coffeelinux/opt/backgrounds/coffee/coffeewall03.jpg /mnt/usr/share/backgrounds/coffee/coffeewall01.jpg && 
cp coffeelinux/opt/backgrounds/coffee/coffeewall05.jpg /mnt/usr/share/backgrounds/coffee/coffeewall02.jpg && 
cp coffeelinux/opt/backgrounds/coffee/coffeewall04.jpg /mnt/usr/share/backgrounds/coffee/coffeewall03.jpg && 
cp coffeelinux/opt/backgrounds/coffee/coffeewall06.jpg /mnt/usr/share/backgrounds/coffee/coffeewall04.jpg &&
cp coffeelinux/opt/backgrounds/coffee/coffeewall02.jpg /mnt/usr/share/backgrounds/coffee/coffeewall05.jpg && 
cp coffeelinux/opt/backgrounds/coffee/coffeewall07.jpg /mnt/usr/share/backgrounds/coffee/coffeewall06.jpg && 
cp coffeelinux/opt/backgrounds/coffee/coffeewall08.jpg /mnt/usr/share/backgrounds/coffee/coffeewall07.jpg && 
cp coffeelinux/opt/backgrounds/coffee/coffeewall01.jpg /mnt/usr/share/backgrounds/coffee/coffeewall08.jpg &&  
# 
echo 'Ensuring correct DM is set.' &&  
arch-chroot /mnt pacman -Syu && 
arch-chroot /mnt systemctl enable sddm && 
echo 'Attempting to fix the home directory automatically now...' && 
arch-chroot /mnt pacman -Sy --noconfirm xdg-user-dirs &&
arch-chroot /mnt xdg-user-dirs-update && 
#Phase 5
echo 'Cleaning up' &&
rm -R /mnt/home/user02/ && 
cp coffeelinux/opt/chrome-flags.conf /mnt/home/$user01/.config/ && 
cp coffeelinux/opt/chrome-flags.conf /mnt/opt/ && 
cp coffeelinux/opt/coffeebrewer.sh /mnt/opt/ && 
cp coffeelinux/opt/os-release /mnt/usr/lib/ && 
cp coffeelinux/opt/os-release /mnt/etc/ && 
cp coffeelinux/opt/chrome-pnkcfpnngfokcnnijgkllghjlhkailce-Default.desktop /mnt/opt/ && 
#
echo "Installation Complete, Please Reboot to use your OS." && 
read -n 1 -s -r -p "Press any key to continue" && 
umount -R /mnt &&
reboot
#
elif [ $desktop0 == 'cinnamon' ]
then
echo 'Starting Cinnamon version install'
echo 'Partition the Disk' && 
fdisk $drive0 && 
#partitionthedisk && 
echo 'Formatting Partitions' && 
mkfs.fat -F32 $boot0 && 
mkswap $swap0 && 
mkfs.btrfs -L CoffeePot $system0 && 
echo 'Mounting Disks' && 
swapon $swap0 && 
mount $system0 /mnt && 
mkdir /mnt/boot && 
mount $boot0 /mnt/boot
echo 'Enable Repos' &&
nano /etc/pacman.conf && 
pacman -Sy && 
pacman -Sy --noconfirm archlinux-keyring && 
echo 'Installing Kernel Frameworks' && 
pacman -Syy && 
pacman -Sy --noconfirm archlinux-keyring && 
pacstrap /mnt base intel-ucode linux linux-firmware linux-headers btrfs-progs net-tools networkmanager dhcpcd iwd man-pages man-db texinfo && 
#cp --dereference coffeelinux/opt/os-release /mnt/etc/ && 
echo 'Installing Cinnamon' && 
arch-chroot /mnt /bin/bash <<"EOT"
echo 'Setting Locale' && 
#read -n 1 -s -r -p "Press any key to continue" &&
ln -sf ../usr/share/zoneinfo/America/Los_Angeles /etc/localtime && 
hwclock --systohc && 
echo 'en_US ISO-8859-1' >> /etc/locale.gen && 
echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && 
echo 'KEYMAP=us' > /etc/vconsole.conf && 
echo 'LANG=en_US.UTF-8' > /etc/locale.conf && 
export LANG=en_US.UTF-8 && 
locale-gen &&  
echo 'Setting Hostname' && 
#read -n 1 -s -r -p "Press any key to continue" &&
echo 'Coffee-Linux' > /etc/hostname && 
echo '127.0.0.1 localhost' >> /etc/hosts && 
echo '::1 localhost' >> /etc/hosts && 
echo '127.0.1.1 Coffee-Linux' >> /etc/hosts && 
echo $$
EOT
#
arch-chroot /mnt pacman -Sy sudo nano dkms git base-devel xed xreader vlc udev dbus gstreamer systemd ntp gst-libav gst-plugins-base gst-plugins-good gst-plugins-ugly gst-plugins-bad cinnamon cinnamon-translations gtk4 &&  
echo 'Creating Links' && 
genfstab -U /mnt >> /mnt/etc/fstab &&
echo 'Set Root Password' && 
arch-chroot /mnt passwd && 
echo 'Adding User Account' && 
arch-chroot /mnt useradd -m -G wheel,audio,video,power,users,storage --badname $user01 && 
echo 'Set User Password' && 
arch-chroot /mnt passwd $user01 
echo 'Set Temporary User Password' && 
arch-chroot /mnt useradd -m -G wheel,audio,video,power,users,storage --badname user02 && 
arch-chroot /mnt passwd user02 && 
#Phase 2
echo 'Setting repos in new destination' &&
arch-chroot /mnt pacman -Syy &&
arch-chroot /mnt pacman -Sy --noconfirm archlinux-keyring &&
cp /etc/pacman.conf /mnt/etc/pacman.conf && 
cp --dereference /etc/resolv.conf /mnt/etc/ &&
arch-chroot /mnt pacman -Syy &&
echo 'Installing a bunch of stuff for gaming and general prettiness.' && 
arch-chroot /mnt pacman -Sy lightdm lightdm-gtk-greeter gnome-shell gnome-terminal gnome-system-monitor gnome-keyring polkit-gnome power-profiles-daemon cpupower qt6 go meson xorg xorg-server xorg-apps nvidia-dkms virtualbox virtualbox-guest-utils git xdg-utils gettext ufw libva-utils libva-vdpau-driver neofetch wine winetricks lib32-vkd3d vkd3d innoextract giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo libxcomposite lib32-libxcomposite libxinerama lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader jre-openjdk-headless jre-openjdk jdk-openjdk openjdk-doc openjdk-src steam lib32-opencl-nvidia zenity discord gst-plugin-pipewire lib32-pipewire lib32-pipewire-jack pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber firewalld shotwell && 
arch-chroot /mnt archlinux-java set java-18-openjdk && 
#Phase 3
arch-chroot /mnt /bin/bash <<"EOT"
mkdir -p /tmp/arch &&
cd /tmp/arch &&
ls -l && 
cd / &&  
echo '%wheel ALL=(ALL:ALL) ALL' > /etc/sudoers.d/wheel &&
mkinitcpio -P && 
echo Installing Bootloader &&
#read -n 1 -s -r -p "Press any key to continue" &&  
bootctl install && 
echo 'default arch.conf' > /boot/loader/loader.conf && 
echo 'timeout 5' >> /boot/loader/loader.conf && 
echo 'console-mode max' >> /boot/loader/loader.conf && 
echo 'editor no' >> /boot/loader/loader.conf && 
echo 'title Coffee-Linux' > /boot/loader/entries/arch.conf && 
echo 'linux /vmlinuz-linux' >> /boot/loader/entries/arch.conf && 
echo 'initrd /intel-ucode.img' >> /boot/loader/entries/arch.conf && 
echo 'initrd /initramfs-linux.img' >> /boot/loader/entries/arch.conf && 
echo 'options root="LABEL=CoffeePot" rw nvidia-drm.modeset=1' >> /boot/loader/entries/arch.conf && 
echo 'Presetting default services.' && 
#read -n 1 -s -r -p "Press any key to continue" &&
systemctl enable lightdm && 
systemctl enable dhcpcd && 
systemctl enable NetworkManager && 
systemctl --global enable pipewire.service pipewire-pulse.service wireplumber.service && 
systemctl enable firewalld
echo $$
EOT
#
echo 'Attempting to fix the home directory automatically now...' && 
arch-chroot /mnt pacman -Sy --noconfirm xdg-user-dirs &&
arch-chroot /mnt xdg-user-dirs-update &&
echo 'Installing yay for AUR support' &&
arch-chroot /mnt /bin/bash <<"EOT"
mkdir -p /tmp/arch/stage2 &&
cd /tmp/arch/stage2 &&
ls -l && 
cd /opt &&
echo "AUR apps installation" &&
sudo -Su user02 sudo git clone https://aur.archlinux.org/yay.git && 
sudo -Su user02 sudo chown -hR user02:users ./yay &&  
cd /opt/yay &&
sudo -Su user02 makepkg -f -s --install --noconfirm --clean
echo $$
EOT
#
echo 'Installing Coffee-QOL-Extras' &&
arch-chroot /mnt userdel user02 &&  
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y pamac-aur && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y libva-vdpau-driver-vp9-git && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y protontricks && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y nvidia-vaapi-driver &&  
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y game-devices-udev &&   
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y google-chrome && 
mkdir /mnt/usr/share/backgrounds/coffee/ && 
cp coffeelinux/opt/backgrounds/coffee/coffeewall03.jpg /mnt/usr/share/backgrounds/coffee/coffeewall01.jpg && 
cp coffeelinux/opt/backgrounds/coffee/coffeewall05.jpg /mnt/usr/share/backgrounds/coffee/coffeewall02.jpg && 
cp coffeelinux/opt/backgrounds/coffee/coffeewall04.jpg /mnt/usr/share/backgrounds/coffee/coffeewall03.jpg && 
cp coffeelinux/opt/backgrounds/coffee/coffeewall06.jpg /mnt/usr/share/backgrounds/coffee/coffeewall04.jpg &&
cp coffeelinux/opt/backgrounds/coffee/coffeewall02.jpg /mnt/usr/share/backgrounds/coffee/coffeewall05.jpg && 
cp coffeelinux/opt/backgrounds/coffee/coffeewall07.jpg /mnt/usr/share/backgrounds/coffee/coffeewall06.jpg && 
cp coffeelinux/opt/backgrounds/coffee/coffeewall08.jpg /mnt/usr/share/backgrounds/coffee/coffeewall07.jpg && 
cp coffeelinux/opt/backgrounds/coffee/coffeewall01.jpg /mnt/usr/share/backgrounds/coffee/coffeewall08.jpg && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y humanity-icon-theme && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y yaru-gtk-theme && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y yaru-icon-theme && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y mint-themes-legacy &&
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y mint-artwork && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y cpupower-gui && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y mint-locale && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y linuxmint-keyring && 
rm /mnt/usr/share/xsessions/gnome* && 
echo 'Ensuring correct DM is set.' && 
arch-chroot /mnt pacman -Sy lightdm lightdm-gtk-settings
arch-chroot /mnt pacman -Syu && 
arch-chroot /mnt systemctl enable lightdm && 
echo 'Attempting to fix the home directory automatically now...' && 
arch-chroot /mnt pacman -Sy --noconfirm xdg-user-dirs &&
arch-chroot /mnt xdg-user-dirs-update && 
#Phase 5
echo 'Cleaning up' &&
rm -R /mnt/home/user02/ && 
cp coffeelinux/opt/chrome-flags.conf /mnt/home/$user01/.config/ && 
cp coffeelinux/opt/chrome-flags.conf /mnt/opt/ && 
cp coffeelinux/opt/coffeebrewer.sh /mnt/opt/ && 
cp coffeelinux/opt/os-release /mnt/usr/lib/ && 
cp coffeelinux/opt/os-release /mnt/etc/ && 
cp coffeelinux/opt/chrome-pnkcfpnngfokcnnijgkllghjlhkailce-Default.desktop /mnt/opt/ && 
#
echo "Installation Complete, Please Reboot to use your OS." && 
read -n 1 -s -r -p "Press any key to continue" && 
umount -R /mnt &&
reboot
#
else
then
exit
fi
