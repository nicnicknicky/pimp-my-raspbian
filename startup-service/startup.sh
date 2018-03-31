#!/bin/bash
set -e # exit on any error

LOG_PATH="/var/log/rpiusergroup/rpiusergroup-services.log"

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
chmod g-x /usr/local/lib/rpiusergroup/*.txt
chmod o-rwx /usr/local/lib/rpiusergroup/*
