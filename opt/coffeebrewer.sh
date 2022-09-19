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

#
echo 'Starting Coffee Linux install'
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
echo 'Set Root Password' && 
arch-chroot /mnt passwd && 
echo 'Adding User Account' && 
arch-chroot /mnt useradd -m -G wheel,audio,video,users --badname $user01 && 
echo 'Set User Password' && 
arch-chroot /mnt passwd $user01
echo 'Setting Hostname' && 
#read -n 1 -s -r -p "Press any key to continue" &&
echo $hostname0 > /mnt/etc/hostname && 
echo '127.0.0.1 localhost' >> /mnt/etc/hosts && 
echo '::1 localhost' >> /mnt/etc/hosts && 
echo 127.0.1.1 $hostname0 >> /mnt/etc/hosts && 
#
echo 'Creating Links' && 
genfstab -U /mnt >> /mnt/etc/fstab &&
#
echo 'Setting repos in new destination' &&
arch-chroot /mnt pacman -Syy &&
arch-chroot /mnt pacman -Sy --noconfirm archlinux-keyring &&
cp /etc/pacman.conf /mnt/etc/pacman.conf && 
cp --dereference /etc/resolv.conf /mnt/etc/ &&
arch-chroot /mnt pacman -Syy &&
#
arch-chroot /mnt pacman -Sy xdg-desktop-portal-gnome amd-ucode make xf86-video-amdgpu dbus-python glib2 gtk3 dconf nftables python-gobject hicolor-icon-theme libnotify nm-connection-editor python-pyqt5 python-capng bash-completion phonon-qt5-gstreamer tesseract-data-eng mkinitcpio cronie pipewire-jack noto-fonts noto-fonts-emoji noto-fonts-cjk noto-fonts-extra gnu-free-fonts cmake meson nullmailer glibc linux linux-firmware linux-headers btrfs-progs net-tools networkmanager dhcpcd iwd man-pages man-db texinfo sudo nano git base-devel archlinux-appstream-data dkms qt6 xed xreader vlc udev dbus gstreamer systemd ntp gst-libav gst-plugins-base gst-plugins-good gst-plugins-ugly gst-plugins-bad gtk4 gdm gnome gnome-extra egl-wayland gtk-engine-murrine virtualbox-host-modules-dkms power-profiles-daemon go meson xorg xorg-server xorg-apps lib32-libva-mesa-driver vulkan-radeon lib32-vulkan-radeon libva-utils libva-mesa-driver mesa-vdpau lib32-mesa-vdpau virtualbox virtualbox-guest-utils git xdg-utils gettext ufw libva-vdpau-driver neofetch wine winetricks lib32-vkd3d vkd3d innoextract giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo libxcomposite lib32-libxcomposite libxinerama lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader jre-openjdk-headless jre-openjdk jdk-openjdk openjdk-doc openjdk-src gst-plugin-pipewire lib32-pipewire lib32-pipewire-jack pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber libreoffice-fresh firewalld shotwell geary yay-git lib32-libva-mesa-driver vulkan-radeon lib32-vulkan-radeon libva-utils libva-mesa-driver mesa-vdpau lib32-mesa-vdpau lib32-vulkan-mesa-layers opencl-mesa vulkan-mesa-layers zenity steam discord lib32-opencl-mesa mesa egl-wayland qt6-wayland chromium &&
#Phase 2
arch-chroot /mnt archlinux-java set java-18-openjdk && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y mkinitcpio-firmware && 
#Phase 3
arch-chroot /mnt pacman -Sy  && 
#
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
echo 'initrd /amd-ucode.img' >> /boot/loader/entries/arch.conf && 
echo 'initrd /initramfs-linux.img' >> /boot/loader/entries/arch.conf &&
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
rm -R /mnt/usr/share/backgrounds/gnome/ && 
mkdir -p /mnt/usr/share/backgrounds/gnome/ && 
cp /opt/backgrounds/coffee/coffeewall03.jpg /mnt/usr/share/backgrounds/gnome/adwaita-d.jpg && 
cp /opt/backgrounds/coffee/coffeewall05.jpg /mnt/usr/share/backgrounds/gnome/adwaita-l.jpg && 
cp /opt/backgrounds/coffee/coffeewall04.jpg /mnt/usr/share/backgrounds/gnome/libadwaita-l.jpg && 
cp /opt/backgrounds/coffee/coffeewall06.jpg /mnt/usr/share/backgrounds/gnome/libadwaita-d.jpg &&
cp /opt/backgrounds/coffee/coffeewall02.jpg /mnt/usr/share/backgrounds/gnome/disco-l.jpg && 
cp /opt/backgrounds/coffee/coffeewall07.jpg /mnt/usr/share/backgrounds/gnome/disco-d.jpg && 
cp /opt/backgrounds/coffee/coffeewall08.jpg /mnt/usr/share/backgrounds/gnome/wood-l.jpg && 
cp /opt/backgrounds/coffee/coffeewall01.jpg /mnt/usr/share/backgrounds/gnome/wood-d.jpg && 
#
echo 'Installing Coffee-QOL-Extras' && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y pamac-aur && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y libva-vdpau-driver-vp9-git && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y protontricks && 
#arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y nvidia-vaapi-driver &&  
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y game-devices-udev && 
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
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y xone-dkms && 
arch-chroot /mnt pacman -Syu && 
#
#Phase 5
echo 'Cleaning up' &&
#cp coffeelinux/opt/microsoft-edge-stable-flags.conf /mnt/home/$user01/.config/ &&
cp coffeelinux/opt/chromium-flags.conf /mnt/opt/ &&
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
