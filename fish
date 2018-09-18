# PATH
set -x PATH $HOME/.local/bin $HOME/.cargo/bin $PATH
set -x PKG_CONFIG_PATH /usr/local/lib/pkgconfig /usr/local/lib32/pkgconfig $PKG_CONFIG_PATH

# Basic exports
set -x LANG en_US.utf8
set -x EDITOR vim
set -x MANPAGER "nvim -c 'set ft=man' -"
set -x TERM xterm-256color
set -x LESS -FXR

# Neovim
if command -sq nvim
    set -x EDITOR nvim
    alias vim nvim
end

# aliases
alias l "ls"
alias ll "ls -lh"
alias la "ls -ah"
alias lla "ls -lah"
alias parallel "parallel --will-cite"
alias copy "rsync -ah --progress"
alias xclip "xclip -selection c"
alias gw "./gradlew"
alias k "kubectl"

# disable greeting
set fish_greeting
