# Pimp My Raspbian

Install scripts to modify a base Raspbian image.
> Optimized for Singapore users:
> - apt-mirror
> - timezone
> - ntp

## Supported Images/Hardware: What I Use
#### Hardware
- RPI3
- RPI-ZERO
#### Images
Official Raspbian download [page](https://www.raspberrypi.org/downloads/raspbian/)
- Raspbian Jessie
- Raspbian Stretch Lite ( Preferred )
- Raspbian Stretch with Desktop

## Features
- General Settings:
  - Keyboard
  - Locale
  - Timezone
- Essentials:
  - Image Versioning
  - Serial Number
  - NTP
  - Admin User
  - Generic User Group
  - Networking ( Wireless, Ethernet )
- Bonuses:
  - Hardening ( Fail2ban, UFW, Disable `pi` and `root` Users, SSH Pubkey Authentication )
  - Slack Alerts ( Bootup, SSH Login )

## How to Use ( W I P )
1. Clone repository to your machine.
1. Prepare SD card written with downloaded image. [HOWTO](https://www.raspberrypi.org/documentation/installation/installing-images/)
1. Plug the prepared SD card into your computer. It should appear as a `boot` removable drive. Create a empty file `ssh` in the boot folder and eject.
1. Boot RPI with SD card and plug in an ethernet cable. Get the ip address via your router's admin webpage and ssh in with `ssh pi@{IP_ADDRESS}`, pw: `raspberry`.
1. Configure and set `setup.conf`. `INSTALL_DIR` must strictly match the location which the directory will be copied to on the RPI.
1. Copy folder to the RPI path matching the setting of `INSTALL_DIR`. Suggested command: `scp -r LOCAL_DIR_PATH pi@192.168.6.2:/root/DIR_NAME`.
1. Login with `pi` user and change to the `root` user with `sudo su` (  vulnerability will be removed during build ).
1. Navigate to the directory and make setup script executable with `chmod +x setup`.
1. Execute `./setup`. 
