# Install Tmux Plugin Manager by running:
# git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# And type Prefix+I to install plugins

set -g default-command '/usr/bin/zsh'
set -g default-shell '/usr/bin/zsh'

# plugins
set -g @plugin 'jimeh/tmux-themepack'
set -g @plugin 'christoomey/vim-tmux-navigator'
set -g @plugin 'nhdaly/tmux-better-mouse-mode'

# theme
set -g @themepack 'block/gray'

# history
set -g history-limit 100000000

# enable mouse support
set-option -g mouse on
set-option -s set-clipboard off

# disable leaving copy mode on click when in copy mode, but keep clearing selection
# on click and exiting copy mode when scrolling back to the end
unbind -T copy-mode-vi MouseDragEnd1Pane
bind -T copy-mode-vi MouseDown1Pane select-pane\; send-keys -X clear-selection
bind -n MouseDrag1Pane if -Ft= '#{mouse_any_flag}' 'if -Ft= \"#{pane_in_mode}\" \"copy-mode -eM\" \"send-keys -M\"' 'copy-mode -eM'

# quick ESC
set -g escape-time 0

# open new windows in the same directory
bind c new-window -c "#{pane_current_path}"

# better split shortcuts
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"

# vi-style cursor movement
set-window-option -g mode-keys vi

# start window numbering at 1
set-option -g base-index 1
set-window-option -g pane-base-index 1

# force reload of config file
unbind r
bind r source-file ~/.tmux.conf

# C-l is taken over by vim style pane navigation
bind C-l send-keys 'C-l'

# consider prefix+C-[ the same as prefix+[, for sanity
# and same for pasting
bind C-[ copy-mode
bind C-] paste-buffer

# setup 'v' to begin selection as in vim
bind -T copy-mode-vi v send-keys -X begin-selection
bind -T copy-mode-vi y send-keys -X copy-pipe copy

# update default binding of `Enter` to also use copy-pipe
unbind -T copy-mode-vi Enter
bind -T copy-mode-vi Enter send-keys -X copy-pipe copy

# initialize tmux plugin manager (keep this at the very bottom)
run '~/.tmux/plugins/tpm/tpm'

# tweak theme (keep this even lower)
set -g status-fg colour250
set -g status-left ""
set -g status-right "#[fg=colour248,bg=colour235] %H:%M #[fg=colour250,bg=colour240] #I:#P #[fg=colour232,bg=colour245,bold] #S "
set -g status-justify left
