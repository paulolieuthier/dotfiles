# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="robbyrussell"

plugins=(git git-extras docker docker-compose gradle)

source $ZSH/oh-my-zsh.sh

# history settings
setopt hist_ignore_dups  # ignore duplicated commands history list
setopt hist_ignore_space # ignore commands that start with space
setopt hist_verify       # show command with history expansion to user before running it
setopt appendhistory     # append history to the history file (no overwriting)
setopt sharehistory      # share history across terminals
setopt incappendhistory  # immediately append to the history file, not just when a term is killed

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
alias l="ls --color --group-directories-first"
alias ls="ls --color --group-directories-first"
alias ll="ls -lh --color --group-directories-first"
alias la="ls -ah --color --group-directories-first"
alias lla="ls -lah --color --group-directories-first"
alias parallel="parallel --will-cite"
alias open="xdg-open"
alias gw="./gradlew"
alias k="kubectl"

# run local npm programs
function npm-do { (PATH=$(npm bin):$PATH; eval $@;) }

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
