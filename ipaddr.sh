#!/usr/bin/env bash
BASEDIR=$(dirname "$0")
source "${BASEDIR}/.env"
TMP_FILE="/tmp/ipaddr.tmp"

send_notification() {
  local MESSAGE=$( echo -e "$@" )
  curl -s \
    --form-string "token=${PUSHOVER_TOKEN}" \
    --form-string "user=${PUSHOVER_USER}" \
    --form-string "message=${MESSAGE}" \
    https://api.pushover.net/1/messages.json
}

RESPONSE_JSON=$( curl -s -H 'Accept: application/json' ifconfig.co )

IP_ADDRESS=$( echo "$RESPONSE_JSON" | jq -r .ip )
LOCATION=$( echo "$RESPONSE_JSON" | jq -r '[.country_iso, .city] | join(" ")' )
ASN=$( echo "$RESPONSE_JSON" | jq -r '[.asn, .asn_org] | join(" ")' )

if [ -z "$IP_ADDRESS" ]; then
  exit 1
fi

MESSAGE=$( echo "IP: $IP_ADDRESS \nLocation: $LOCATION \nASN: $ASN" )

if [ -f "$TMP_FILE" ]; then 
  OLD_IP_ADDRESS=$( cat $TMP_FILE )
fi
echo $IP_ADDRESS > $TMP_FILE

if [ "$OLD_IP_ADDRESS" != "$IP_ADDRESS" ]; then 
  send_notification "$MESSAGE"
fi
