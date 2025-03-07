#!/usr/bin/env bash

THEME_FILE="$HOME/.config/theme"
GHOSTTY_CONFIG="$HOME/.config/ghostty/config"
NEOVIM_LUA="$HOME/.config/nvim/lua/config/pachulski/theme.lua"

theme() {
  awk -F= -v section="[$1]" -v key="$2" '
  BEGIN { found=0 }
  /^[[:space:]]*#/ { next }   # Skip comment lines
  $0 == section { found=1; next } 
  found && $1 ~ key { gsub(/^[[:space:]]+|[[:space:]]+$/, "", $2); print $2; exit }
  ' "$THEME_FILE" | tr -d '\n'
}

GHOSTTY_DARK=$(theme "ghostty" "dark")
GHOSTTY_LIGHT=$(theme "ghostty" "light")

NVIM_DARK_THEME=$(theme "nvim" "dark_theme")
NVIM_DARK_STYLE=$(theme "nvim" "dark_style")
NVIM_LIGHT_THEME=$(theme "nvim" "light_theme")
NVIM_LIGHT_STYLE=$(theme "nvim" "light_style")

TEMP_GHOSTTY=$(mktemp)
grep -v '^theme = ' "$GHOSTTY_CONFIG" > "$TEMP_GHOSTTY"
echo "theme = dark:${GHOSTTY_DARK},light:${GHOSTTY_LIGHT}" >> "$TEMP_GHOSTTY"
mv "$TEMP_GHOSTTY" "$GHOSTTY_CONFIG"

mkdir -p "$(dirname "$NEOVIM_LUA")"
cat > "$NEOVIM_LUA" <<EOF
-- do not edit this file directly
--
-- this file is auto-generated by update-theme.sh
--
-- edit ~/.config/theme to change your nvim theme

return {
  dark = {
    name = "$NVIM_DARK_THEME",
    style = "$NVIM_DARK_STYLE",
  },
  light = {
    name = "$NVIM_LIGHT_THEME",
    style = "$NVIM_LIGHT_STYLE",
  },
}
EOF
