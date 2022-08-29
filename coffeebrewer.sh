#!/bin/sh
#Phase 1

function edittherepos(){
echo 'Enable Repos' &&
#read -n 1 -s -r -p "Press any key to continue" && 
nano /etc/pacman.conf && 
pacman -Sy && 
pacman -Sy --noconfirm archlinux-keyring
}

function installextrapackages(){
echo 'Setting repos in new destination' &&
#read -n 1 -s -r -p "Press any key to continue" && 
arch-chroot /mnt pacman -Syy &&
arch-chroot /mnt pacman -Sy --noconfirm archlinux-keyring &&
cp /etc/pacman.conf /mnt/etc/pacman.conf && 
cp --dereference /etc/resolv.conf /mnt/etc/ &&
arch-chroot /mnt pacman -Syy &&
echo 'Installing Drivers and dependencies.' && 
#read -n 1 -s -r -p "Press any key to continue" && 
arch-chroot /mnt pacman -Sy power-profiles-daemon cpupower go meson xorg xorg-server xorg-apps virtualbox-guest-utils xf86-video-vmware nvidia-open git xdg-utils gettext ufw libva-utils libva-vdpau-driver neofetch wine winetricks lib32-vkd3d vkd3d innoextract giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo libxcomposite lib32-libxcomposite libxinerama lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader cups samba dosbox jre-openjdk-headless jre-openjdk jdk-openjdk openjdk-doc openjdk-src steam wine-mono wine-gecko lib32-opencl-nvidia zenity discord polkit-gnome gnome-keyring gst-plugin-pipewire lib32-pipewire lib32-pipewire-jack pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber firewalld shotwell virtualbox && 
arch-chroot /mnt archlinux-java set java-18-openjdk

}
function fixthehomedir(){
echo 'Attempting to fix the home directory automatically now...' && 
#read -n 1 -s -r -p "Press any key to continue" && 
arch-chroot /mnt pacman -Sy --noconfirm xdg-user-dirs &&
arch-chroot /mnt xdg-user-dirs-update
}

function fixthedm(){
echo 'Ensuring correct DM is set.' && 
arch-chroot /mnt pacman -S lightdm lightdm-gtk-greeter &&  
arch-chroot /mnt pacman -Syu && 
arch-chroot /mnt systemctl enable lightdm
}

function cleanupafter(){
#Phase 5
echo 'Cleaning up' &&
#cp arch-linux-installer/coffeebrewer.sh /mnt/opt/ &&
cp arch-linux-installer/chrome-flags.conf /mnt/opt/ && 
cp arch-linux-installer/chrome-pnkcfpnngfokcnnijgkllghjlhkailce-Default.desktop /mnt/opt/ && 
umount -R /mnt &&
echo "Installation Complete, Please Reboot to use your OS." && 
read -n 1 -s -r -p "Press any key to continue" && 
reboot
}

function setlocale(){
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
}

echo "This script must be run as root"
echo "If you have not ran as root user, please exit now."


echo "Set your username."
read user00
user01=$user00

echo "Set your drive ('nvmeXn1 or sdX')"
read drive
pfx="/dev/"
drive0=$pfx$drive

echo "Set your boot partition ('p1 or 1')."
read boot
boot0=$drive0$boot

echo "Set your swap partition ('p2 or 2')."
read swap
swap0=$drive0$swap

echo "Set your system/home partition ('p3 or 3')."
read system
system0=$drive0$system

echo 'Partition the Disk' && 
#read -n 1 -s -r -p "Press any key to continue" &&
fdisk $drive0 && 
echo 'Formatting Partitions' && 
#read -n 1 -s -r -p "Press any key to continue" &&
mkfs.fat -F32 $boot0 && 
#mkfs.fat -F32 /dev/nvme1n1p2 && 
#mkfs.fat -F32 /dev/nvme1n1p3 && 
mkswap $swap0 && 
mkfs.btrfs -L CoffeePot $system0 && 
echo 'Mounting Disks' && 
#read -n 1 -s -r -p "Press any key to continue" &&
swapon $swap0 && 
mount $system0 /mnt && 
mkdir /mnt/boot && 
#mkdir /mnt/efi &&
mount $boot0 /mnt/boot
#mount /dev/nvme1n1p2 /mnt/efi && 
edittherepos
echo 'Installing Kernel Frameworks' && 
#read -n 1 -s -r -p "Press any key to continue" &&
pacman -Syy && 
pacman -Sy --noconfirm archlinux-keyring && 
pacstrap /mnt base linux linux-firmware linux-headers btrfs-progs net-tools networkmanager dhcpcd iwd man-pages man-db texinfo && 
echo 'Installing Cinnamon/Gnome' && 
setlocale && 
#read -n 1 -s -r -p "Press any key to continue" &&
arch-chroot /mnt pacman -Sy git gnome-menus polkit-gnome gnome gdm gtk4 qt6 gnome-extra dkms gnome-keyring base-devel intel-ucode cinnamon lightdm lightdm-gtk-greeter gnome-terminal gnome-disk-utility gnome-calculator cinnamon-translations gnome-system-monitor xed xreader vlc gnome-keyring cinnamon-translations archlinux-wallpaper udev dbus gstreamer systemd ntp gst-libav gst-plugins-base gst-plugins-good gst-plugins-ugly gst-plugins-bad sudo nano && 
echo 'Creating Links' && 
#read -n 1 -s -r -p "Press any key to continue" && 
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
#read -n 1 -s -r -p "Press any key to continue" &&
#Phase 2
installextrapackages &&
#read -n 1 -s -r -p "Press any key to continue" &&
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

fixthehomedir &&

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

#read -n 1 -s -r -p "Press any key to continue" &&
#echo 'Installing Arch-QOL-Extras' &&
arch-chroot /mnt userdel user02 &&  
#read -n 1 -s -r -p "Press any key to continue" &&  
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y pamac-aur && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y libva-vdpau-driver-vp9-git && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y protontricks && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y nvidia-vaapi-driver && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y cpupower-gui && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y game-devices-udev && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y mintlocale && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y mint-artwork &&
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y mint-artwork-cinnamon && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y linuxmint-keyring && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y gnome-calendar-linuxmint && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y google-chrome && 
#read -n 1 -s -r -p "Press any key to continue" &&
fixthedm &&
#read -n 1 -s -r -p "Press any key to continue" &&
cleanupafter
