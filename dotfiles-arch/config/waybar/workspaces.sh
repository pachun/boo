#!/bin/bash
ids=$(hyprctl workspaces | grep "workspace ID" | awk '{print $3}' | sort -n)
count=$(echo "$ids" | wc -l)
active=$(hyprctl activeworkspace | grep "workspace ID" | awk '{print $3}')

if [ "$count" -gt 1 ]; then
    for id in $ids; do
        if [ "$id" = "$active" ]; then
            printf '<span color="#c6d0f5">%s</span> ' "$id"
        else
            printf '<span color="#737994">%s</span> ' "$id"
        fi
    done
fi
