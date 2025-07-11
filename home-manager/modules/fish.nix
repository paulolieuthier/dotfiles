{ config, pkgs, ... }:

{
  programs.fish = {
    enable = true;

    shellAliases = {
      vim="nvim";
      l="ls --color=auto --group-directories-first";
      ls="ls --color=auto --group-directories-first";
      sl="ls --color=auto --group-directories-first";
      ll="ls -lh --color=auto --group-directories-first";
      la="ls -ah --color=auto --group-directories-first";
      lla="ls -lah --color=auto --group-directories-first";
      parallel="parallel --will-cite";
      k="kubectl";
      open="xdg-open";
      gw="./gradlew";
      urlencode="python3 -c 'import sys, urllib.parse; print(urllib.parse.quote(sys.stdin.read()))'";
      urldecode="python3 -c 'import sys, urllib.parse; print(urllib.parse.unquote(sys.stdin.read()))'";
      inflate="perl -mIO::Uncompress::RawInflate=rawinflate -erawinflate'\"-\",\"-\"'";
      deflate="perl -mIO::Compress::RawDeflate=rawdeflate -erawdeflate'\"-\",\"-\"'";
    };

    plugins = [
      { name = "autopair"; src = pkgs.fishPlugins.autopair.src; }
    ];

    interactiveShellInit = ''
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

      function fish_prompt
          set last_status $status

          function yellow; set_color yellow; end
          function white; set_color white; end
          function bgreen; set_color green; end
          function bcyan; set_color cyan; end
          function bred; set_color red; end
          function normal; set_color normal; end
          
          function prompt_clock
              echo (white)(date +'%R')
          end
          
          function prompt_cwd
              echo (yellow)(string replace (echo $HOME) '~' (echo $PWD))
          end
          
          function prompt_git
              set ref (git symbolic-ref HEAD 2> /dev/null || git rev-parse --short HEAD 2> /dev/null) || return 0
              set dirty (test -n "$(git status --porcelain | tail -n1)" && echo ' X' || echo ''')
          
              echo (bcyan)'git:('(bred)(string replace 'refs/heads/' ''' $ref)(yellow)$dirty(bcyan)')'
          end
          
          function prompt_aws
              set profile (export | grep AWS_PROFILE) || return 0
              echo (bcyan)'aws:('(bred)$AWS_PROFILE(bcyan)')'
          end
          
          function prompt_kube
              set ctx (kubectl config current-context 2> /dev/null) || return 0
              set ns (kubectl config view --minify --output 'jsonpath={..namespace}' 2> /dev/null)
              if test -z "$ns"
                  set ns default
              end
              echo (bcyan)'k8s:('(bred)(string replace -r '.*:cluster/' ''' $ctx)(white)':'(bgreen)$ns(bcyan)')'
          '''end
          
          function prompt_prompt -a last_status
              if test "$last_status" = '0'
                  echo (bgreen)'>'(normal)
              else if test "$last_status" != '1'
                  echo (bred)"[$last_status]"(normal)'>'
              else
                  echo (bred)'>'(normal)
              end
          end
      
          set clock (prompt_clock)
          set cwd (prompt_cwd)
          set git (prompt_git)
          set aws (prompt_aws)
          set kube (prompt_kube)
          set prompt (prompt_prompt $last_status)
      
          set prompt_first (string join ' ' $clock $cwd)
          set prompt_last (string join ' ' $git $aws $kube)
          set prompt_sep " "
      
          # if too large use multi line
          if test (string length --visible "$prompt_first$prompt_sep$prompt_last") -gt $COLUMNS
              set prompt_sep '\n'
          end
      
          echo -e "\n$prompt_first$prompt_sep$prompt_last\n$prompt "

          functions -e yellow
          functions -e white
          functions -e bgreen
          functions -e bcyan
          functions -e bred
          functions -e normal
          functions -e prompt_clock
          functions -e prompt_cwd
          functions -e prompt_git
          functions -e prompt_aws
          functions -e prompt_kube
          functions -e prompt_prompt
      end
    '';
  };
}
