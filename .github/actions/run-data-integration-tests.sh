#!/bin/bash



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

