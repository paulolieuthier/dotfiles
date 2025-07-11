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
      pkgs.tmuxPlugins.tmux-thumbs
      pkgs.tmuxPlugins.urlview
    ];

    extraConfig = ''
      # renumber windows to avoid gaps
      set -g renumber-windows on

      # open new windows on the current path
      bind c new-window -c '#{pane_current_path}'

      # move the current pane to a new window
      bind b break-pane -d

      # better split bindings
      bind \\ split-window -h
      bind - split-window -v

      # make clipboard easier
      setw -g mode-keys vi
      set -s copy-command 'wl-copy'
      unbind -T copy-mode-vi Enter
      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi 'C-v' send -X rectangle-toggle
      bind -T copy-mode-vi y send -X copy-selection

      # enable mouse control
      set -g mouse on

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
