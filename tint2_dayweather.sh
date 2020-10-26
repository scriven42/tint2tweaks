#!/bin/bash
# I take this script from Anachron's i3blocks
# I only slightly modify this script to add an option to show icon
# I also remove the i3blocks specify script
# To make this works with tint2 executor, polybar custom script, dzen2 feeder, conkybar, lemonbar feeder, dunst notify, etc.
# 'weather -i' = with icon, 'weather' = text only
# Cheers!
# Addy

top_line=$(date +'%A, %F')

# Open Weather Map API code, register to http://openweathermap.org to get one ;)
API_KEY="25b56469a1599b3cc2215865f5422ea7"

# Check on http://openweathermap.org/find
CITY_ID="5911606"

DATE_FORMAT="+%R"
TEMP_TOOCOLD=0
TEMP_COLDISH=9
TEMP_TOOHOT=26

NEARDARK_TIME=3600

ICON_SUNNY="<b>☼</b> Clear"
ICON_FEWCLOUDS="<b>⛅</b> Few Clouds"
ICON_CLOUDY="<b>☁</b> Cloudy"
ICON_RAINY="<b>☔</b> Rainy"
ICON_STORM="<b>☈</b> Storm"
ICON_SNOW="<b>☃</b> Snow"
ICON_FOG="<b>🌫</b> Fog"
ICON_MISC="<b>❔</b> "

TEXT_SUNNY="Clear"
TEXT_FEWCLOUDS="Few Clouds"
TEXT_CLOUDY="Cloudy"
TEXT_RAINY="Rainy"
TEXT_STORM="Storm"
TEXT_SNOW="Snow"
TEXT_FOG="Fog"

SYMBOL_CELSIUS="˚C"

# http://api.openweathermap.org/data/2.5/weather?id=5911606&appid=25b56469a1599b3cc2215865f5422ea7&units=metric
# {"coord":{"lon":-122.95,"lat":49.27},"weather":[{"id":803,"main":"Clouds","description":"broken clouds","icon":"04d"}],"base":"stations","main":{"temp":12.42,"feels_like":9.86,"temp_min":10.56,"temp_max":13.33,"pressure":1021,"humidity":76},"visibility":10000,"wind":{"speed":3.1,"deg":250},"clouds":{"all":75},"dt":1603231537,"sys":{"type":1,"id":954,"country":"CA","sunrise":1603204880,"sunset":1603242677},"timezone":-25200,"id":5911606,"name":"Burnaby","cod":200}

WEATHER_URL="http://api.openweathermap.org/data/2.5/weather?id=${CITY_ID}&appid=${API_KEY}&units=metric"

# Gather the data
WEATHER_INFO=$(wget -qO- "${WEATHER_URL}")

# Parse out the wanted information
WEATHER_MAIN=$(echo "${WEATHER_INFO}" | grep -o -e '\"main\":\"[A-Za-z]*\"' | awk -F ':' '{print $2}' | tr -d '"')
WEATHER_TEMP=$(echo "${WEATHER_INFO}" | grep -o -e '\"temp\":\-\?[0-9]*' | awk -F ':' '{print $2}' | tr -d '"')
SUNRISE_TIME=$(echo "${WEATHER_INFO}" | grep -o -e '\"sunrise\":\-\?[0-9]*' | awk -F ':' '{print $2}' | tr -d '"')
SUNSET_TIME=$(echo "${WEATHER_INFO}" | grep -o -e '\"sunset\":\-\?[0-9]*' | awk -F ':' '{print $2}' | tr -d '"')
NOW_TIME=$(/bin/date +%s)
TO_SUNRISE=$((SUNRISE_TIME-NOW_TIME))
FROM_SUNRISE=$((NOW_TIME-SUNRISE_TIME))
TO_SUNSET=$((SUNSET_TIME-NOW_TIME))
FROM_SUNSET=$((NOW_TIME-SUNSET_TIME))

# Figure out Sunrise/Sunset markup
SUNRISE_TIME=$(/bin/date -d @$SUNRISE_TIME $DATE_FORMAT)
SUNSET_TIME=$(/bin/date -d @$SUNSET_TIME $DATE_FORMAT)
if (( ${TO_SUNRISE} >= 0 )) ; then
    # Pre Sunrise Darkness
    SUNRISE_TIME="<span underline=\"single\" color=\"pink\">$SUNRISE_TIME</span>"
elif (( ${FROM_SUNRISE} >= 0 )) && (( ${FROM_SUNRISE} <= ${NEARDARK_TIME} )); then
    # Post Sunrise Dawn
    SUNRISE_TIME="<span color=\"pink\">$SUNRISE_TIME</span>"
fi
if (( ${TO_SUNSET} >= 0 )) && (( ${TO_SUNSET} <= ${NEARDARK_TIME} )); then
    # Pre Sunset Dusk
    SUNSET_TIME="<span color=\"orange\">$SUNSET_TIME</span>"
elif (( ${FROM_SUNSET} >= 0 )); then
    # Post Sunset Darkness
    SUNSET_TIME="<span underline=\"single\" color=\"orange\">$SUNSET_TIME</span>"
fi
TAIL_OUTPUT="${SYMBOL_CELSIUS} 🌅$SUNRISE_TIME ⮋$SUNSET_TIME"

# Figure out temperature markup
if (( ${WEATHER_TEMP} <= ${TEMP_TOOCOLD} )); then
    WEATHER_TEMP="<span color=\"cyan\" weight=\"bold\">$WEATHER_TEMP</span>"
elif (( ${WEATHER_TEMP} <= ${TEMP_COLDISH} )); then
    WEATHER_TEMP="<span color=\"yellow\" weight=\"bold\">$WEATHER_TEMP</span>"
elif (( ${WEATHER_TEMP} >= ${TEMP_TOOHOT} )); then
    WEATHER_TEMP="<span color=\"red\" weight=\"bold\">$WEATHER_TEMP</span>"
fi

# Figure out temperature conditions
if [[ "${WEATHER_MAIN}" = *Snow* ]]; then
	if  [[ $1 = "-i" ]]; then
    second_line="${ICON_SNOW} ${WEATHER_TEMP}${TAIL_OUTPUT}"
	else
    second_line="${TEXT_SNOW} ${WEATHER_TEMP}${TAIL_OUTPUT}"
	fi
elif [[ "${WEATHER_MAIN}" = *Storm* ]]; then
	if  [[ $1 = "-i" ]]; then
    second_line="${ICON_STORM} ${WEATHER_TEMP}${TAIL_OUTPUT}"
	else
    second_line="${TEXT_STORM} ${WEATHER_TEMP}${TAIL_OUTPUT}"
	fi
elif [[ "${WEATHER_MAIN}" = *Rain* ]] || [[ "${WEATHER_MAIN}" = *Drizzle* ]]; then
	if  [[ $1 = "-i" ]]; then
    second_line="${ICON_RAINY} ${WEATHER_TEMP}${TAIL_OUTPUT}"
	else
    second_line="${TEXT_RAINY} ${WEATHER_TEMP}${TAIL_OUTPUT}"
	fi
elif [[ "${WEATHER_MAIN}" = *Few* ]]; then
	if  [[ $1 = "-i" ]]; then
    second_line="${ICON_FEWCLOUDS} ${WEATHER_TEMP}${TAIL_OUTPUT}"
	else
    second_line="${TEXT_FEWCLOUDS} ${WEATHER_TEMP}${TAIL_OUTPUT}"
	fi
elif [[ "${WEATHER_MAIN}" = *Cloud* ]]; then
	if  [[ $1 = "-i" ]]; then
    second_line="${ICON_CLOUDY} ${WEATHER_TEMP}${TAIL_OUTPUT}"
	else
    second_line="${TEXT_CLOUDY} ${WEATHER_TEMP}${TAIL_OUTPUT}"
	fi
elif [[ "${WEATHER_MAIN}" = *Clear* ]]; then
	if  [[ $1 = "-i" ]]; then
    second_line="${ICON_SUNNY} ${WEATHER_TEMP}${TAIL_OUTPUT}"
	else
    second_line="${TEXT_SUNNY} ${WEATHER_TEMP}${TAIL_OUTPUT}"
	fi
elif [[ "${WEATHER_MAIN}" = *Fog* ]] || [[ "${WEATHER_MAIN}" = *Mist* ]]; then
	if  [[ $1 = "-i" ]]; then
    second_line="${ICON_FOG} ${WEATHER_TEMP}${TAIL_OUTPUT}"
	else
    second_line="${TEXT_FOG} ${WEATHER_TEMP}${TAIL_OUTPUT}"
	fi
else
	if  [[ $1 = "-i" ]]; then
    second_line="${ICON_MISC} ${WEATHER_MAIN} ${WEATHER_TEMP}${TAIL_OUTPUT}"
	else
    second_line="${WEATHER_MAIN} ${WEATHER_TEMP}${TAIL_OUTPUT}"
	fi	
fi

echo "<b>$top_line</b>
$second_line"

