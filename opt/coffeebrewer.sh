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

echo "Set your System/Home Partition ('p2 or 2')."
read system
system0=$drive0$system

echo "Set your PC Name (hostname)."
read hostname
hostname0=$hostname

echo "Set your drivename (ie: LocalDisk)."
read drivename
drivename0=$drivename

echo "What dektop environment would you like? ('gnome, kde, or cinnamon (case-sensitive)')."
read desktop0

if [ $desktop0 == 'gnome' ]
then
#
echo 'Starting Gnome version install'
echo 'Partition the Disk' && 
fdisk $drive0 &&
echo 'Formatting Partitions' && 
mkfs.fat -F32 $boot0 && 
#mkswap $swap0 && 
mkfs.btrfs -L $drivename0 $system0 && 
echo 'Mounting Disks' && 
#swapon $swap0 && 
mount $system0 /mnt && 
mkdir /mnt/boot && 
#mkdir -p /mnt/data &&
mount $boot0 /mnt/boot && 
echo 'Enable Repos' &&
echo '' >> /etc/pacman.conf &&
echo '[multilib]' >> /etc/pacman.conf && 
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf &&
echo '' >> /etc/pacman.conf && 
#echo '' >> /etc/pacman.conf &&
echo '[jupiter-main]' >> /etc/pacman.conf &&
echo 'Server = https://steamdeck-packages.steamos.cloud/archlinux-mirror/$repo/os/$arch' >> /etc/pacman.conf &&
echo 'SigLevel = Never' >> /etc/pacman.conf &&
echo '' >> /etc/pacman.conf &&
pacman -Sy && 
pacman -Sy --noconfirm archlinux-keyring && 
echo 'Installing Kernel Frameworks' && 
pacman -Syy && 
pacman -Sy --noconfirm archlinux-keyring && 
pacstrap /mnt base intel-ucode amd-ucode && 
#cp --dereference /opt/os-release /mnt/etc/ && 
arch-chroot /mnt pacman -Syy &&
arch-chroot /mnt pacman -Sy --noconfirm archlinux-keyring &&
cp /etc/pacman.conf /mnt/etc/pacman.conf &&
arch-chroot /mnt pacman -Syy &&
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
echo $$
EOT
#
echo 'Setting Hostname' && 
#read -n 1 -s -r -p "Press any key to continue" &&
echo $hostname0 > /mnt/etc/hostname && 
echo '127.0.0.1 localhost' >> /mnt/etc/hosts && 
echo '::1 localhost' >> /mnt/etc/hosts && 
echo 127.0.1.1 $hostname0 >> /mnt/etc/hosts && 
#
arch-chroot /mnt pacman -Sy amd-ucode make cmake meson glibc linux-neptune linux-firmware linux-neptune-headers btrfs-progs net-tools networkmanager dhcpcd iwd man-pages man-db texinfo sudo nano git base-devel archlinux-appstream-data dkms qt6 xed xreader vlc udev dbus gstreamer systemd ntp gst-libav gst-plugins-base gst-plugins-good gst-plugins-ugly gst-plugins-bad gtk4 gdm gnome gnome-extra egl-wayland &&
echo 'Creating Links' && 
genfstab -U /mnt >> /mnt/etc/fstab &&
#echo "/dev/nvme1n1p2  /data  ntfs-3g  defaults,locale=en_US.utf8"  0 3 >> /mnt/etc/fstab
echo 'Set Root Password' && 
arch-chroot /mnt passwd && 
echo 'Adding User Account' && 
arch-chroot /mnt useradd -m -G wheel,audio,video,power,users,storage --badname $user01 && 
echo 'Set User Password' && 
arch-chroot /mnt passwd $user01 

#Phase 2
echo 'Setting repos in new destination' &&
arch-chroot /mnt pacman -Syy &&
arch-chroot /mnt pacman -Sy --noconfirm archlinux-keyring &&
cp /etc/pacman.conf /mnt/etc/pacman.conf && 
cp --dereference /etc/resolv.conf /mnt/etc/ &&
arch-chroot /mnt pacman -Syy &&
echo 'Installing a bunch of stuff for gaming and general prettiness.' && 
arch-chroot /mnt pacman -Sy power-profiles-daemon go meson xorg xorg-server xorg-apps amdvlk lib32-amdvlk virtualbox virtualbox-guest-utils git xdg-utils gettext ufw libva-utils libva-vdpau-driver neofetch wine winetricks lib32-vkd3d vkd3d innoextract giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo libxcomposite lib32-libxcomposite libxinerama lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader jre-openjdk-headless jre-openjdk jdk-openjdk openjdk-doc openjdk-src gst-plugin-pipewire lib32-pipewire lib32-pipewire-jack pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber libreoffice-fresh firewalld shotwell geary &&
arch-chroot /mnt archlinux-java set java-18-openjdk && 
#Phase 3
echo 'Installing a bunch of SteamOS 3.x stuff.' && 
arch-chroot /mnt pacman -Sy yay-git lib32-vulkan-intel lib32-vulkan-mesa-layers lib32-vulkan-radeon libva-mesa-driver mesa-vdpau opencl-mesa renderdoc vulkan-intel vulkan-mesa-layers vulkan-radeon vulkan-swrast cpupower hyperv jupiter-validation-tools gamescope mangohud mangohud-debug steam-jupiter-stable zenity-light discord lib32-libva-mesa-driver lib32-mangohud lib32-mesa-vdpau lib32-opencl-mesa mesa xorg-xwayland-jupiter egl-wayland qt6-wayland

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
echo 'linux /vmlinuz-linux-neptune' >> /boot/loader/entries/arch.conf &&
echo 'initrd /intel-ucode.img' >> /boot/loader/entries/arch.conf && 
echo 'initrd /amd-ucode.img' >> /boot/loader/entries/arch.conf && 
echo 'initrd /initramfs-linux-neptune.img' >> /boot/loader/entries/arch.conf &&
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
echo options root="LABEL=$drivename0" rw >> /mnt/boot/loader/entries/arch.conf && 
#
echo 'Attempting to fix the home directory automatically now...' && 
arch-chroot /mnt pacman -Sy --noconfirm xdg-user-dirs &&
#arch-chroot /mnt xdg-user-dirs-update &&

#
echo 'Installing Coffee-QOL-Extras' && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y pamac-aur && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y libva-vdpau-driver-vp9-git && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y protontricks && 
#arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y nvidia-vaapi-driver &&  
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y game-devices-udev &&   
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y microsoft-edge-stable &&
rm -R /mnt/usr/share/backgrounds/gnome/ && 
mkdir -p /mnt/usr/share/backgrounds/gnome/ && 
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
#arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y gnome-shell-extension-user-themes && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y gnome-browser-connector && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y mutter-dynamic-buffering && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y extension-manager &&
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y yaru-gtk-theme && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y yaru-icon-theme && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y yaru-gnome-shell-theme && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y yaru-session && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y yaru-sound-theme && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y yaru-unity-theme && 
#arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y ttf-ms-win11-auto &&
rm /mnt/usr/share/xsessions/gnome* && 
#arch-chroot /mnt chown -hR root:wheel /usr/share/backgrounds/gnome/* &&
echo 'Ensuring correct DM is set.' &&  
arch-chroot /mnt pacman -Syu && 
#arch-chroot /mnt pacman -R gnome-session && 
arch-chroot /mnt systemctl enable gdm && 
echo 'Attempting to fix the home directory automatically now...' && 
arch-chroot /mnt pacman -Sy --noconfirm xdg-user-dirs &&
arch-chroot /mnt xdg-user-dirs-update && 
#cp coffeelinux/opt/os-release /mnt/data &&
#arch-chroot /mnt chown -hR $user01:wheel /data/* && 
#
#Phase 5
echo 'Cleaning up' &&
#cp coffeelinux/opt/microsoft-edge-stable-flags.conf /mnt/home/$user01/.config/ &&
cp coffeelinux/opt/microsoft-edge-stable-flags.conf /mnt/opt/ &&
cp coffeelinux/opt/coffeebrewer.sh /mnt/opt/ && 
#cp coffeelinux/opt/coffeebrewer.sh /mnt/usr/local/bin/ && 
#cp coffeelinux/opt/os-release /mnt/usr/lib/ && 
cp coffeelinux/opt/os-release /mnt/etc/ && 
#cp /opt/chrome-pnkcfpnngfokcnnijgkllghjlhkailce-Default.desktop /mnt/opt/ &&
#
echo "Installation Complete, Please Reboot to use your OS." && 
read -n 1 -s -r -p "Press any key to continue" && 
umount -R /mnt &&
reboot
#
elif [ $desktop0 == 'kde' ]
then
echo 'Starting KDE version install'
echo 'Partition the Disk' && 
fdisk $drive0 &&
echo 'Formatting Partitions' && 
mkfs.fat -F32 $boot0 && 
#mkswap $swap0 && 
mkfs.btrfs -L $drivename0 $system0 && 
echo 'Mounting Disks' && 
#swapon $swap0 && 
mount $system0 /mnt && 
mkdir /mnt/boot && 
#mkdir -p /mnt/data &&
mount $boot0 /mnt/boot && 
echo 'Enable Repos' &&
echo '' >> /etc/pacman.conf &&
echo '[multilib]' >> /etc/pacman.conf && 
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf &&
echo '' >> /etc/pacman.conf && 
#echo '' >> /etc/pacman.conf &&
echo '[jupiter-main]' >> /etc/pacman.conf &&
echo 'Server = https://steamdeck-packages.steamos.cloud/archlinux-mirror/$repo/os/$arch' >> /etc/pacman.conf &&
echo 'SigLevel = Never' >> /etc/pacman.conf &&
echo '' >> /etc/pacman.conf &&
pacman -Sy && 
pacman -Sy --noconfirm archlinux-keyring && 
echo 'Installing Kernel Frameworks' && 
pacman -Syy && 
pacman -Sy --noconfirm archlinux-keyring && 
pacstrap /mnt base intel-ucode amd-ucode && 
#cp --dereference /opt/os-release /mnt/etc/ && 
arch-chroot /mnt pacman -Syy &&
arch-chroot /mnt pacman -Sy --noconfirm archlinux-keyring &&
cp /etc/pacman.conf /mnt/etc/pacman.conf &&
arch-chroot /mnt pacman -Syy &&
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
echo $$
EOT
# 
echo 'Setting Hostname' && 
#read -n 1 -s -r -p "Press any key to continue" &&
echo $hostname0 > /mnt/etc/hostname && 
echo '127.0.0.1 localhost' >> /mnt/etc/hosts && 
echo '::1 localhost' >> /mnt/etc/hosts && 
echo 127.0.1.1 $hostname0 >> /mnt/etc/hosts && 
#
arch-chroot /mnt pacman -Sy amd-ucode make cmake meson glibc linux-neptune linux-firmware linux-neptune-headers btrfs-progs net-tools networkmanager dhcpcd iwd man-pages man-db texinfo plasma-framework kcmutils archlinux-appstream-data appstream-qt qt5-graphicaleffects kuserfeedback knewstuff kidletime discount hicolor-icon-theme kirigami2 cmake make flatpak fwupd extra-cmake-modules plasma-wayland-protocols xorg-xwayland-jupiter plasma-wayland-session egl-wayland qt6 dkms kde-applications-meta sddm-wayland sddm-kcm plasma-meta sudo nano git base-devel xed xreader vlc udev dbus gstreamer systemd ntp gst-libav gst-plugins-base gst-plugins-good gst-plugins-ugly gst-plugins-bad &&
echo 'Creating Links' && 
genfstab -U /mnt >> /mnt/etc/fstab && 
#echo "/dev/nvme1n1p2  /data  ntfs-3g  defaults,locale=en_US.utf8"  0 3 >> /mnt/etc/fstab
echo 'Set Root Password' && 
arch-chroot /mnt passwd && 
echo 'Adding User Account' && 
arch-chroot /mnt useradd -m -G wheel,audio,video,users --badname $user01 && 
echo 'Set User Password' && 
arch-chroot /mnt passwd $user01 
#Phase 2
echo 'Setting repos in new destination' &&
arch-chroot /mnt pacman -Syy &&
arch-chroot /mnt pacman -Sy --noconfirm archlinux-keyring &&
cp /etc/pacman.conf /mnt/etc/pacman.conf && 
cp --dereference /etc/resolv.conf /mnt/etc/ &&
arch-chroot /mnt pacman -Syy &&
echo 'Installing a bunch of stuff for gaming and general prettiness.' && 
arch-chroot /mnt pacman -Sy gnome-disk-utility power-profiles-daemon go mesa amdvlk lib32-amdvlk meson xorg xorg-server xorg-apps virtualbox virtualbox-guest-utils git xdg-utils gettext ufw libva-utils libva-vdpau-driver neofetch wine winetricks lib32-vkd3d vkd3d innoextract giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo libxcomposite lib32-libxcomposite libxinerama lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader jre-openjdk-headless jre-openjdk jdk-openjdk openjdk-doc openjdk-src libreoffice-fresh gst-plugin-pipewire lib32-pipewire lib32-pipewire-jack pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber firewalld shotwell geary &&
arch-chroot /mnt archlinux-java set java-18-openjdk && 
#Phase 3
echo 'Installing a bunch of SteamOS 3.x stuff.' && 
arch-chroot /mnt pacman -Sy yay-git lib32-vulkan-intel lib32-vulkan-mesa-layers lib32-vulkan-radeon libva-mesa-driver mesa-vdpau opencl-mesa renderdoc vulkan-intel vulkan-mesa-layers vulkan-radeon vulkan-swrast cpupower hyperv jupiter-validation-tools gamescope mangohud mangohud-debug steam-jupiter-stable zenity-light discord lib32-libva-mesa-driver lib32-mangohud lib32-mesa-vdpau lib32-opencl-mesa mesa xorg-xwayland-jupiter egl-wayland qt6-wayland

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
echo 'linux /vmlinuz-linux-neptune' >> /boot/loader/entries/arch.conf &&
echo 'initrd /intel-ucode.img' >> /boot/loader/entries/arch.conf && 
echo 'initrd /amd-ucode.img' >> /boot/loader/entries/arch.conf && 
echo 'initrd /initramfs-linux-neptune.img' >> /boot/loader/entries/arch.conf &&
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
echo options root="LABEL=$drivename0" rw >> /mnt/boot/loader/entries/arch.conf && 
#
echo 'Attempting to fix the home directory automatically now...' && 
arch-chroot /mnt pacman -Sy --noconfirm xdg-user-dirs &&
arch-chroot /mnt xdg-user-dirs-update && 
#cp coffeelinux/opt/os-release /mnt/data &&
#arch-chroot /mnt chown -hR $user01:wheel /data/* && 

#
echo 'Installing Coffee-QOL-Extras' &&  
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y libva-vdpau-driver-vp9-git && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y protontricks && 
#arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y nvidia-vaapi-driver &&  
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y game-devices-udev &&   
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y microsoft-edge-stable &&
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y pamac-aur && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y systemd-kcm && 
#arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y ttf-ms-win11-auto &&
mkdir -p /mnt/usr/share/wallpapers/coffee/ && 

cp coffeelinux/opt/backgrounds/coffee/coffeewall03.jpg /mnt/usr/share/wallpapers/coffee/coffeewall01.jpg && 
cp coffeelinux/opt/backgrounds/coffee/coffeewall05.jpg /mnt/usr/share/wallpapers/coffee/coffeewall02.jpg && 
cp coffeelinux/opt/backgrounds/coffee/coffeewall04.jpg /mnt/usr/share/wallpapers/coffee/coffeewall03.jpg && 
cp coffeelinux/opt/backgrounds/coffee/coffeewall06.jpg /mnt/usr/share/wallpapers/coffee/coffeewall04.jpg &&
cp coffeelinux/opt/backgrounds/coffee/coffeewall02.jpg /mnt/usr/share/wallpapers/coffee/coffeewall05.jpg && 
cp coffeelinux/opt/backgrounds/coffee/coffeewall07.jpg /mnt/usr/share/wallpapers/coffee/coffeewall06.jpg && 
cp coffeelinux/opt/backgrounds/coffee/coffeewall08.jpg /mnt/usr/share/wallpapers/coffee/coffeewall07.jpg && 
cp coffeelinux/opt/backgrounds/coffee/coffeewall01.jpg /mnt/usr/share/wallpapers/coffee/coffeewall08.jpg &&  
# 
#arch-chroot /mnt chown -hR root:wheel /usr/share/backgrounds/coffee/* && 
echo 'Ensuring correct DM is set.' &&  
arch-chroot /mnt pacman -Syu && 
arch-chroot /mnt systemctl enable sddm && 
echo 'Attempting to fix the home directory automatically now...' && 
arch-chroot /mnt pacman -Sy --noconfirm xdg-user-dirs &&
arch-chroot /mnt xdg-user-dirs-update && 
#Phase 5
echo 'Cleaning up' &&
#cp coffeelinux/opt/microsoft-edge-stable-flags.conf /mnt/home/$user01/.config/ &&
cp coffeelinux/opt/microsoft-edge-stable-flags.conf /mnt/opt/ &&
cp coffeelinux/opt/coffeebrewer.sh /mnt/opt/ && 
#cp coffeelinux/opt/coffeebrewer.sh /mnt/usr/local/bin/ && 
#cp coffeelinux/opt/os-release /mnt/usr/lib/ && 
cp coffeelinux/opt/os-release /mnt/etc/ && 
#cp /opt/chrome-pnkcfpnngfokcnnijgkllghjlhkailce-Default.desktop /mnt/opt/ &&
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
#
fdisk $drive0 && 
echo 'formatting Partitions' && 
mkfs.fat -F32 $boot0 && 
#mkswap $swap0 && 
mkfs.btrfs -L $drivename0 $system0 && 
echo 'Mounting Disks' && 
#swapon $swap0 && 
mount $system0 /mnt && 
mkdir /mnt/boot && 
mkdir -p /mnt/data && 
mount $boot0 /mnt/boot && 
echo 'Enable Repos' &&
echo '' >> /etc/pacman.conf &&
echo '[multilib]' >> /etc/pacman.conf && 
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf &&
echo '' >> /etc/pacman.conf && 
#echo '' >> /etc/pacman.conf &&
echo '[jupiter-main]' >> /etc/pacman.conf &&
echo 'Server = https://steamdeck-packages.steamos.cloud/archlinux-mirror/$repo/os/$arch' >> /etc/pacman.conf &&
echo 'SigLevel = Never' >> /etc/pacman.conf &&
echo '' >> /etc/pacman.conf &&
pacman -Sy && 
pacman -Sy --noconfirm archlinux-keyring && 
echo 'Installing Kernel Frameworks' && 
pacman -Syy && 
pacman -Sy --noconfirm archlinux-keyring && 
pacstrap /mnt base intel-ucode amd-ucode &&
#cp --dereference /opt/os-release /mnt/etc/ && 
arch-chroot /mnt pacman -Syy &&
arch-chroot /mnt pacman -Sy --noconfirm archlinux-keyring &&
cp /etc/pacman.conf /mnt/etc/pacman.conf &&
arch-chroot /mnt pacman -Syy && 
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
echo $$
EOT
#
echo 'Setting Hostname' && 
#read -n 1 -s -r -p "Press any key to continue" &&
echo $hostname0 > /mnt/etc/hostname && 
echo '127.0.0.1 localhost' >> /mnt/etc/hosts && 
echo '::1 localhost' >> /mnt/etc/hosts && 
echo 127.0.1.1 $hostname0 >> /mnt/etc/hosts && 
#
arch-chroot /mnt pacman -Sy amd-ucode make cmake meson glibc linux-neptune linux-firmware linux-neptune-headers btrfs-progs net-tools networkmanager dhcpcd iwd qt6 man-pages man-db texinfo sudo nano dkms git base-devel xed xreader vlc udev dbus gstreamer systemd ntp gst-libav gst-plugins-base gst-plugins-good gst-plugins-ugly gst-plugins-bad cinnamon cinnamon-translations gdm gtk4 &&
echo 'Creating Links' && 
genfstab -U /mnt >> /mnt/etc/fstab && 
#echo "/dev/nvme1n1p2  /data  ntfs-3g  defaults,locale=en_US.utf8"  0 3 >> /mnt/etc/fstab
echo 'Set Root Password' && 
arch-chroot /mnt passwd && 
echo 'Adding User Account' && 
arch-chroot /mnt useradd -m -G wheel,audio,video,power,users,storage --badname $user01 && 
echo 'Set User Password' && 
arch-chroot /mnt passwd $user01 
#Phase 2
echo 'Setting repos in new destination' &&
arch-chroot /mnt pacman -Syy &&
arch-chroot /mnt pacman -Sy --noconfirm archlinux-keyring &&
cp /etc/pacman.conf /mnt/etc/pacman.conf && 
cp --dereference /etc/resolv.conf /mnt/etc/ &&
arch-chroot /mnt pacman -Syy &&
echo 'Installing a bunch of stuff for gaming and general prettiness.' && 
arch-chroot /mnt pacman -Sy gnome-terminal gnome-tweaks gnome-calculator gnome-system-monitor gnome-keyring polkit-gnome power-profiles-daemon cpupower go meson xorg xorg-server xorg-apps mesa amdvlk lib32-amdvlk virtualbox virtualbox-guest-utils git xdg-utils gettext ufw libva-utils libva-vdpau-driver neofetch wine winetricks lib32-vkd3d vkd3d innoextract giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo libxcomposite lib32-libxcomposite libxinerama lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader jre-openjdk-headless jre-openjdk jdk-openjdk openjdk-doc openjdk-src gst-plugin-pipewire lib32-pipewire lib32-pipewire-jack pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber libreoffice-fresh firewalld shotwell geary &&
arch-chroot /mnt archlinux-java set java-18-openjdk && 

echo 'Installing a bunch of SteamOS 3.x stuff.' && 
arch-chroot /mnt pacman -Sy yay-git lib32-vulkan-intel lib32-vulkan-mesa-layers lib32-vulkan-radeon libva-mesa-driver mesa-vdpau opencl-mesa renderdoc vulkan-intel vulkan-mesa-layers vulkan-radeon vulkan-swrast cpupower hyperv jupiter-validation-tools gamescope mangohud mangohud-debug steam-jupiter-stable zenity-light discord lib32-libva-mesa-driver lib32-mangohud lib32-mesa-vdpau lib32-opencl-mesa kscreen mesa xorg-xwayland-jupiter egl-wayland qt6-wayland

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
echo 'linux /vmlinuz-linux-neptune' >> /boot/loader/entries/arch.conf &&
echo 'initrd /intel-ucode.img' >> /boot/loader/entries/arch.conf && 
echo 'initrd /amd-ucode.img' >> /boot/loader/entries/arch.conf && 
echo 'initrd /initramfs-linux-neptune.img' >> /boot/loader/entries/arch.conf &&
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
echo options root="LABEL=$drivename0" rw >> /mnt/boot/loader/entries/arch.conf && 
#
echo 'Attempting to fix the home directory automatically now...' && 
arch-chroot /mnt pacman -Sy --noconfirm xdg-user-dirs &&
arch-chroot /mnt xdg-user-dirs-update && 
#cp coffeelinux/opt/os-release /mnt/data &&
#arch-chroot /mnt chown -hR $user01:wheel /data/* && 
#
echo 'Installing Coffee-QOL-Extras' && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y pamac-aur && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y libva-vdpau-driver-vp9-git && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y protontricks && 
#arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y nvidia-vaapi-driver &&  
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y game-devices-udev &&   
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y microsoft-edge-stable &&
#arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y ttf-ms-win11-auto &&
#rm -R /mnt/usr/share/backgrounds/gnome/ &&
mkdir -p /mnt/usr/share/backgrounds/gnome/ && 
cp coffeelinux/opt/backgrounds/coffee/coffeewall03.jpg /mnt/usr/share/backgrounds/gnome/adwaita-l.jpg && 
cp coffeelinux/opt/backgrounds/coffee/coffeewall03.jpg /mnt/usr/share/backgrounds/gnome/coffeewall01.jpg && 
cp coffeelinux/opt/backgrounds/coffee/coffeewall05.jpg /mnt/usr/share/backgrounds/gnome/coffeewall02.jpg && 
cp coffeelinux/opt/backgrounds/coffee/coffeewall04.jpg /mnt/usr/share/backgrounds/gnome/coffeewall03.jpg && 
cp coffeelinux/opt/backgrounds/coffee/coffeewall06.jpg /mnt/usr/share/backgrounds/gnome/coffeewall04.jpg &&
cp coffeelinux/opt/backgrounds/coffee/coffeewall02.jpg /mnt/usr/share/backgrounds/gnome/coffeewall05.jpg && 
cp coffeelinux/opt/backgrounds/coffee/coffeewall07.jpg /mnt/usr/share/backgrounds/gnome/coffeewall06.jpg && 
cp coffeelinux/opt/backgrounds/coffee/coffeewall08.jpg /mnt/usr/share/backgrounds/gnome/coffeewall07.jpg && 
cp coffeelinux/opt/backgrounds/coffee/coffeewall01.jpg /mnt/usr/share/backgrounds/gnome/coffeewall08.jpg && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y humanity-icon-theme && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y yaru-gtk-theme && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y yaru-icon-theme && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y yaru-sound-theme && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y mint-themes-legacy &&
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y mint-artwork && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y cpupower-gui && 
rm /mnt/usr/share/xsessions/gnome* && 
#arch-chroot /mnt chown -hR root:wheel /usr/share/backgrounds/coffee/* &&
echo 'Ensuring correct DM is set.' && 
arch-chroot /mnt pacman -Syu && 
arch-chroot /mnt pacman -R lightdm lightdm-slick-greeter lightdm-settings && 
arch-chroot /mnt systemctl enable gdm && 
echo 'Attempting to fix the home directory automatically now...' && 
arch-chroot /mnt pacman -Sy --noconfirm xdg-user-dirs &&
arch-chroot /mnt xdg-user-dirs-update && 
#Phase 5
echo 'Cleaning up' &&
#cp coffeelinux/opt/microsoft-edge-stable-flags.conf /mnt/home/$user01/.config/ &&
cp coffeelinux/opt/microsoft-edge-stable-flags.conf /mnt/opt/ &&
cp coffeelinux/opt/coffeebrewer.sh /mnt/opt/ && 
#cp coffeelinux/opt/coffeebrewer.sh /mnt/usr/local/bin/ && 
#cp coffeelinux/opt/os-release /mnt/usr/lib/ && 
cp coffeelinux/opt/os-release /mnt/etc/ && 
#cp /opt/chrome-pnkcfpnngfokcnnijgkllghjlhkailce-Default.desktop /mnt/opt/ &&
#
echo "Installation Complete, Please Reboot to use your OS." && 
read -n 1 -s -r -p "Press any key to continue" && 
umount -R /mnt &&
reboot
else
echo "You need to enter a valid desktop environment"
fi
