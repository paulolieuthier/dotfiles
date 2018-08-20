# PATH
set PATH $HOME/.local/bin $HOME/.cargo/bin $PATH
set PKG_CONFIG_PATH /usr/local/lib/pkgconfig /usr/local/lib32/pkgconfig $PKG_CONFIG_PATH

# Basic exports
set LANG en_US.utf8
set EDITOR vim
set MANPAGER "nvim -c 'set ft=man' -"
set TERM xterm-256color
set LESS -FXR

# Neovim
if command -v nvim
    set EDITOR nvim
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
