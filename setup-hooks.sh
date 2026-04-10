#!/bin/bash

# --- CONFIGURATION ---
# Get branch from the first argument ($1), default to 'main' if empty
BRANCH=${1:-main}
REPO_BASE_URL="https://raw.githubusercontent.com/exv-datnm/GitHook/$BRANCH"

echo "----------------------------------------------------------------"
echo "🚀 Installing Git Hooks from branch: [$BRANCH]"

# Ensure we are in a git repository
if [ ! -d ".git" ]; then
    echo "❌ Error: .git directory not found. Run this in your project root."
    exit 1
fi

# Function to download and setup hooks
install_hook() {
    local hook_name=$1
    echo "📥 Downloading $hook_name..."
    
    # Download from the dynamic URL
    curl -fsSL "$REPO_BASE_URL/$hook_name" -o ".git/hooks/$hook_name"
    
    if [ $? -eq 0 ]; then
        chmod u+x ".git/hooks/$hook_name"
        echo "✅ Installed $hook_name"
    else
        echo "⚠️  Failed to download $hook_name (Check if file exists on branch)"
    fi
}

# Execute installation for your hooks
install_hook "commit-msg"
install_hook "prepare-commit-msg"
install_hook "pre-commit"
install_hook "pre-push"
# install_hook "prepare-commit-msg" # Optional: if you use the auto-prefix logic

echo "🎉 Setup complete for branch [$BRANCH]!"
echo "----------------------------------------------------------------"