# Install Tmux Plugin Manager by running:
# git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# plugins
set -g @plugin 'jimeh/tmux-themepack'

# theme
set -g @themepack 'double/green'

# vi-style cursor movement
set-window-option -g mode-keys vi

# start window numbering at 1
set-option -g base-index 1
set-window-option -g pane-base-index 1

# use the system clipboard
# set-option -g default-command "reattach-to-user-namespace -l bash"

# smart pane switching with awareness of vim splits
bind -n C-h run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-h) || tmux select-pane -L"
bind -n C-j run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-j) || tmux select-pane -D"
bind -n C-k run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-k) || tmux select-pane -U"
bind -n C-l run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-l) || tmux select-pane -R"

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
