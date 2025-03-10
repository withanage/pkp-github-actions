#!/bin/bash

# @file actions/run-data-integration-tests.sh
#
# Copyright (c) 2014-2025 Simon Fraser University
# Copyright (c) 2010-2025 John Willinsky
# Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
#
# Script to run the Cypress data build integration tests

set -e # Fail on first error

if [ "${TERM:-}" = "" ]; then
  echo "Setting TERM to dumb" # makes tput happy
  TERM="dumb"
fi


if [[ "$NODE_VERSION" -gt "13"  ]]; then
  npx cypress run --headless --browser chrome --config '{"specPattern":["cypress/tests/data/**/*.cy.js"]}'
fi

if [[ "$NODE_VERSION" -lt "13"  ]]; then
  npx cypress run --headless --browser chrome --config integrationFolder=cypress/tests/data
fi

