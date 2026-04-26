#!/bin/bash
# Session Start Hook - Records session start time for duration tracking

SESSION_START_FILE="$HOME/.claude/session-start-time"
echo "$(date +%s)" > "$SESSION_START_FILE"
