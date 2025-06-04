function fish_greeting
end

bind alt-b backward-word
bind alt-shift-b backward-bigword
bind alt-f forward-word
bind alt-shift-f forward-bigword
bind alt-backspace kill-word
bind alt-shift-backspace kill-bigword

function ..    ; cd .. ; end
function ...   ; cd ../.. ; end
function ....  ; cd ../../.. ; end
function ..... ; cd ../../../.. ; end

alias vim nvim
alias l "ls --color=auto --group-directories-first"
alias ls "ls --color=auto --group-directories-first"
alias sl "ls --color=auto --group-directories-first"
alias ll "ls -lh --color=auto --group-directories-first"
alias la "ls -ah --color=auto --group-directories-first"
alias lla "ls -lah --color=auto --group-directories-first"
alias parallel "parallel --will-cite"
alias k kubectl
alias open "xdg-open"
alias gw "./gradlew"

alias urlencode "python3 -c 'import sys, urllib.parse; print(urllib.parse.quote(sys.stdin.read()))'"
alias urldecode "python3 -c 'import sys, urllib.parse; print(urllib.parse.unquote(sys.stdin.read()))'"
alias inflate "perl -mIO::Uncompress::RawInflate=rawinflate -erawinflate'\"-\",\"-\"'"
alias deflate "perl -mIO::Compress::RawDeflate=rawdeflate -erawdeflate'\"-\",\"-\"'"

function __asp_profiles
    cat ~/.aws/config | rg '^\[profile ([^]]*)\]' -r '$1'
end
function asp -a profile
    if test -n "$profile"
        set -gx AWS_PROFILE $profile
    else if test -z "$AWS_PROFILE"
        set -gx AWS_PROFILE (__asp_profiles | fzf)
    else
        set -eg AWS_PROFILE || true
    end
end
complete -c asp -e
complete -c asp -x -a '(__asp_profiles)'
