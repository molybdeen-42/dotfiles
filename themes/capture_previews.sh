#!/bin/bash

sleep 5

themes=("blindfold" "copper" "forest" "city" "frog" "mirror" "moon")
output="eDP-1"
previewdir="$HOME/.config/themes/previews"

original=$(cat "$HOME/.config/themes/current_theme.txt")

restore() {
	/bin/bash "$HOME/.config/themes/change_theme.sh" "$original" -r &> /dev/null
}
trap restore EXIT

mkdir -p "$previewdir"

for theme in "${themes[@]}"; do
	echo "Capturing $theme..."
	/bin/bash "$HOME/.config/themes/change_theme.sh" "$theme" -r &> /dev/null
	
	sleep 5
	grim -o "$output" "$previewdir/$theme.png"
done

echo "Previews saved to $previewdir"
