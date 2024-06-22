#!/bin/bash
last_commit_message=$(git log -1 --pretty=%B)
echo $last_commit_message
pattern='##(.*)##'
if [[ $last_commit_message =~ $pattern ]]; then
    cd lib/pkp
    repository="${BASH_REMATCH[1]}"
    IFS='/' read -r -a parts <<< "$repository"
    git remote add ${parts[1]} "https://github.com/${parts[0]}/pkp-lib"
    git fetch ${parts[0]}  ${parts[1]}
    git checkout -b ${parts[1]} ${parts[0]}/${parts[1]}

fi
