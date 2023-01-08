#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Automatic backup
# @raycast.mode inline
# @raycast.refreshTime 1d

# Optional parameters:
# @raycast.icon 💾

# Documentation:
# @raycast.author owpac

BREW_PATH=$HOME/.brew
BACKUP_PATH=$HOME/Backup
date=$(date +"%d %b %R")

echo "$date ✅"

mkdir -p $BREW_PATH
mkdir -p $BACKUP_PATH

echo "🍺 Brew backup started..."

# Getting Homebrew apps (brew bundle to re-install everything)
brew bundle dump --force --file "$BREW_PATH"/Brewfile

echo "✅ Brew backup done."

echo "💾 Mackup backup started..."
mackup backup -f

echo "✅ Mackup backup done."
