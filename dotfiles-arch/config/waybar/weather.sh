#!/bin/bash
cache_file="/tmp/waybar-weather-cache"

# Wait for network connectivity (max 30 seconds)
for i in {1..15}; do
    if ping -c 1 -W 1 1.1.1.1 &>/dev/null; then
        break
    fi
    sleep 2
done

# Fetch weather and sun times from wttr.in (5 second timeout)
weather=$(curl -sf --max-time 10 "wttr.in/?format=%t+%c+%s+%S" 2>/dev/null)

if [ -n "$weather" ]; then
    # Extract temp
    temp=$(echo "$weather" | grep -oE '[+-]?[0-9]+°[CF]' | sed 's/^+//' | sed 's/[CF]$//')

    # Use Nerd Font icons for consistency with rest of waybar
    condition=$(curl -sf --max-time 10 "wttr.in/?format=%C" 2>/dev/null | tr '[:upper:]' '[:lower:]')
    case "$condition" in
        *clear*|*sunny*) icon="󰖙" ;;
        *cloud*) icon="󰖐" ;;
        *rain*|*drizzle*) icon="󰖗" ;;
        *thunder*|*storm*) icon="󰖓" ;;
        *snow*) icon="󰖘" ;;
        *fog*|*mist*) icon="󰖑" ;;
        *) icon="󰖐" ;;
    esac

    # Check if it's night (after sunset or before sunrise)
    # Format is %s+%S = sunset then sunrise
    sunset=$(echo "$weather" | grep -oE '[0-9]{2}:[0-9]{2}:[0-9]{2}' | head -1)
    sunrise=$(echo "$weather" | grep -oE '[0-9]{2}:[0-9]{2}:[0-9]{2}' | tail -1)
    now=$(date +%H:%M:%S)

    if [[ "$now" > "$sunset" ]] || [[ "$now" < "$sunrise" ]]; then
        icon="󰖔"
    fi

    result="$icon $temp"
    echo "$result" > "$cache_file"
    echo "$result"
elif [ -f "$cache_file" ]; then
    # Fetch failed, use cached result
    cat "$cache_file"
fi
