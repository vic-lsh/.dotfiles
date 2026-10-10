#!/bin/bash
# Installs agent skills for Claude Code and Codex. Safe to re-run.
#   ~/.agent-skills          public skills  (github.com/vic-lsh/agent-skills)
#   ~/.agent-skills-private  private skills and per-project skill state, if this
#                            machine can read the private repo
# Each skill is symlinked into ~/.claude/skills and ~/.codex/skills, and
# ~/.agent-state points at the private repo's state/ folder.
set -euo pipefail

PUBLIC_REPO=git@github.com:vic-lsh/agent-skills.git
PRIVATE_REPO=git@github.com:vic-lsh/agent-skills-private.git
SKILL_DIRS=(~/.claude/skills ~/.codex/skills)

clone_or_pull() {
    local url=$1 dir=$2
    if [ -d "$dir/.git" ]; then
        git -C "$dir" pull --ff-only --quiet || echo "warning: could not fast-forward $dir; left as is"
    else
        git clone --quiet "$url" "$dir"
    fi
}

clone_or_pull "$PUBLIC_REPO" ~/.agent-skills
# Pre-push lint: blocks oversized skills and private details in public skills
git -C ~/.agent-skills config core.hooksPath .githooks
if git ls-remote "$PRIVATE_REPO" &>/dev/null; then
    clone_or_pull "$PRIVATE_REPO" ~/.agent-skills-private
else
    echo "private skills repo not reachable; installing public skills only"
fi

for skill in ~/.agent-skills/skills/*/ ~/.agent-skills-private/skills/*/; do
    [ -f "$skill/SKILL.md" ] || continue
    skill=${skill%/}
    for dest in "${SKILL_DIRS[@]}"; do
        mkdir -p "$dest"
        link="$dest/$(basename "$skill")"
        if [ -e "$link" ] && [ ! -L "$link" ]; then
            echo "skipping $link: a real folder is there; move it into a skills repo first"
            continue
        fi
        ln -sfn "$skill" "$link"
    done
done

if [ -d ~/.agent-skills-private/state ]; then
    if [ -e ~/.agent-state ] && [ ! -L ~/.agent-state ]; then
        echo "skipping ~/.agent-state: a real folder is there; merge it into ~/.agent-skills-private/state first"
    else
        ln -sfn ~/.agent-skills-private/state ~/.agent-state
    fi
fi
echo "agent skills installed"
