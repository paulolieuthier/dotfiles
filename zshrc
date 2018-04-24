# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="robbyrussell"

CASE_SENSITIVE="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git git-extras docker docker-compose gradle)

source $ZSH/oh-my-zsh.sh

export PATH="$HOME/.local/bin:$PATH"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/usr/local/lib32/pkgconfig"

export GRADLE_USER_HOME="${HOME}/.gradle"
which javac > /dev/null 2>&1 && export JAVA_PATH=$(dirname $(dirname $(readlink -f $(which javac))))

# Basic exports
export LANG=en_US.utf8
export EDITOR=vim
export GPGKEY=22760FEC9482A147CE29DA18F3CCB78DFFD36CE2
export TERM=xterm-256color

# TMUX workaround
[ -n "$TMUX" ] && export TERM=screen-256color

if [[ `command -v nvim` ]]; then
    export EDITOR=nvim
    alias vim=nvim
fi

# Compilers
export CC=clang
export CXX=clang++

# aliases
alias l="ls"
alias ll="ls -lh"
alias la="ls -ah"
alias lla="ls -lah"
alias parallel="parallel --will-cite"
alias copy="rsync -ah --progress"
alias xclip="xclip -selection c"

# less
export LESS="-R"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

