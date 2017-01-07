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
plugins=(git git-extras)

source $ZSH/oh-my-zsh.sh

export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/usr/local/lib32/pkgconfig"
export ANDROID_SDK="/home/paulo/Workspace/android/android-sdk-linux"
export ANDROID_SDK_ROOT=$ANDROID_SDK
export ANDROID_HOME=$ANDROID_SDK
export ANDROID_NDK="/home/paulo/Workspace/android/android-ndk-r10e"
export ANDROID_NDK_ROOT=$ANDROID_NDK
export JAVA_HOME="/usr/lib/jvm/java-8-openjdk/"
export ANT="/usr/bin/ant"
export QT_ANDROID=/home/paulo/Workspace/android/Qt5.6.0/5.6/android_armv5
export GSTREAMER_ROOT_ANDROID=/home/paulo/Workspace/android/gstreamer-1.0-android-arm-1.8.0

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR=vim
export GPGKEY=22760FEC9482A147CE29DA18F3CCB78DFFD36CE2
export TERM=xterm-256color

# Compilers
export CC=clang
export CXX=clang++

# aliases
alias l="ls -G"
alias ll="ls -lGh"
alias la="ls -aGh"
alias lla="ls -laGh"
alias parallel="parallel --will-cite"
alias copy="rsync -ah --progress"
alias xclip="xclip -selection c"

# less
export LESS="-R"

# Rust
export RUST_SRC_PATH="/home/paulo/Workspace/rust/src"


# RVM
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# Base16 shell
BASE16_SHELL="$HOME/.config/base16-shell/scripts/base16-default-dark.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

# Powerfull syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
