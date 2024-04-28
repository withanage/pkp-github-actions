#!/bin/bash

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

