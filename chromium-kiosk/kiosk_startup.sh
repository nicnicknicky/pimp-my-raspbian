#!/bin/bash

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

# launch chromium kiosk on startup
CHROMIUM_URL=""
CHROMIUM_FLAGS=""
source_boot_mod_config  # source configuration from raspberry_boot_mod.conf
/usr/bin/chromium-browser $CHROMIUM_FLAGS $CHROMIUM_URL
