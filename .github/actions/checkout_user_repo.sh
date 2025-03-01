#!/bin/bash

# @file actions/checkout_user_repo.sh
#
# Copyright (c) 2014-2025 Simon Fraser University
# Copyright (c) 2010-2025 John Willinsky
# Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
#
# Script to check out the third party Github repo, if necessary

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
