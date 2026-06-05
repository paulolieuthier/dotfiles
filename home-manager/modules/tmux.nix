{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    terminal = "screen-256color";
    baseIndex = 1;
    clock24 = true;
    escapeTime = 0;
    historyLimit = 100000;
    plugins = [
      pkgs.tmuxPlugins.catppuccin
      pkgs.tmuxPlugins.vim-tmux-navigator
      pkgs.tmuxPlugins.fingers
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

      # reload config file
      bind r source-file ~/.config/tmux/tmux.conf

      # don't do anything when a 'bell' rings
      set -g visual-activity off
      set -g visual-bell off
      set -g visual-silence off
      setw -g monitor-activity off
      set -g bell-action none

      # tmux-fingers with better binding
      set -g @fingers-key Space
      set -g @fingers-pattern-0 '([a-z0-9-.:]+-[a-z0-9]+)'
      set -g @fingers-pattern-1 '([a-z0-9_.:]+_[a-z0-9]+)'
    '';
  };
}
