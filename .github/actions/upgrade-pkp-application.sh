#!/bin/bash

# @file actions/upgrade-pkp-application.sh
#
# Copyright (c) 2014-2025 Simon Fraser University
# Copyright (c) 2010-2025 John Willinsky
# Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
#
# Script to run a PKP application upgrade for testing purposes

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

  sudo -u postgres psql -c "DROP DATABASE \"${DBNAME}\";" -U postgres
  sudo -u postgres psql -c "DROP USER \"${DBUSERNAME}\" ;" -U postgres

elif [[ "$TEST" == "mysql" ]]; then

  sudo mysql -u root -e "DROP DATABASE  \`${DBNAME}\` ";
  sudo mysql -u root -e "DROP USER \`${DBUSERNAME}\`@${DBHOST}";

fi
