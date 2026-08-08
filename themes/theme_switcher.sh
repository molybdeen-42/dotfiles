#!/bin/bash

exists="false"

if [[ "$1" == "blindfold" ]]; then
   exists="true"
fi
if [[ "$1" == "emerald" ]]; then
   exists="true"
fi
if [[ $exists == "false" ]]; then
   echo "This theme is not supported."
   exit 1
fi

configpath="$HOME/.config"
themepath="$configpath/themes/$1"

echo "Switching theme to $1!"
echo ""

echo "Switching hyprland theme..."
cat "$themepath/hypr/theme.lua" > "$configpath/hypr/theme.lua"

echo "Switching kitty theme..."
cat "$themepath/kitty/theme.conf" > "$configpath/kitty/theme.conf"

echo "Switching quickshell theme..."
cat "$themepath/quickshell/Theme.qml" > "$configpath/quickshell/themes/Theme.qml"

echo "Switching rofi theme..."
cat "$themepath/rofi/colors.rasi" > "$configpath/rofi/themes/colors.rasi"

echo "Switching starship theme..."
cat "$themepath/starship/starship.toml" > "$configpath/starship.toml"

echo "Changing wallpaper..."
cat "$themepath/wallpapers/hyprpaper.conf" > "$configpath/hypr/hyprpaper.conf"
killall hyprpaper && hyprpaper > /dev/null 2>&1 & disown

echo "Theme successfully changed!"