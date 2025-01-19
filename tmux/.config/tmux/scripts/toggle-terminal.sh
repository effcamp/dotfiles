#!/usr/bin/env bash

# Configuration
PANE_HEIGHT="30%"
TERMINAL_WINDOW_NAME="scratch"

# Get current state
current_window_name=$(tmux display-message -p "#{window_name}")

# Exit if we're in the hidden terminal window
if [ "$current_window_name" = "$TERMINAL_WINDOW_NAME" ]; then
    exit 0
fi

current_pane=$(tmux display-message -p "#{pane_id}")
current_window=$(tmux display-message -p "#{window_id}")
is_active=$(tmux display-message -p "#{pane_active}")
is_bottom=$(tmux display-message -p "#{pane_at_bottom}")

# Check if hidden terminal window exists
hidden_terminal_exists=$(tmux list-windows -F "#{window_name}" | grep -c "^${TERMINAL_WINDOW_NAME}$")

# Count panes in current window
pane_count=$(tmux list-panes | wc -l)

# Main logic
if [ "$hidden_terminal_exists" -eq 1 ]; then
    tmux join-pane -v -l "$PANE_HEIGHT" -s "$TERMINAL_WINDOW_NAME"

elif [ "$pane_count" -gt 1 ]; then
    if [ "$is_active" = "1" ] && [ "$is_bottom" = "1" ]; then
        tmux break-pane -d -n "$TERMINAL_WINDOW_NAME"
        tmux select-window -t "$current_window"
    else
        bottom_pane=$(tmux list-panes -F "#{pane_id} #{pane_at_bottom}" | grep " 1$" | cut -d' ' -f1)
        tmux select-pane -t "$bottom_pane"
    fi
else
    tmux split-window -v -l "$PANE_HEIGHT"
fi
