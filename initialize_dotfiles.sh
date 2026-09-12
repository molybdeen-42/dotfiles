#!/bin/bash
# This script creates symlinks for all dotfiles

# Initializes the location of the dotfiles on the system and the target location for the configuration files
dotfiles_path="$HOME/dotfiles"
config="$HOME/.config"

echo "[+] Creating symbolic links"

dotfiles=(
	"hypr"
	"kitty"
	"rofi"
	"quickshell"
	"swaync"
	"fish"
	"nvim"
	"themes"
)

for dotfile in ${dotfiles[@]}; do
	echo $dotfile
	if [[ -L "$config/$dotfile" ]] || [[ -d "$config/$dotfile" ]]; then
		echo "[!] $config/$dotfile already exists, can not create symbolic link to $dotfiles_path/$dotfile. Requesting removal..."
		rm -rfi "$config/$dotfile"
	fi

	ln -s "$dotfiles_path/$dotfile" "$config/$dotfile"
done

# starship.toml symlink
if [[ -L "$config/starship.toml" ]] || [[ -f "$config/starship.toml" ]]; then
	echo "[!] $config/starship.toml already exists, can not create symbolic link to $dotfiles_path/starship/starship.toml. Requesting removel..."
	rm -rfi "$config/starship.toml"
fi
ln -s "$dotfiles_path/starship/starship.toml" "$config/starship.toml"

# Reloading configs
echo "[+] Reloading configuration files"
hyprctl reload
swaync-client -R
swaync-client -rs
qs kill
sleep 1
quickshell &
disown
