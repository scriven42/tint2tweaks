#!/bin/bash

font_size=11500

# First Line:

# CPU Used
# from tint2_usedcpu.sh
# Source: http://askubuntu.com/a/450136
# I only slightly modify this script to add an option to show icon, useful for my tint2 executor
# Also useful for polybar custom script, dzen2 feeder, conkybar, lemonbar feeder, dunst notify, etc.
# 'usedcpu -i' = with icon, 'usedcpu' = text only
# Cheers!
# Addy

PREV_TOTAL=0
PREV_IDLE=0
VBUSY_PERCENT=85
BUSY_PERCENT=50
PEAKED_SPAN="<span weight=\"heavy\" color=\"red\" underline=\"error\">"
VBUSY_SPAN="<span weight=\"bold\" color=\"red\">"
BUSY_SPAN="<span weight=\"bold\" color=\"yellow\">"

cpuFile="/tmp/.cpu"

if [[ -f "${cpuFile}" ]]; then
  fileCont=$(cat "${cpuFile}")
  PREV_TOTAL=$(echo "${fileCont}" | head -n 1)
  PREV_IDLE=$(echo "${fileCont}" | tail -n 1)
fi

CPU=(`cat /proc/stat | grep '^cpu '`) # Get the total CPU statistics.
unset CPU[0]                          # Discard the "cpu" prefix.
IDLE=${CPU[4]}                        # Get the idle CPU time.

# Calculate the total CPU time.
TOTAL=0

for VALUE in "${CPU[@]:0:4}"; do
  let "TOTAL=$TOTAL+$VALUE"
done

if [[ "${PREV_TOTAL}" != "" ]] && [[ "${PREV_IDLE}" != "" ]]; then
  # Calculate the CPU usage since we last checked.
  let "DIFF_IDLE=$IDLE-$PREV_IDLE"
  let "DIFF_TOTAL=$TOTAL-$PREV_TOTAL"
  let "DIFF_USAGE=(1000*($DIFF_TOTAL-$DIFF_IDLE)/$DIFF_TOTAL+5)/10"
        if  (($DIFF_USAGE >= 100 )); then
            DIFF_USAGE="$PEAKED_SPAN$DIFF_USAGE</span>"
        elif  (($DIFF_USAGE >= $VBUSY_PERCENT )); then
            DIFF_USAGE="$VBUSY_SPAN$DIFF_USAGE</span>"
        elif (($DIFF_USAGE >= $BUSY_PERCENT )); then
            DIFF_USAGE="$BUSY_SPAN$DIFF_USAGE</span>"
        fi

  	if  [[ $1 = "-i" ]]; then
    cpu_used="  ${DIFF_USAGE}%"
	else
    cpu_used="${DIFF_USAGE}%"
	fi
else
  	if  [[ $1 = "-i" ]]; then
    cpu_used="  ?"
	else
    cpu_used="?"
	fi
fi

# Remember the total and idle CPU times for the next check.
echo "${TOTAL}" > "${cpuFile}"
echo "${IDLE}" >> "${cpuFile}"

# CPU Temp
HIGH_TEMP=80
WARN_TEMP=60
temp=$(</sys/class/thermal/thermal_zone0/temp)
cputemp=`echo "$temp/1000"|bc -l`
cputemp=`printf "%.*f" 3 "$cputemp"`
cpu_temp=''

if (( $(echo "$cputemp > $HIGH_TEMP"|bc -l) )); then
    cpu_temp+="<b><i><u><span fgcolor=\"red\">$cputemp°C</span></u></i></b>"
elif (( $(echo "$cputemp > $WARN_TEMP"|bc -l) )); then
    cpu_temp+="<b><span fgcolor=\"orange\">$cputemp°C</span></b>"
else
    cpu_temp+="$cputemp°C"
fi

# Construct top line variable
top_line="<b>CPU:</b> $cpu_used <b>|</b> $cpu_temp"

# Second Line:
# Used_ram part
# from tint2_usedram.sh found through searching:
# this script is taken from screenfetch
# I only slightly modify this script to add an option to show icon, useful for my tint2 executor
# 'usedram -i' = with icon, 'usedram' = text only
# 'usedram -fi' = full summary with icon, 'usedram' = full summary text only
# Cheers!
# Addy

mem_info=$(</proc/meminfo)
		mem_info=$(echo $(echo $(mem_info=${mem_info// /}; echo ${mem_info//kB/})))
		for m in $mem_info; do
			case ${m//:*} in
				"MemTotal") usedmem=$((usedmem+=${m//*:})); totalmem=${m//*:} ;;
				"ShMem") usedmem=$((usedmem+=${m//*:})) ;;
				"MemFree"|"Buffers"|"Cached"|"SReclaimable") usedmem=$((usedmem-=${m//*:})) ;;
			esac
		done
		usedmem=$((usedmem / 1024))
		totalmem=$((totalmem / 1024))
		mem="${usedmem}<b>/</b>${totalmem}MB"

## Complete summary
	if  [[ $1 = "-fi" ]]; then
    second_line=" $mem"
	elif [[ $1 = "-f" ]]; then
    second_line="<b>RAM:</b>$mem"
    
## Only used RAM
	elif  [[ $1 = "-i" ]]; then
    second_line=" $usedmem MB"
	else
    second_line="<b>RAM:</b>$usedmem MB"
	fi

# Final Output
#
echo "<span size=\"$font_size\">$top_line</span>
<span size=\"$font_size\">$second_line</span>"

