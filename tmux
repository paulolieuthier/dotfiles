# Install Tmux Plugin Manager by running:
# git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# plugins
set -g @plugin 'jimeh/tmux-themepack'
set -g @plugin 'christoomey/vim-tmux-navigator'

# theme
set -g @themepack 'block/gray'

# better split shortcuts
bind | split-window -h
bind - split-window -v

# vi-style cursor movement
set-window-option -g mode-keys vi

# start window numbering at 1
set-option -g base-index 1
set-window-option -g pane-base-index 1

# C-l is taken over by vim style pane navigation
bind C-l send-keys 'C-l'

# setup 'v' to begin selection as in vim
bind-key -t vi-copy v begin-selection
bind-key -t vi-copy y copy-pipe "reattach-to-user-namespace pbcopy"

# update default binding of `Enter` to also use copy-pipe
unbind -t vi-copy Enter
bind-key -t vi-copy Enter copy-pipe "reattach-to-user-namespace pbcopy"

# initialize tmux plugin manager (keep this at the very bottom)
run '~/.tmux/plugins/tpm/tpm'

# tweak theme (keep this even lower)
set -g status-fg colour250
set -g status-left ""
set -g status-right "#[fg=colour235,bg=colour233]#[fg=colour248,bg=colour235] %H:%M #[fg=colour240,bg=colour235]#[fg=colour250,bg=colour240] #I:#P #[fg=colour245,bg=colour240]#[fg=colour232,bg=colour245,bold] #S "
set -g status-justify left
