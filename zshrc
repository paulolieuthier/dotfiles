# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

plugins=(git git-extras docker docker-compose kubectl aws)

source $ZSH/oh-my-zsh.sh

# history settings
setopt hist_ignore_dups  # ignore duplicated commands history list
setopt hist_verify       # show command with history expansion to user before running it
setopt appendhistory     # append history to the history file (no overwriting)
setopt sharehistory      # share history across terminals
setopt incappendhistory  # immediately append to the history file, not just when a term is killed

which javac > /dev/null 2>&1 && export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which javac))))

# Basic exports
export LANG=en_US.utf8
export EDITOR=vim
export TERM=screen-256color
export LESS="-FXR"

# better shortcuts for command line
bindkey '\eB' vi-backward-blank-word
bindkey '\eF' vi-forward-blank-word

autoload -Uz backward-kill-word-match
bindkey '\e^W' backward-kill-space-word
zle -N backward-kill-space-word backward-kill-word-match
zstyle :zle:backward-kill-space-word word-style space

# prompt
source ~/.zsh_prompt.zsh

if [[ `command -v nvim` ]]; then
    export EDITOR=nvim
    alias vim=nvim
fi

# aliases
alias l="ls --color=auto --group-directories-first"
alias ls="ls --color=auto --group-directories-first"
alias sl="ls --color=auto --group-directories-first"
alias ll="ls -lh --color=auto --group-directories-first"
alias la="ls -ah --color=auto --group-directories-first"
alias lla="ls -lah --color=auto --group-directories-first"
alias lld="ls -lahd --color=auto"
alias parallel="parallel --will-cite"
alias open="xdg-open"
alias gw="./gradlew"

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
alias urlencode="python3 -c 'import sys, urllib.parse; print(urllib.parse.quote(sys.stdin.read()))'"
alias urldecode="python3 -c 'import sys, urllib.parse; print(urllib.parse.unquote(sys.stdin.read()))'"
alias inflate="perl -mIO::Uncompress::RawInflate=rawinflate -erawinflate'\"-\",\"-\"'"
alias deflate="perl -mIO::Compress::RawDeflate=rawdeflate -erawdeflate'\"-\",\"-\"'"
