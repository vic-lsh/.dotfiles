#!/bin/bash
# Syncs the agent skill repos with GitHub. Run hourly by cron (installed by
# setup-agent-skills.sh); safe to run by hand at any time.
#   ~/.agent-skills-private  pull --rebase, then push: shares lessons and
#                            per-context state between machines
#   ~/.agent-skills          pull --ff-only, never push: public changes go
#                            out only after review, through its pre-push lint
# Never commits. Skips a repo with uncommitted changes (an agent may be
# mid-edit). On a rebase conflict, aborts and leaves the repo as it was.
set -uo pipefail

log() { echo "$(date '+%F %T') $(hostname -s) $*"; }

sync_private() {
    local dir=$1
    [ -d "$dir/.git" ] || return 0
    if [ -n "$(git -C "$dir" status --porcelain)" ]; then
        log "$dir: uncommitted changes, skipped this run"
        return 0
    fi
    local before
    before=$(git -C "$dir" rev-parse HEAD)
    if ! git -C "$dir" pull --rebase --quiet; then
        git -C "$dir" rebase --abort 2>/dev/null
        log "$dir: CONFLICT pulling; repo left at $before, resolve by hand"
        return 1
    fi
    local pulled ahead
    pulled=$(git -C "$dir" rev-list --count "$before..HEAD" 2>/dev/null || echo 0)
    ahead=$(git -C "$dir" rev-list --count "@{u}..HEAD")
    if [ "$ahead" -gt 0 ] && ! git -C "$dir" push --quiet; then
        log "$dir: push failed; will retry next run"
        return 1
    fi
    log "$dir: pulled $pulled, pushed $ahead"
}

sync_public() {
    local dir=$1
    [ -d "$dir/.git" ] || return 0
    if git -C "$dir" pull --ff-only --quiet; then
        log "$dir: up to date with origin (pull only)"
    else
        log "$dir: cannot fast-forward (local commits or edits); left as is"
    fi
}

status=0
sync_private ~/.agent-skills-private || status=1
sync_public ~/.agent-skills || status=1
exit $status
