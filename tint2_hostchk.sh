#!/bin/bash

FONT_SIZE=9800
PING_COUNT=1
PING_TIMEOUT=1
HEAD_OK="200 OK"
DATE_NOW=$(date +%s)
LOG_TYPE="Down"
LOG_FILE="/home/pi/bin/tint2_hostchk.log"
LOG_OUTPUT=""
LOG_ON_SPAN="<span font-size=\"$FONT_SIZE\" color=\"orange\">"
LOG_OFF_SPAN="<span font-size=\"$FONT_SIZE\" color=\"yellow\">"
DOWN_SPAN="<span font-size=\"$FONT_SIZE\" color=\"red\">"
UP_SPAN="<span font-size=\"$FONT_SIZE\" color=\"green\">"

hosts=( https://makercave.ca/,mcave.ca,head 192.168.1.254,router,ping 192.168.1.1,dlinkap,ping betapi,betapi,ping controller,controller,ping )
for i in "${hosts[@]}"; do
    IFS=',' read -ra curhost <<< "$i"
    hostname=${curhost[0]}
    dispname=${curhost[1]}
    testtype=${curhost[2]}
    if [[ $testtype == "ping" ]]; then
        if ping -c $PING_COUNT -W $PING_TIMEOUT $hostname > /dev/null ; then
            echo "$UP_SPAN$dispname</span>"
            if [[ $LOG_TYPE != "Down" ]]; then
                LOG_OUTPUT+="$hostname,UP "
            fi
        else
            echo "$DOWN_SPAN$dispname</span>"
            LOG_OUTPUT+="$hostname,DOWN "
        fi
    elif [[ $testtype == "head" ]]; then
        if HEAD $hostname | grep "$HEAD_OK" > /dev/null ; then
            echo "$UP_SPAN$dispname</span>"
            if [[ $LOG_TYPE != "Down" ]]; then
                LOG_OUTPUT+="$hostname,UP "
            fi
        else
            echo "$DOWN_SPAN$dispname</span>"
            LOG_OUTPUT+="$hostname,DOWN "
        fi
    fi
done
if [[ $LOG_TYPE == "False" ]]; then
    echo "${LOG_OFF_SPAN}Log: OFF</span>"
elif [[ $LOG_TYPE == "Down" ]]; then
    if [[ $LOG_OUTPUT != "" ]]; then
        echo $DATE_NOW $LOG_OUTPUT >> $LOG_FILE;
    fi
    echo "${LOG_ON_SPAN}Log: DWN</span>"
else
    echo $DATE_NOW $LOG_OUTPUT >> $LOG_FILE;
    echo "${LOG_ON_SPAN}Log: ON</span>"
fi

