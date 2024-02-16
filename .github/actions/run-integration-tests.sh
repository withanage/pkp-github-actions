#!/bin/bash

export CYPRESS_DBHOST='127.0.0.1' # Database hostname
export CYPRESS_FILESDIR='files'
export CYPRESS_BASE_URL='http://127.0.0.1:8000'
export CYPRESS_DBNAME=${APPLICATION} # Database name
export CYPRESS_DBUSERNAME=${APPLICATION} # Database username
export CYPRESS_DBPASSWORD=${APPLICATION} # Database password



cp cypress.travis.env.json cypress.env.json

npx cypress run --headless --browser chrome --config '{"specPattern":["cypress/tests/data/**/*.cy.js"]}'
npx cypress run --headless --browser chrome --config '{"specPattern":["lib/pkp/cypress/tests/integration/**/*.cy.js"]}'
if [ -d "cypress/tests/integration" ]; then
  npx cypress run --headless --browser chrome --config '{"specPattern":["cypress/tests/integration/**/*.cy.js"]}'
fi
