#!/bin/bash

set -e

export DBHOST=localhost # Database hostname
export DBNAME=${APPLICATION}-ci # Database name
export DBUSERNAME=${APPLICATION}-ci # Database username
export DBPASSWORD=${APPLICATION}-ci # Database password


source  $GITHUB_WORKSPACE/pkp-github-actions/.github/actions/ingest_datasets.sh
source  $GITHUB_WORKSPACE/pkp-github-actions/.github/actions/prepare-logs.sh


php tools/upgrade.php check
php tools/upgrade.php upgrade


if [[ "$TEST" == "pgsql" ]]; then

  psql -c "DROP DATABASE \"${DBNAME}\";" -U postgres
  psql -c "DROP USER \"${DBUSERNAME}\" ;" -U postgres

elif [[ "$TEST" == "mysql" ]]; then

  sudo mysql -u root -e "DROP DATABASE  \`${DBNAME}\` ";
  sudo mysql -u root -e "DROP USER \`${DBUSERNAME}\`@${DBHOST}";

fi