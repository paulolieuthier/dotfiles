set -o allexport
. ~/.config/environment.d/basic.conf
set +o allexport

export GOPATH="$HOME/.go"
export PATH="$HOME/.rvm/bin:$GOPATH/bin:$PATH"
export GRADLE_USER_HOME="${HOME}/.gradle"
