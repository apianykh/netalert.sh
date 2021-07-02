#!/usr/bin/env bash
BASEDIR=$(dirname "$0")
source "${BASEDIR}/.env"

send_notification() {
  local MESSAGE=$( echo -e "$@" )
  curl -s \
    --form-string "token=${PUSHOVER_TOKEN}" \
    --form-string "user=${PUSHOVER_USER}" \
    --form-string "message=${MESSAGE}" \
    https://api.pushover.net/1/messages.json
}

RESPONSE_JSON=$( speedtest -s ${SPEEDTEST_SERVER_ID} -f json )

ISP=$( echo "$RESPONSE_JSON" | jq -r .isp )
SERVER=$( echo "$RESPONSE_JSON" | jq -r '.server | [.location, .name] | join(" ")' )
DOWNLOAD_SPEED=$( echo "$RESPONSE_JSON" | jq -c '.download.bandwidth/125000 | round' )
UPLOAD_SPEED=$( echo "$RESPONSE_JSON" | jq -c '.upload.bandwidth/125000 | round' )

MESSAGE=$( printf "Download: ${DOWNLOAD_SPEED} Mbps \nUpload Speed: ${UPLOAD_SPEED} Mbps \nFrom: $ISP \nTo:$SERVER" )

send_notification $MESSAGE