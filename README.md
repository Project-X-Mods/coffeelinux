# Coffee Linux v.4.1.1!
[CoffeeLinuxKDE](https://user-images.githubusercontent.com/8603363/191408653-f2142999-5cfc-4edc-9149-3575fa22aa45.png)

![CoffeeLinuxCinnamon](https://user-images.githubusercontent.com/8603363/191624422-beedfdf9-ba44-4d99-87be-2c68a96fa436.png)


What is Coffee Linux? Coffee Linux is a meta-distro similar to Gentoo, but not as painful.
# The idea is that the entire installation process is script based meaning we do not have to worry about releases, old packages being installed or anything like that. 
# This is the cure to the distro hopping. Not kidding lol.

It is Arch Linux at its core, but our specialized installer script takes 99% of the pain out of installing Arch Linux yourself. 
The script downloads and installs everything for you as it goes as you make choices.
It automatically configures everything for you with Arch, SteamOS, and Multilib, Repos enabled by default.
This gives it that coffee flavor. We don't maintain anything but the script, everything else up to respective package maintainers. 

We believe using your PC should be as easy as a sip of coffee, so we fixed it up to be that way for you. No guesswork, it just does what its supposed to do. So kick back, relax and enjoy your cup.

Standard Gamescope+MangoHUD usage in steam:= gamescope -w 1280 -h 720 -W 1920 -H 1080 -f -U -r 144 -- mangohud %command%

==================================================

Instructions are as follows: For most things you just answer "yes" if asked.

The installer has prepared everything in a certain order for your convenience and performance internally.

===============================================================

Execute normal install procedure as follows.

===============================================================

1: Boot a Coffee Linux live iso. [UEFI ONLY]

2: run the installer.

3: enter your username, drive id, and partition numbers (easy to find out)

4: partition the drive chosen with fdisk. (you need 1G for efi bootloader, and the rest of the drive for the OS/Home.)

5: hit yes alot when asked , same with passwords lol.

6: let it do its thing. Most of it is automated for you.

7: set the root password, and user password.

8: yay installs come next (they will ask for the user password alot, sorry).

9: it will copy over coffee related files to /opt and user home directories, then reboot automattically if successful.

10: Login, open chromium once, then reboot.

That should finish it off for you. Enjoy your Coffee. Spread the word! Coffee is hot over here.

Hashtags:
#GamingOnLinux #ArchGaming #SteamLinux #ArchInstaller #CoffeeLinux

==================================================

[Detailed-Description]

==================================================

Key Features: Arch-Based, BTRFS installation, SteamOS-Infused Desktop Environment (KDE, Gnome, or Cinnamon) , Pipewire, VAAPI on Edge (with game streaming in mind)** , FirewallD, and SystemD-Boot.

A script/command designed to install a unique Coffee-Linux Experience via Arch easily, and semi painlessly.

This Installer will create a Coffee-Linux install on the fly. Requires internet.
 
[Notable Feature] 
0: Home made and tested installer script.

0a. Somehow.. in our tests of games like Elite Dangerous, The Forest, and No Mans Sky.. I am seeing a real significant fps improvement over Linux Mint 22 (Vanessa) Cinnamon, Ubuntu 22.04.1 LTS, Fedora 36 Workstation, Manjaro (KDE, and Gnome).
Example: 

The Forest on Ubuntu ran at ~45-55fps (on my hardware)[This is a known horrible performing game on Linux, so I knew this was the test I had to conduct.]

The Forest on Coffee Linux 2.1.0 ran at ~75-120fps, exact same settings, same installation of the game even on a second drive.

0b. This is a massive gain and its worth mentioning this was tested on a "GTX 1660" @ 1920x1080 144hz Display default settings except vsync = on in game. This installation script must just do it right or something lol.

0c. I personally (LiquidSmokeX64) test every build script on my own home pc just to be certain it works as intended.

1. Pure Arch foundation using official repos (and a little AUR here and there)

2. A choice of Desktop Environments designed to be easy to use. (Always the latest version due to Arch being a rolling release.)

2a. Coffee wallpapers in default location.

3. Vaapi enabled by default in Chromium**

4. Pamac Graphical Software Manager (Select "1 4" in part 4 when prompted for pamac-aur for full functionality)

5. Chromium Preinstalled via yay (not Firefox)

6. Latest Pipewire & Wireplumber for the best possible sound.

7. Many gaming frameworks/dependencies preinstalled so you can get to it right away.

8. Prebuilt with Steam, Wine, Winetricks, and Protontricks for the best possible gaming experiences out of the box.

9. SystemD boot (as opposed to GRUB).

10. Yay for CLI installation of AUR applications.

11. FirewallD (Better configuration than the standard one)

** VAAPI requires copying chromium-flags file in $drivename/opt to your ~/.config folder **

Note: This is designed for PCs with UEFI enabled.

Note-2 You will have to use fdisk to prepare your drive during installation.

===============================================================

Like, Share, and Enjoy. Our Linux is the cure.

===============================================================

