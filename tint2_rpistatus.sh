#!/bin/bash
# https://raspberrypi.stackexchange.com/questions/60593/how-raspbian-detects-under-voltage

font_size=20000
OK_SPAN="<span font-size=\"$font_size\" color=\"green\">"
CURRENT_SPAN="<span font-size=\"$font_size\" weight=\"heavy\" color=\"red\" underline=\"error\">"
PAST_SPAN="<span font-size=\"$font_size\" weight=\"bold\" color=\"yellow\">"

AOK_OUTPUT="$OK_SPAN✔️</span>"
CURR_UNDERVOLTAGE_OUTPUT="$CURRENT_SPAN⚡</span>"
PAST_UNDERVOLTAGE_OUTPUT="$PAST_SPAN⚡</span>"
CURR_CAPPED_OUTPUT="$CURRENT_SPAN🌡️</span>"
PAST_CAPPED_OUTPUT="$PAST_SPAN🌡️</span>"
CURR_THROTTLED_OUTPUT="$CURRENT_SPAN🐢</span>"
PAST_THROTTLED_OUTPUT="$PAST_SPAN🐢</span>"

RPISTATUS=(`/opt/vc/bin/vcgencmd get_throttled`) # Get the RPi Status.
THROTTLEVALUE=${RPISTATUS#*=}
if [[ "${THROTTLEVALUE}" = "0x0" ]]; then
	echo "$AOK_OUTPUT"
else
	OUTPUT=""
	OUTPUT+="$CURR_UNDERVOLTAGE_OUTPUT"
	OUTPUT+="$PAST_UNDERVOLTAGE_OUTPUT"
	OUTPUT+="$CURR_CAPPED_OUTPUT"
	OUTPUT+="$PAST_CAPPED_OUTPUT"
	OUTPUT+="$CURR_THROTTLED_OUTPUT"
	OUTPUT+="$PAST_THROTTLED_OUTPUT"
	echo "$OUTPUT"
fi
