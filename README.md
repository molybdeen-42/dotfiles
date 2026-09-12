
# molybdeen's dotfiles

Welcome to my dotfiles! :) Please be sure to implement your screen layout in `/hypr/hyprland.lua`

## how to install

To start using these dotfiles please follow these steps:

- Clone this repository to your home directory: `git clone https://github.com/molybdeen-42/dotfiles.git $HOME`
- `cd $HOME/dotfiles`
- Run the script to automatically create symlinks `./initialize_dotfiles.sh`. The script will prompt for removal if a file, directory or symlink already exists. If the script is not yet executable, make it executable with `chmod +x initialize_dotfiles.sh`.

## some essential keybinds

The following keybinds will be used to navigate and move between windows and workspaces:
- Move between windows: `SUPER + [HJKL]`
- Swap windows: `SUPER + ALT + [HJKL]`
- Move windows between different displays: `SUPER + SHIFT + [HJKL]`
- Move between workspaces on the active screen: `SUPER + CTRL + [HL]`
- Additionally one may use `SUPER + (0-9)` to switch between workspaces directly

The following keybinds are also essential:
- Terminal: `SUPER + T`
- File manager: `SUPER + F`
- Application launcher: `SUPER + M`
- Close active window: `SUPER + Q`


## shellsparce

Shellsparce is your assistant in the terminal! Use `shellsparce help` to find out what shellsparce can do for you!

Examples:
- `shellsparce theme current` - Shows you the current theme.
- `shellsparce theme change copper` - Changes the theme to the "copper" theme.
