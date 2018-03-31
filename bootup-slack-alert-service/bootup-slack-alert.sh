#!/bin/bash

LOG_PATH="/var/log/rpiusergroup/rpiusergroup-services.log"
BOOTUP_SLACK_RETRY_COUNT=0
# format message as a code block ```${msg}```
SLACK_MESSAGE="\`\`\`$1\`\`\`"
SLACK_URL=https://hooks.slack.com/services/
SLACK_ICON=':sun_small_cloud:'

function post_to_slack () {
  curl -X POST --data-urlencode "payload={\"text\": \"${SLACK_ICON} ${SLACK_MESSAGE}\", \"username\": \"BOOTUP-WATCH\", \"icon_emoji\": \":sun_with_face:\"}" ${SLACK_URL}
  if [[ $? -ne 0 ]]; then
    echo "$(date) bootup-slack-alert.service: Failed to trigger slack alert on boot." >> $LOG_PATH
    BOOTUP_SLACK_RETRY_COUNT=$((BOOTUP_SLACK_RETRY_COUNT+1))
  else
    exit 0
  fi
}

DEV_SERIAL="Device Serial: $(cat /proc/cpuinfo | grep Serial | awk '{print $3}')"
DATE="Date: `date`"
SERVER="Server: `uname -a`"
UPTIME="Uptime: $(uptime | cut -d "," -f1)"
IMG_VERSION="Image Version: $(cat /etc/raspbian_mod_image_version)"
# try for 10mins, 20sec intervals
until [[ $BOOTUP_SLACK_RETRY_COUNT -ge 30 ]]
do
  post_to_slack "${DEV_SERIAL}\n${DATE}\n${SERVER}\n${UPTIME}\n${IMG_VERSION}"
  sleep 20
done
exit 1
