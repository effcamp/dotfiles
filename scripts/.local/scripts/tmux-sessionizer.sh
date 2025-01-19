#!/usr/bin/env bash
set -x  # Enable debug mode to see what's being executed

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find ~/repos ~/ -mindepth 1 -maxdepth 1 -type d | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)

if [[ -z $TMUX ]]; then
    echo "Outside tmux"
    if ! tmux has-session -t=$selected_name 2> /dev/null; then
        echo "Creating new session: $selected_name"
        exec tmux new-session -s $selected_name -c $selected
    else
        echo "Attaching to existing session: $selected_name"
        exec tmux attach-session -t $selected_name
    fi
fi

if ! tmux has-session -t=$selected_name 2> /dev/null; then
    tmux new-session -ds $selected_name -c $selected
fi
tmux switch-client -t $selected_name
