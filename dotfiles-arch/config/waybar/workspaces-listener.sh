#!/bin/bash
# Send initial signal
pkill -RTMIN+9 waybar

# Listen for workspace events and signal waybar
socat -u "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" - | while read -r line; do
    case $line in
        workspace*|createworkspace*|destroyworkspace*)
            pkill -RTMIN+9 waybar
            ;;
    esac
done
