#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract current working directory
cwd=$(echo "$input" | jq -r '.workspace.current_dir // ""')

# Get git branch if in a git repo
branch=""
if [ -n "$cwd" ] && [ -d "$cwd" ]; then
    branch=$(cd "$cwd" 2>/dev/null && git rev-parse --abbrev-ref HEAD 2>/dev/null)
fi

# Extract context window usage percentage
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // ""')

# Build the status line
status="$cwd"

if [ -n "$branch" ]; then
    status="$status:$branch"
fi

if [ -n "$remaining" ]; then
    # Round to integer
    remaining_int=$(printf "%.0f" "$remaining" 2>/dev/null || echo "$remaining")
    
    # Calculate padding for right alignment
    term_width=${COLUMNS:-$(tput cols 2>/dev/null || echo 80)}
    ctx_text=" ctx:${remaining_int}%"
    status_len=${#status}
    ctx_len=${#ctx_text}
    padding=$((term_width - status_len - ctx_len))
    
    if [ $padding -gt 0 ]; then
        printf "%s%${padding}s%s" "$status" "" "$ctx_text"
    else
        echo "$status $ctx_text"
    fi
else
    echo "$status"
fi
