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

local JAVA_PATHS=("/usr/lib/jvm/java-8-openjdk/" "/usr/lib/jvm/java-8-openjdk-amd64/")
for i in $JAVA_PATHS; do
    [[ -d $i ]] && export JAVA_HOME="$i"
done

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

# tell gpg-agent which tty to use
echo "UPDATESTARTUPTTY" | gpg-connect-agent > /dev/null 2>&1

# less
export LESS="-R"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"

# Powerfull syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

function npm-do { (PATH=$(npm bin):$PATH; eval $@;) }
