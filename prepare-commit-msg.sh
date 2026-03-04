#!/bin/bash

# Standard Git hook arguments
COMMIT_MSG_FILE=$1
COMMIT_SOURCE=$2
SHA1=$3

# Get the current branch name
BRANCH_NAME=$(git symbolic-ref --short HEAD 2>/dev/null)

# Skip if branch name is empty
if [ -z "$BRANCH_NAME" ]; then
  exit 0
fi

# Define the same flexible pattern
ALLOWED_PATTERN="^feature/.*_sub(/|$)"

# 1. CHECK VALIDITY BEFORE MODIFYING MESSAGE
if [[ "$BRANCH_NAME" =~ $ALLOWED_PATTERN ]]; then
    
    # Clean up the commit message template (Perl)
    /usr/bin/perl -i.bak -ne 'print unless(m/^. Please enter the commit message/..m/^#$/)' "$COMMIT_MSG_FILE"

    # Check if branch name is already in the message to avoid duplication
    BRANCH_IN_COMMIT=$(grep -c "\[$BRANCH_NAME\]" "$COMMIT_MSG_FILE")

    if [ "$BRANCH_IN_COMMIT" -lt 1 ]; then
        # Prepend branch name to the first line
        # Compatibility: macOS sed requires -i.bak
        sed -i.bak -e "1s/^/[$BRANCH_NAME] /" "$COMMIT_MSG_FILE"
    fi

    # Run git secrets if it exists in the environment
    if command -v git-secrets >/dev/null 2>&1; then
        git secrets --prepare_commit_msg_hook -- "$@"
    fi
fi

# Always exit 0 here as pre-commit already handled the blocking logic
exit 0