#!/bin/bash

# @file actions/git-auto-pull.sh
#
# Copyright (c) 2014-2025 Simon Fraser University
# Copyright (c) 2010-2025 John Willinsky
# Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
#
# Script to wait for a remote update to be present

check_remote_updated() {
    git branch --set-upstream-to=origin/main main
    git fetch
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse @{u})

    if [ "$LOCAL" = "$REMOTE" ]; then
        return 0
    else
        return 1
    fi
}

# Loop until the remote repository is updated
while ! check_remote_updated; do
    echo "Remote repository is not updated yet. Waiting..."
    sleep 10 # Wait for 10 seconds before checking again
    git pull origin main
done

git pull

