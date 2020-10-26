#!/bin/bash
# https://raspberrypi.stackexchange.com/questions/60593/how-raspbian-detects-under-voltage

font_size=11500
icon_size=13000
medicon_size=15000
largeicon_size=20000

RED_SPAN="<span color=\"red\">"
NORMAL_SPAN="<span font-size=\"$font_size\">"
ICON_SPAN="<span font-size=\"$icon_size\">"
MEDICON_SPAN="<span font-size=\"$medicon_size\">"
LARGEICON_SPAN="<span font-size=\"$largeicon_size\">"
ERROR_SPAN="<span font-size=\"$font_size\" weight=\"heavy\" color=\"red\" underline=\"error\">"
WARNING_SPAN="<span font-size=\"$font_size\" weight=\"bold\" color=\"yellow\">"

BATTERY_ICON="<span font-size=\"$icon_size\">🔋</span>"

NODEVICE_SUB="No raw devices found."
MOUNT_SUB="/media/pi/s9"

OUTPUT=" $LARGEICON_SPAN📱</span>"
ERRORX_OUTPUT="$ERROR_SPAN❌</span>"

MOUNTDETECT=$(mount)

if [[ "$MOUNTDETECT" == *"$MOUNT_SUB"* ]]; then
    OUTPUT+="$MEDICON_SPAN🖴</span>"
else
    MTPDETECT=$(mtp-detect)
#    if [[ $? ]]; then
#        OUTPUT+="$ERRORX_OUTPUT"
#        echo "$OUTPUT"
#        exit
#    else
        if [[ "$MTPDETECT" != *"$NODEVICE_SUB"* ]]; then
            # Determine Battery Level
            SUB="Battery level"
            BATTERYSTATUS=$(grep "$SUB" <<< "$MTPDETECT")
            BATTERYSTATUS=${BATTERYSTATUS#*(}
            BATTERYSTATUS=${BATTERYSTATUS%\%*}
            if  (($BATTERYSTATUS > 15 )); then
                BATTERYSTATUS="$NORMAL_SPAN$BATTERYSTATUS</span>"
            elif  (($BATTERYSTATUS > 5 )); then
                BATTERYSTATUS="$WARNING_SPAN$BATTERYSTATUS</span>"
            else
                BATTERYSTATUS="$ERROR_SPAN$BATTERYSTATUS</span>"
            fi
            OUTPUT+="$BATTERY_ICON$BATTERYSTATUS%"
        else
            OUTPUT+="$ERROR_SPAN❌</span>"
        fi
#    fi
fi
echo "$OUTPUT"
