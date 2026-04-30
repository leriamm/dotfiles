# ~/.config/fish/config.fish

# Basic env
set -gx EDITOR zeditor
set -gx VISUAL nvim
set -gx TERMINAL kitty
set -gx BROWSER librewolf

# XDG
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME   $HOME/.local/share
set -gx XDG_CACHE_HOME  $HOME/.cache

# Path additions
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.cargo/bin

# Better ls
if command -q eza
    alias ls  'eza --icons --group-directories-first'
    alias ll  'eza -la --icons --group-directories-first --git'
    alias lt  'eza --tree --icons --level=2'
else
    alias ls  'ls --color=auto'
    alias ll  'ls -la --color=auto'
end

# Nvim shortcuts
alias vim   nvim
alias v     nvim

# Quick movement
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Git Shortcuts
alias g     git
alias gs    'git status'
alias gc    'git commit -m'
alias gp    'git push'
alias cat   bat
alias grep  'grep --color=auto'

# Quick Edit Config
alias fishconfig="$EDITOR ~/.config/fish/config.fish"
alias reload="source ~/.config/fish/config.fish"

# Create and enter directory
function mkcd
    mkdir -p $argv[1]
    cd $argv[1]
end

# Pacman, Yay
alias sysupdate     'yay -Syu'

# Suppress fish greeting
set fish_greeting "$(fastfetch)"

# Keybinds
fish_vi_key_bindings   # vim mode — remove this line if you prefer emacs/default

# fzf integration (if fzf.fish is installed)
fzf_configure_bindings --directory=\cf --git_log=\cg --git_status=\cs --history=\cr

# Starship
starship init fish | source
