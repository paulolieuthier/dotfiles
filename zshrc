# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="robbyrussell"

plugins=(git git-extras docker docker-compose gradle)

source $ZSH/oh-my-zsh.sh

export GOPATH="$HOME/.go"
export PATH="$HOME/.local/bin:$PATH:$HOME/.rvm/bin:$HOME/.cargo/bin:$GOPATH/bin:$PATH"
export PKG_CONFIG_PATH="/usr/local/lib64/pkgconfig:/usr/local/lib/pkgconfig:/usr/local/share/pkgconfig"

export GRADLE_USER_HOME="${HOME}/.gradle"
which javac > /dev/null 2>&1 && export JAVA_PATH=$(dirname $(dirname $(readlink -f $(which javac))))

# Basic exports
export LANG=en_US.utf8
export EDITOR=vim
export MANPAGER="nvim -c 'set ft=man' -"
export TERM=xterm-256color
export LESS="-FXR"

if [[ `command -v nvim` ]]; then
    export EDITOR=nvim
    alias vim=nvim
fi

# aliases
alias l="ls"
alias ll="ls -lh"
alias la="ls -ah"
alias lla="ls -lah"
alias parallel="parallel --will-cite"
alias copy="rsync -ah --progress"
alias xclip="xclip -selection c"
alias gw="./gradlew"
alias kubectl10="kubectl"

# fuzzy finder
if [ -f ~/.fzf.zsh ]; then
    source ~/.fzf.zsh
    export FZF_TMUX=1
fi

if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
