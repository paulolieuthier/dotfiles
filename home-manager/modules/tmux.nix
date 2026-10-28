{ config, pkgs, lib, tmux-assistant-resurrect, ... }:

let
  tmux = "${pkgs.tmux}/bin/tmux";
  resurrectDir = "${config.home.homeDirectory}/.tmux/resurrect";

  # Keep only the primary session, or the most recently
  # active attached session when the primary is detached.
  filterSnapshot = pkgs.writeShellScript "tmux-filter-snapshot" ''
    set -euo pipefail

    export PATH=${lib.makeBinPath [
      pkgs.coreutils
      pkgs.gawk
    ]}:$PATH

    snapshot="$1"
    primary=$(${tmux} show -gqv @primary-session)

    target=""

    # Prefer the primary session while it is attached.
    if [ -n "$primary" ]; then
      attached=$(${tmux} display-message -p \
        -t "=$primary" '#{session_attached}' 2>/dev/null || true)

      if [ "''${attached:-0}" -gt 0 ]; then
        target="$primary"
      fi
    fi

    # Otherwise use the most recently active attached session.
    if [ -z "$target" ]; then
      target=$(
        ${tmux} list-sessions \
          -F '#{session_activity}|#{session_attached}|#{session_name}' |
        awk -F '|' '$2 > 0' |
        sort -t '|' -k1,1nr |
        head -n 1 |
        cut -d '|' -f3- || true
      )
    fi

    # If every client is closed, keep the previous selection.
    if [ -z "$target" ]; then
      target=$(${tmux} show -gqv @last-saved-session)
    fi

    # Final fallback: most recently active existing session.
    if [ -z "$target" ] ||
       ! ${tmux} has-session -t "=$target" 2>/dev/null; then
      target=$(
        ${tmux} list-sessions \
          -F '#{session_activity}|#{session_name}' |
        sort -t '|' -k1,1nr |
        head -n 1 |
        cut -d '|' -f2- || true
      )
    fi

    [ -n "$target" ] || exit 0

    ${tmux} set-option -g @last-saved-session "$target"

    # Preserve only the selected session's panes/windows
    # and rewrite the active-session state record.
    tmp=$(mktemp "''${snapshot}.XXXXXX")
    trap 'rm -f "$tmp"' EXIT

    awk -F '\t' -v OFS='\t' -v target="$target" '
      ($1 == "pane" || $1 == "window") && $2 == target {
        print
      }
      $1 == "state" {
        print "state", target, ""
      }
    ' "$snapshot" > "$tmp"

    chmod --reference="$snapshot" "$tmp"
    mv -f "$tmp" "$snapshot"
  '';

  # Wrap the real tmux command without changing Alacritty.
  tmuxWrapper = pkgs.writeShellScriptBin "tmux" ''
    set -euo pipefail

    export PATH=${lib.makeBinPath [
      pkgs.coreutils
      pkgs.util-linux
      pkgs.gawk
    ]}:$PATH

    # Explicit tmux commands bypass the wrapper logic.
    if [ "$#" -gt 0 ]; then
      exec ${tmux} "$@"
    fi

    # Serialize concurrent terminal launches.
    lockDir="''${XDG_RUNTIME_DIR:-/tmp}/tmux-wrapper-$(id -u)"
    mkdir -p "$lockDir"
    exec 9>"$lockDir/lock"
    flock -x 9

    if ! ${tmux} has-session 2>/dev/null; then
      bootstrap="bootstrap_$$"

      # Starting tmux also initializes the Nix-managed plugins.
      ${tmux} new-session -d -s "$bootstrap"

      restore=$(${tmux} show -gqv \
        @resurrect-restore-script-path)

      if [ -n "$restore" ] && [ -e "${resurrectDir}/last" ]; then
        ${tmux} run-shell "$restore"
      fi

      # Remove the bootstrap session if restoration
      # successfully created another session.
      count=$(${tmux} list-sessions -F '#{session_name}' | wc -l)

      if [ "$count" -gt 1 ]; then
        ${tmux} kill-session -t "=$bootstrap"
      fi

      # Mark the restored (or bootstrap) session as primary.
      primary=$(
        ${tmux} list-sessions -F '#{session_name}' |
        head -n 1
      )

      ${tmux} set-option -g @primary-session "$primary"
      ${tmux} set-option -g @last-saved-session "$primary"
    fi

    # Prefer an unattached session, most recently active first.
    target=$(
      ${tmux} list-sessions \
        -F '#{session_activity}|#{session_attached}|#{session_name}' |
      awk -F '|' '$2 == 0' |
      sort -t '|' -k1,1nr |
      head -n 1 |
      cut -d '|' -f3- || true
    )

    flock -u 9

    if [ -n "$target" ]; then
      exec ${tmux} attach-session -t "=$target"
    else
      # All sessions are attached: create a separate one.
      exec ${tmux} new-session
    fi
  '';

  assistantResurrect = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "assistant-resurrect";
    version = "unstable";
    src = tmux-assistant-resurrect;
    rtpFilePath = "tmux-assistant-resurrect.tmux";
  };
in
{
  home.packages = [
    (lib.hiPrio tmuxWrapper)
    pkgs.jq # needed by tmux-ressurect
  ];

  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    terminal = "screen-256color";
    baseIndex = 1;
    clock24 = true;
    escapeTime = 0;
    historyLimit = 100000;
    plugins = [
      pkgs.tmuxPlugins.gruvbox
      pkgs.tmuxPlugins.vim-tmux-navigator
      pkgs.tmuxPlugins.resurrect
      {
        plugin = assistantResurrect;
        extraConfig = ''
          set -g @assistant-resurrect-opencode 'on'
          set -g @resurrect-capture-pane-contents 'on'
        '';
      }
      {
        plugin = pkgs.tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'off'
          set -g @continuum-save-interval '1'
        '';
      }
      {
        plugin = pkgs.tmuxPlugins.tmux-thumbs;
        extraConfig = ''
          set -g @thumbs-command 'echo -n {} | wl-copy'
          set -g @thumbs-upcase-command 'xdg-open {}'
          set -g @thumbs-regexp-0 '([a-zA-Z0-9-.:]+-[a-zA-Z0-9]+)'
          set -g @thumbs-regexp-1 '([a-zA-Z0-9_.:]+_[a-zA-Z0-9]+)'
        '';
      }
    ];

    extraConfig = ''
      # renumber windows to avoid gaps
      set -g renumber-windows on

      # open new windows on the current path
      bind c new-window -c '#{pane_current_path}'

      # move the current pane to a new window
      bind b break-pane -d

      # better split bindings
      bind \\ split-window -h -c '#{pane_current_path}'
      bind - split-window -v -c '#{pane_current_path}'

      # make clipboard easier
      setw -g mode-keys vi
      set -s copy-command 'wl-copy'
      unbind -T copy-mode-vi Enter
      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi 'C-v' send -X rectangle-toggle
      bind -T copy-mode-vi y send -X copy-selection

      # sensible mouse defaults in copy mode
      bind -T copy-mode-vi DoubleClick1Pane select-pane \; send-keys -X select-word
      bind -T copy-mode-vi MouseDown1Pane select-pane \; send-keys -X clear-selection
      unbind -T copy-mode-vi MouseDragEnd1Pane

      # enable mouse control
      set -g mouse on

      # show scrollbar in copy mode
      set -g pane-scrollbars modal

      # enable status
      set -g status on

      # set session ressurection directory
      set -g @resurrect-dir '${resurrectDir}'

      # filter the layout before Resurrect publishes it.
      set -g @resurrect-hook-post-save-layout '${filterSnapshot}'

      # reload config file
      bind r source-file ~/.config/tmux/tmux.conf

      # don't do anything when a 'bell' rings
      set -g visual-activity off
      set -g visual-bell off
      set -g visual-silence off
      setw -g monitor-activity off
      set -g bell-action none
    '';
  };
}
