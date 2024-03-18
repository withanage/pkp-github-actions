#!/bin/bash

export CYPRESS_DBHOST='127.0.0.1' # Database hostname
export CYPRESS_BASE_URL='http://localhost:80'
export CYPRESS_DBNAME=${APPLICATION} # Database name
export CYPRESS_DBUSERNAME=${APPLICATION} # Database username
export CYPRESS_DBPASSWORD=${APPLICATION} # Database password
export CYPRESS_FILESDIR=files

 set -e # Fail on first error

if [ "${TERM:-}" = "" ]; then
  echo "Setting TERM to dumb" # makes tput happy
  TERM="dumb"
fi
echo '{ "baseUrl": "'${CYPRESS_BASE_URL}'", "DBHOST": "'${CYPRESS_DBHOST}'", "DBUSERNAME": "'$CYPRESS_DBUSERNAME'","DBPASSWORD": "'$CYPRESS_DBPASSWORD'","DBNAME": "'$CYPRESS_DBNAME'",  "FILESDIR": "'$CYPRESS_FILESDIR'"}' > cypress.env.json

if [[ "$NODE_VERSION" -gt "13"  ]]; then
  npx cypress run --headless --browser chrome --config '{"specPattern":["cypress/tests/data/**/*.cy.js"]}'
fi

if [[ "$NODE_VERSION" -lt "13"  ]]; then
  npx cypress run --headless --browser chrome --headless --browser chrome --config integrationFolder=cypress/tests/data
fi

