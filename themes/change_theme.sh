#!/bin/bash

exists="false"
current=$(cat "$HOME/.config/themes/current_theme.txt")

if [[ "$1" == "$current" ]]; then
	echo "This is the current theme"
	if [[ "$2" != "-r" ]]; then
		exit 1
	fi
fi
if [[ "$1" == "blindfold" ]]; then
	exists="true"
fi
if [[ "$1" == "copper" ]]; then
	exists="true"
fi
if [[ "$1" == "spooky" ]]; then
	exists="true"
fi
if [[ "$1" == "forest" ]]; then
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
echo "$1" >"$configpath/themes/current_theme.txt"

echo "Switching hyprland theme..."
cat "$themepath/hypr/theme.lua" >"$configpath/hypr/theme.lua"

echo "Switching kitty theme..."
cat "$themepath/kitty/theme.conf" >"$configpath/kitty/theme.conf"

echo "Switching quickshell theme..."
cat "$themepath/quickshell/Theme.qml" >"$configpath/quickshell/themes/Theme.qml"

echo "Switching rofi theme..."
cat "$themepath/rofi/colors.rasi" >"$configpath/rofi/themes/colors.rasi"

echo "Switching starship theme..."
cat "$themepath/starship/starship.toml" >"$configpath/starship.toml"

echo "Switching nvim theme..."
cat "$themepath/nvim/theme.lua" >"$configpath/nvim/lua/theme.lua"

cat "$themepath/wallpapers/hyprpaper.conf" >"$configpath/hypr/hyprpaper.conf"
cat "$themepath/hypr/hyprlock.conf" >"$configpath/hypr/hyprlock.conf"

if [[ "$2" == "-r" ]]; then
	echo "Reloading completed"
	exit
fi

cat "$themepath/wallpapers/hyprpaper.conf" >"$configpath/hypr/hyprpaper.conf"
cat "$themepath/hypr/hyprlock.conf" >"$configpath/hypr/hyprlock.conf"
echo "Wallpapers changed"
awww img --transition-type grow --transition-duration 2 --transition-step 90 --transition-pos 0.8,0.7 -o eDP-1 "$themepath/wallpapers/${1}_1_2880x1920.png" &
awww img --transition-type grow --transition-duration 2 --transition-step 90 --transition-pos 0.8,0.7 -o DP-11 "$themepath/wallpapers/${1}_1_2560x1440.png" &
awww img --transition-type grow --transition-duration 2 --transition-step 90 --transition-pos 0.8,0.7 -o DP-9 "$themepath/wallpapers/${1}_1_1440x2560.png" &
wait

echo ""
echo "Theme successfully changed!"
