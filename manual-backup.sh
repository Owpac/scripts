#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Manual backup
# @raycast.mode inline

# Optional parameters:
# @raycast.icon 🛟

# Documentation:
# @raycast.author owpac

BREW_PATH=$HOME/.brew
BACKUP_PATH=$HOME/Backup
SCRIPTS_PATH=$HOME/Workplace/scripts
date=$(date +"%d %b %R")

echo "$date ✅"

sh $SCRIPTS_PATH/backup.sh

cd $BACKUP_PATH
git add .
git commit -m "Backup of $date"
git push

echo "✅ Mackup backup done."
