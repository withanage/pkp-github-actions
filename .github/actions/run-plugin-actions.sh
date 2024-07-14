#!/bin/bash


set -e # Fail on first error

cd ~/
git clone -b "${GITHUB_EVENT_HEAD_REF}" "${GITHUB_EVENT_HEAD_REPO_HTML_URL}" "${GITHUB_EVENT_HEAD_REPO_NAME}" --depth 1
cd "${GITHUB_EVENT_HEAD_REPO_NAME}"
pluginType=$(grep '<type>' version.xml | sed -n 's/.*<type>\(.*\)<\/type>.*/\1/p')
pluginPath=$(echo "$pluginType" | tr '.' '/')
mv ~/"${GITHUB_EVENT_HEAD_REPO_NAME}"  ~/"${APPLICATION}"/"$pluginPath"
cd ~/"${APPLICATION}"
if [ -e "${pluginPath}/${GITHUB_EVENT_HEAD_REPO_NAME}/.github/actions/tests.sh" ]; then
  source "${pluginPath}/${GITHUB_EVENT_HEAD_REPO_NAME}/.github/actions/tests.sh"
else
  echo "${pluginPath}/${GITHUB_EVENT_HEAD_REPO_NAME}/.github/actions/tests.sh does not exist"
fi
