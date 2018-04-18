#!/bin/bash
set -e # exit on any error

LOG_PATH="/var/log/rpiusergroup/rpiusergroup-services.log"
BOOT_MOD_CONF_PATH="/boot/raspberry_boot_mod.conf"

# source raspberry_boot_mod.conf file if it exists
# easy method to customise env variables without booting image
function source_boot_mod_config {
  if [[ -e $BOOT_MOD_CONF_PATH ]]; then
    echo "$(date) rpiusergroup-startup.service: source $BOOT_MOD_CONF_PATH to update env variables."
    source $BOOT_MOD_CONF_PATH
  fi
}

# update wpa_supplicant ssid,psk if found in raspberry_boot_mod.conf
function update_wpa_supplicant {
  if [[ ! -z $WLAN_SSID ]] && [[ ! -z $WLAN_WPA_PSK ]]; then
    sed -i "s|ssid.*|ssid=\"$WLAN_SSID\"|g" /etc/wpa_supplicant/wpa_supplicant.conf
    sed -i "s|psk.*|psk=\"$WLAN_WPA_PSK\"|g" /etc/wpa_supplicant/wpa_supplicant.conf
  fi
}

source_boot_mod_config
update_wpa_supplicant

# log boot up
echo "
  _                 _
 | |__   ___   ___ | |_ _   _ _ __
 | '_ \ / _ \ / _ \| __| | | | '_ \\
 | |_) | (_) | (_) | |_| |_| | |_) |
 |_.__/ \___/ \___/ \__|\__,_| .__/
                             |_|    " >> $LOG_PATH
echo "$(date) rpiusergroup-startup.service: rpiusergroup booting up" >> $LOG_PATH
echo "$(date) rpiusergroup-startup.service: current user: $(whoami)" >> $LOG_PATH

# change hostname
CURRENT_HOSTNAME=`cat /etc/hostname`
DESIRED_HOSTNAME=rpiusergroup$(cat /proc/cpuinfo | grep Serial | awk '{print $3}')
if [ "$CURRENT_HOSTNAME" != "$DESIRED_HOSTNAME" ]; then
  echo "$(date) rpiusergroup-startup.service: Changing hostname to "$DESIRED_HOSTNAME >> $LOG_PATH
  echo "$DESIRED_HOSTNAME" > /etc/hostname
  hostname $DESIRED_HOSTNAME
fi

# amend /etc/hosts to add unique hostname
sed -i "/127.0.0.1/c 127.0.0.1 localhost ${DESIRED_HOSTNAME}" /etc/hosts

# change group of apps folder
chgrp rpiusergroup /usr/local/lib/rpiusergroup
chmod g+x /usr/local/lib/rpiusergroup/*
chmod o-rwx /usr/local/lib/rpiusergroup/*
