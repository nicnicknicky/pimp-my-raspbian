#!/bin/bash

# format message as a code block ```${msg}```
SLACK_MESSAGE="\`\`\`$1\`\`\`"
SLACK_URL=https://hooks.slack.com/services/

function post_to_slack () {
  case "$2" in
    LOGIN)
      SLACK_ICON=':unlock:'
      ;;
    LOGOUT)
      SLACK_ICON=':lock:'
      ;;
    WARNING)
      SLACK_ICON=':warning:'
      ;;
    ERROR)
      SLACK_ICON=':bangbang:'
		  ;;
    *)
      SLACK_ICON=':slack:'
      ;;
  esac

  curl -X POST --data-urlencode "payload={\"text\": \"${SLACK_ICON} ${SLACK_MESSAGE}\"}" ${SLACK_URL}
}

DEV_SERIAL=$(cat /proc/cpuinfo | grep Serial | awk '{print $3}')
USER="User: $PAM_USER"
REMOTE="Remote host: $PAM_RHOST"
SERVICE="Service: $PAM_SERVICE"
TTY="TTY: $PAM_TTY"
DATE="Date: `date`"
SERVER="Server: `uname -a`"
LOGINMESSAGE="$PAM_SERVICE login on $DEV_SERIAL for account $PAM_USER"
LOGOUTMESSAGE="$PAM_SERVICE logout on $DEV_SERIAL for account $PAM_USER"

if [[ "$PAM_TYPE" == "open_session" ]]
then
  post_to_slack "${LOGINMESSAGE}\n${USER}\n${REMOTE}\n${SERVICE}\n${TTY}\n${DATE}\n${SERVER}" "LOGIN"
fi

if [[ "$PAM_TYPE" == "close_session" ]]
then
  post_to_slack "${LOGOUTMESSAGE}\n${USER}\n${REMOTE}\n${SERVICE}\n${TTY}\n${DATE}\n${SERVER}" "LOGOUT"
fi

exit 0
