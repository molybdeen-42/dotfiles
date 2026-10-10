# Prompt appearance
starship init fish | source


# Text editor
set -gx EDITOR vim

# PATH
fish_add_path ~/.local/bin

# Aliases
alias v "vim"
alias nv "nvim"
alias p "python3"
alias p3 "python3"
alias p2 "python2"

zoxide init fish --cmd cd | source
alias cat "bat"
alias ls "eza"
alias tree "eza --tree --level=2"
