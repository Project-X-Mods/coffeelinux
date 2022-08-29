# Coffee-Linux (Script-Installed Arch-Linux for Gamers)
[Description]
Key Features: Arch-Based, BTRFS installation, Hybridized Desktop Environment/s, Pipewire, VAAPI on Chrome (with game streaming in mind), FirewallD, and SystemD-Boot.

A script/command designed to install a unique Coffee-Linux Experience via Arch easily, and semi painlessly.
(premade Stadia app is located in /opt folder. Place the stadia app file in ~/.local/share/applications/ folder. and reboot after launching chrome and it fails once. Enjoy.)

This Installer will create a Coffee-Linux install on the fly. Requires internet.

(source files : https://github.com/Project-X-Mods/coffeelinux/releases/tag/Releases)

Features: 
1. Pure Arch foundation using official repos (and a little AUR here and there)
1a. Built on a running version of itself. archiso was used : project github: https://github.com/archlinux/archiso

2. A Cinnamon/Gnome Desktop Environment to be modern, yet familiar in all the right ways. (Always the latest version/s due to Arch being a rolling release.)

2a. Coffee wallpapers in default location (might need to be set manually).

2b. Blended Cinnamon DE w/Gnome built in as well, uses GDM and Mutter to be different than Mint in some other ways lol.

3/4. Linux Mint Themes, Sounds, Icons, and Backgrounds installed via yay during os install.

5. Pamac Graphical Software Manager (Select "1 4" in part 4 when prompted for pamac-aur for full functionality)

6. Chrome Preinstalled via yay (not Firefox)

7. Latest Pipewire & Wireplumber for the best possible sound.

8. Many gaming frameworks preinstalled so you can get to it right away.

9. Prebuilt with Steam, Wine, Winetricks, Protontricks, and DXVK for the best possible gaming experiences out of the box.

10. SystemD boot (as opposed to GRUB).

11. Yay for CLI installation of AUR applications.

12. FirewallD (Better configuration than the standard one)

13. Easy install via Installer on desktop (must be altered to executable/trusted)

13a. Open Desktop as root (right-click anywhere) and launch the installer way because it needs elevated privlages to install the OS.

Note: This is designed for PCs with UEFI, Intel CPUs, and Nvidia GPUs, AMD install WILL LIKELY fail because absolutely no AMD specific packages are installed.

Note-3: You will have to use fdisk to prepare your drive during installation.

=======================================================================================================

Instructions are as follows: For most things you just answer yes to if asked as I have already prepared everything in a certain order for your convenience.

1: Boot a Coffee Linux live iso (live environment is still a WIP but works fine for what its really needed for lol.). [UEFI ONLY]

1a: download link to mega: [Link Redacted][Fixing a bug]

2: run the installer, (or run "sudo bash coffeebrewer" in terminal)

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

==================================================

Alternate Method

==================================================

1a:  Boot an official Arch Linux ISO in UEFI mode.

2a: Enter: pacman -Syy

3a: Enter: pacman -Syy --noconfirm archlinux-keyring

4a: Enter: pacman -S --noconfirm git

5a: Enter: git clone https://github.com/Project-X-Mods/coffeelinux.git

6a: Enter: bash coffeelinux/opt/coffeebrewer.sh

===============================================================

follow normal installer procedure from step 2 of the live iso.

===============================================================

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
