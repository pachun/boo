#!/bin/bash
cache_file="/tmp/waybar-weather-cache"

# Fetch weather and sun times from wttr.in (5 second timeout)
weather=$(curl -sf --max-time 10 "wttr.in/?format=%t+%c+%s+%S" 2>/dev/null)

if [ -n "$weather" ]; then
    # Extract temp and condition icon
    temp=$(echo "$weather" | grep -oE '[+-]?[0-9]+°[CF]' | sed 's/^+//' | sed 's/[CF]$//')
    icon=$(echo "$weather" | grep -oE '[☀☁⛅⛈🌧🌦🌩🌨❄🌫💨]' | head -1)

    # Fallback icons if wttr.in icons don't work
    if [ -z "$icon" ]; then
        condition=$(curl -sf --max-time 10 "wttr.in/?format=%C" 2>/dev/null | tr '[:upper:]' '[:lower:]')
        case "$condition" in
            *clear*|*sunny*) icon="☀" ;;
            *cloud*) icon="☁" ;;
            *rain*|*drizzle*) icon="🌧" ;;
            *thunder*|*storm*) icon="⛈" ;;
            *snow*) icon="❄" ;;
            *fog*|*mist*) icon="🌫" ;;
            *) icon="☁" ;;
        esac
    fi

    # Check if it's night (after sunset or before sunrise)
    sunrise=$(echo "$weather" | grep -oE '[0-9]{2}:[0-9]{2}:[0-9]{2}' | head -1)
    sunset=$(echo "$weather" | grep -oE '[0-9]{2}:[0-9]{2}:[0-9]{2}' | tail -1)
    now=$(date +%H:%M:%S)

    if [[ "$now" > "$sunset" ]] || [[ "$now" < "$sunrise" ]]; then
        case "$icon" in
            ☀|⛅) icon="🌙" ;;
        esac
    fi

    result="$icon $temp"
    echo "$result" > "$cache_file"
    echo "$result"
elif [ -f "$cache_file" ]; then
    # Fetch failed, use cached result
    cat "$cache_file"
fi
