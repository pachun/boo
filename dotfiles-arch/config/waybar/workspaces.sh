#!/bin/bash
ids=$(hyprctl workspaces | grep "workspace ID" | awk '{print $3}' | sort -n)
count=$(echo "$ids" | wc -l)
active=$(hyprctl activeworkspace | grep "workspace ID" | awk '{print $3}')

text=""
for id in $ids; do
    if [ "$id" = "$active" ]; then
        text+="<span color=\\\"#c6d0f5\\\">$id</span> "
    else
        text+="<span color=\\\"#737994\\\">$id</span> "
    fi
done
echo "{\"text\": \"$text\"}"
