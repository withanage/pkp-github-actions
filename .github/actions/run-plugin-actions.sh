#!/bin/bash

# @file actions/run-plugin-actions.sh
#
# Copyright (c) 2014-2025 Simon Fraser University
# Copyright (c) 2010-2025 John Willinsky
# Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
#
# Script to run plugin-based tests

set -e # Fail on first error

if [ "${TERM:-}" = "" ]; then
  echo "Setting TERM to dumb" # makes tput happy
  TERM="dumb"
fi
cd ~/
git clone -b "${GITHUB_EVENT_HEAD_REF}" "${GITHUB_EVENT_HEAD_REPO_HTML_URL}" "${GITHUB_EVENT_HEAD_REPO_NAME}" --depth 1
cd "${GITHUB_EVENT_HEAD_REPO_NAME}"
pluginType=$(grep '<type>' version.xml | sed -n 's/.*<type>\(.*\)<\/type>.*/\1/p')
pluginPath=$(echo "$pluginType" | tr '.' '/')

PLUGIN_DIR=~/"${APPLICATION}/${pluginPath}/${GITHUB_EVENT_HEAD_REPO_NAME}"

if [ -d "$PLUGIN_DIR" ]; then
  rm -rf "$PLUGIN_DIR"
fi

mv ~/"${GITHUB_EVENT_HEAD_REPO_NAME}"  "$PLUGIN_DIR"

cd ~/"${APPLICATION}"
if [ -e "${pluginPath}/${GITHUB_EVENT_HEAD_REPO_NAME}/.github/actions/tests.sh" ]; then
  source "${pluginPath}/${GITHUB_EVENT_HEAD_REPO_NAME}/.github/actions/tests.sh"
else
  echo "${pluginPath}/${GITHUB_EVENT_HEAD_REPO_NAME}/.github/actions/tests.sh does not exist"
fi

