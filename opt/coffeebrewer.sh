#!/bin/sh
#Phase 1

desktop0="kde"
echo "Set your Username."
read -r user00
user01=$user00

echo "Set your drive ('nvmeXn1 or sdX')"
read -r drive
pfx="/dev/"
drive0=$pfx$drive

echo "Set your Boot Partition ('p1 or 1')."
read -r boot
boot0=$drive0$boot

echo "Set your System/Home Partition ('p2 or 2')."
read -r system
system0=$drive0$system

echo "Set your PC Name (hostname)."
read -r hostname
hostname0=$hostname

echo "Set your drivename (ie: LocalDisk)."
read -r drivename
drivename0=$drivename

#echo "What dektop environment would you like? ('gnome, kde, or cinnamon (case-sensitive)')."


if [ $desktop0 == 'kde' ]
then
echo 'Starting KDE version install'
echo "Partition the Disk" && 
fdisk $drive0 &&
echo "Formatting Partitions" && 
mkfs.fat -F32 $boot0 && 
#mkswap $swap0 && 
mkfs.btrfs -L $drivename0 $system0 && 
echo "Mounting Disks" && 
#swapon $swap0 && 
mount $system0 /mnt && 
mkdir /mnt/boot && 
mount $boot0 /mnt/boot
echo "Enable Repos" &&
echo " " >> /etc/pacman.conf &&
echo "[multilib]" >> /etc/pacman.conf && 
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf &&
echo " " >> /etc/pacman.conf && 
echo echo "[jupiter-main]" >> /etc/pacman.conf &&
echo "Server = https://steamdeck-packages.steamos.cloud/archlinux-mirror/$repo/os/$arch" >> /etc/pacman.conf &&
echo "SigLevel = Never" >> /etc/pacman.conf &&
echo " " >> /etc/pacman.conf &&
echo "[holoiso]" >> /etc/pacman.conf &&
echo "Server = http://dlcdn2.thevakhovske.pw/$repo/os/$arch" >> /etc/pacman.conf &&
echo "Server = http://dl.thevakhovske.pw/$repo/os/$arch" >> /etc/pacman.conf &&
echo "Server = http://holoiso.itsvixano.me/$repo/os/$arch" >> /etc/pacman.conf &&
echo "SigLevel = Never" >> /etc/pacman.conf &&
echo " " >> /etc/pacman.conf &&
echo "[holostaging]" >> /etc/pacman.conf &&
echo "Server = http://dlcdn2.thevakhovske.pw/$repo/os/$arch" >> /etc/pacman.conf &&
echo "Server = http://dl.thevakhovske.pw/$repo/os/$arch" >> /etc/pacman.conf &&
echo "Server = http://holoiso.itsvixano.me/$repo/os/$arch" >> /etc/pacman.conf &&
echo "SigLevel = Never" >> /etc/pacman.conf &&
echo " " >> /etc/pacman.conf &&
echo "[holo]" >> /etc/pacman.conf &&
echo "Server = https://steamdeck-packages.steamos.cloud/archlinux-mirror/$repo/os/$arch" >> /etc/pacman.conf &&
echo "SigLevel = Never" >> /etc/pacman.conf &&
echo " " >> /etc/pacman.conf &&
pacman -Sy &&
pacman -Sy --noconfirm archlinux-keyring && 
echo "Installing Kernel Frameworks" && 
pacman -Syy && 
pacman -Sy --noconfirm archlinux-keyring && 
pacstrap /mnt base intel-ucode && 
#cp --dereference /opt/os-release /mnt/etc/ && 
arch-chroot /mnt pacman -Syy &&
arch-chroot /mnt pacman -Sy --noconfirm archlinux-keyring &&
cp /etc/pacman.conf /mnt/etc/pacman.conf &&
arch-chroot /mnt pacman -Syy &&
echo "Installing KDE" && 
arch-chroot /mnt /bin/bash <<"EOT"
echo "Setting Locale" && 
#read -n 1 -s -r -p "Press any key to continue" &&
ln -sf ../usr/share/zoneinfo/America/Los_Angeles /etc/localtime && 
hwclock --systohc && 
echo "en_US ISO-8859-1" >> /etc/locale.gen && 
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && 
echo "KEYMAP=us" > /etc/vconsole.conf && 
echo "LANG=en_US.UTF-8" > /etc/locale.conf && 
export LANG=en_US.UTF-8 && 
locale-gen && 
echo $$
EOT
# 
echo "Setting Hostname" && 
#read -n 1 -s -r -p "Press any key to continue" &&
echo $hostname0 > /mnt/etc/hostname && 
echo "127.0.0.1 localhost" >> /mnt/etc/hosts && 
echo "::1 localhost" >> /mnt/etc/hosts && 
echo "127.0.1.1 '$hostname0'" >> /mnt/etc/hosts && 
#
arch-chroot /mnt pacman -Sy plasma plasma-nm amd-ucode mesa linux linux-firmware linux-headers btrfs-progs net-tools networkmanager dhcpcd iwd man-pages man-db texinfo plasma-framework kcmutils archlinux-appstream-data appstream-qt qt5-graphicaleffects kuserfeedback knewstuff kidletime discount hicolor-icon-theme kirigami2 cmake make flatpak fwupd extra-cmake-modules plasma-wayland-session egl-wayland qt6 dkms kde-applications-meta sddm sddm-kcm plasma-meta plasma-browser-integration sudo nano git base-devel xed xreader vlc udev dbus gstreamer systemd ntp gst-libav gst-plugins-base gst-plugins-good gst-plugins-ugly gst-plugins-bad &&
echo "Creating Links" && 
genfstab -U /mnt >> /mnt/etc/fstab &&
echo "Set Root Password" && 
arch-chroot /mnt passwd && 
echo "Adding User Account" && 
arch-chroot /mnt useradd -m -G wheel,audio,video,users --badname $user01 && 
echo "Set User Password" && 
arch-chroot /mnt passwd $user01 
echo "Set Temporary User Password" && 
arch-chroot /mnt useradd -m -G wheel,audio,video,users --badname user02 && 
arch-chroot /mnt passwd user02 && 
#Phase 2
echo "Setting repos in new destination" &&
arch-chroot /mnt pacman -Syy &&
arch-chroot /mnt pacman -Sy --noconfirm archlinux-keyring &&
cp /etc/pacman.conf /mnt/etc/pacman.conf && 
cp --dereference /etc/resolv.conf /mnt/etc/ &&
arch-chroot /mnt pacman -Syy &&
echo "Installing a bunch of stuff for gaming and general prettiness." && 
arch-chroot /mnt pacman -Sy power-profiles-daemon go meson xorg xorg-server gnome-disk-utility xorg-apps virtualbox virtualbox-guest-utils git xdg-utils gettext ufw libva-utils libva-vdpau-driver neofetch wine winetricks lib32-vkd3d vkd3d innoextract giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo libxcomposite lib32-libxcomposite libxinerama lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader jre-openjdk-headless jre-openjdk jdk-openjdk openjdk-doc openjdk-src lib32-opencl-nvidia libreoffice-fresh zenity discord gst-plugin-pipewire lib32-pipewire lib32-pipewire-jack pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber firewalld shotwell geary mlocate chrony &&
arch-chroot /mnt archlinux-java set java-18-openjdk && 
arch-chroot /mnt pacman -Syy &&
arch-chroot /mnt pacman -Sy xone-dkms-git steam-jupiter-stable steamdeck-kde-presets gamescope &&
#Phase 3
arch-chroot /mnt /bin/bash <<"EOT"
mkdir -p /tmp/arch &&
cd /tmp/arch &&
ls -l && 
cd / &&  
echo "%wheel ALL=(ALL:ALL) ALL" > /etc/sudoers.d/wheel &&
mkinitcpio -P && 
echo Installing Bootloader &&
#read -n 1 -s -r -p "Press any key to continue" &&  
bootctl install && 
echo "default arch.conf" > /boot/loader/loader.conf && 
echo "timeout 5" >> /boot/loader/loader.conf && 
echo "console-mode max" >> /boot/loader/loader.conf && 
echo "editor no" >> /boot/loader/loader.conf && 
echo "title Coffee-Linux" > /boot/loader/entries/arch.conf && 
echo "linux /vmlinuz-linux" >> /boot/loader/entries/arch.conf &&
echo "initrd /intel-ucode.img" >> /boot/loader/entries/arch.conf && 
echo "initrd /amd-ucode.img" >> /boot/loader/entries/arch.conf && 
echo "initrd /initramfs-linux.img" >> /boot/loader/entries/arch.conf &&
echo "Presetting default services." && 
#read -n 1 -s -r -p "Press any key to continue" &&
systemctl enable sddm && 
systemctl enable dhcpcd && 
systemctl enable NetworkManager && 
systemctl --global enable pipewire.service pipewire-pulse.service wireplumber.service && 
systemctl enable firewalld
echo $$
EOT
#
echo options root="LABEL=$drivename0" rw nvidia-drm.modeset=1 >> /mnt/boot/loader/entries/arch.conf && 
#
echo "Attempting to fix the home directory automatically now..." && 
arch-chroot /mnt pacman -Sy --noconfirm xdg-user-dirs &&
arch-chroot /mnt xdg-user-dirs-update &&
echo "Installing yay for AUR support" &&
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
#arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y ffnvcodec-headers &&
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y libva-vdpau-driver-vp9-git && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y protontricks && 
#arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y nvidia-vaapi-driver &&  
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y game-devices-udev &&   
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y microsoft-edge-stable &&
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y pamac-aur && 
arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y systemd-kcm && 
#arch-chroot /mnt sudo -Su $user01 yay --nodiffmenu --noremovemake --answerclean y  --answerdiff y --answeredit y --answerupgrade y ttf-ms-win11 &&
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
echo "Ensuring correct DM is set." &&  
arch-chroot /mnt pacman -Syu && 
arch-chroot /mnt systemctl enable sddm && 
echo "Attempting to fix the home directory automatically now..." && 
arch-chroot /mnt pacman -Sy --noconfirm xdg-user-dirs &&
arch-chroot /mnt xdg-user-dirs-update && 
#Phase 5
echo "Cleaning up" &&
rm -R /mnt/home/user02/ && 
cp coffeelinux/opt/microsoft-edge-stable-flags.conf /mnt/home/$user01/.config/ &&
cp coffeelinux/opt/microsoft-edge-stable-flags.conf /mnt/opt/ &&
#cp /usr/local/bin/coffeebrewer /mnt/opt/ &&
#cp /usr/local/bin/coffeebrewer /mnt/usr/local/bin/ &&
cp coffeelinux/opt/os-release /mnt/usr/lib/ && 
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
