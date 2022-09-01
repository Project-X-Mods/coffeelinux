# Coffee-Linux (Script-Installed Arch-Linux for Gamers)

What is Coffee Linux? Coffee Linux is a meta-distro similar to Gentoo, but not as painful.
The idea is that everything is script based meaning we do not have to worry about releases, old packages being installed or anything like that.
It is Arch, but our specialized installer script takes 99% of the pain out of installing Arch Linux yourself. 
This also means there is no special iso needed, the script downloads and installs everything for you as it goes as you make choices.
This gives it that coffee flavor. We don't maintain anything but the script, everything else is not on us. 

We believe using your PC should be as easy as a sip of coffee, so we fixed it up to be that way for you. No guesswork, it just does what its supposed to do. So kick back, relax and enjoy your cup.

==================================================

Instructions are as follows: For most things you just answer yes if asked 
I have already prepared everything in a certain order for your convenience internally.

==================================================

Cloning Method for Installation.

==================================================

1a:  Boot an official Arch Linux ISO in UEFI mode.

2a: Enter: pacman -Syy

3a: Enter: pacman -Syy --noconfirm archlinux-keyring

4a: Enter: pacman -S --noconfirm git

5a: Enter: git clone https://github.com/Project-X-Mods/coffeelinux.git

6a: Enter: bash coffeelinux/opt/coffeebrewer.sh

===============================================================

Execute normal install procedure as follows.

===============================================================

1: Boot an Arch Linux live iso. [UEFI ONLY]
1a: clone the repo as described above.

2: run the installer, "bash coffeelinux/opt/coffeebrewer.sh"

3: enter your username, drive id, and partition numbers (easy to find out)

4: partition the drive chosen with fdisk. (you need 1G for efi, 8~64G for swap, and the rest of the drive for the OS/Home.)

5: hit yes alot when asked lol.

6: remove the "#" from the multilib entries in the file it brings up (if needed), ctrl+s,ctrl+x to save and exit the editor.

7: let it do its thing. make choices involving pipewire and fonts, stupid stuff like that.

8: set the root password, user password, and the temp user password (needed to automate yay install).

9: enter the temp user password a few times.

10: yay installs come next (they will ask for the user password alot, sorry).

11: it will fix gdm, and copy over coffee related files to /opt and user home directories, then reboot automattically if successful.

12: Login, open chrome once (it will likely fail, this is normal), then reboot.

That should finish it off for you. Enjoy your Coffee. Spread the word! Coffee is hot over here.

Hashtags:
#GamingOnLinux #ArchGaming #SteamLinux #ArchInstaller #CoffeeLinux

==================================================

[Detailed-Description]

==================================================

Key Features: Arch-Based, BTRFS installation, Gnome or Desktop Environment, Pipewire, VAAPI on Chrome (with game streaming in mind), FirewallD, and SystemD-Boot.

A script/command designed to install a unique Coffee-Linux Experience via Arch easily, and semi painlessly.
(premade Stadia app is located in /opt folder. Place the stadia app file in ~/.local/share/applications/ folder. and reboot after launching chrome and it fails once. Enjoy.)

This Installer will create a Coffee-Linux install on the fly. Requires internet.

Features: 
1. Pure Arch foundation using official repos (and a little AUR here and there)

2. A Desktop Environment designed to be modern, yet familiar in all the right ways. (Always the latest version due to Arch being a rolling release.)

2a. Coffee wallpapers in default location (might need to be set manually).

3. Uses nvidia-open driver (not the dkms proprietary older package)(not nouveau either lol)

4. Vaapi enabled by default in Chrome/Chromium.

5. Pamac Graphical Software Manager (Select "1 4" in part 4 when prompted for pamac-aur for full functionality)

6. Chrome Preinstalled via yay (not Firefox)

7. Latest Pipewire & Wireplumber for the best possible sound.

8. Many gaming frameworks/dependencies preinstalled so you can get to it right away.

9. Prebuilt with Steam, Wine, Winetricks, Protontricks, and DXVK for the best possible gaming experiences out of the box.

10. SystemD boot (as opposed to GRUB).

11. Yay for CLI installation of AUR applications.

12. FirewallD (Better configuration than the standard one)

13. Mint themes and sounds.

14. Yaru Themes and sounds from Ubuntu.

Note: This is designed for PCs with UEFI, Intel CPUs, and Nvidia GPUs, AMD install WILL LIKELY fail because absolutely no AMD specific packages are installed.

Note-3: You will have to use fdisk to prepare your drive during installation.

===============================================================

Like, Share, and Enjoy. Our Linux is the cure.

===============================================================
