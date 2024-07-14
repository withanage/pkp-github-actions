#!/bin/bash

set -e

export DBHOST=localhost # Database hostname
export DBNAME=${APPLICATION}-ci # Database name
export DBUSERNAME=${APPLICATION}-ci # Database username
export DBPASSWORD=${APPLICATION}-ci # Database password

if [ ! -d "files" ]; then
    mkdir files
fi
if [ ! -d "public" ]; then
    mkdir public
fi


cp -rf ~/datasets/${APPLICATION}/${DATASET_BRANCH}/${TEST}/files/* files/
cp -rf ~/datasets/${APPLICATION}/${DATASET_BRANCH}/${TEST}/public/* public/
cp  ~/datasets/${APPLICATION}/${DATASET_BRANCH}/${TEST}/config.inc.php .

if [[ "${APP_BRANCH}" == "stable-3_4_0"  || "${APP_BRANCH}" == "main"  ]]; then
  PATCH1=~/datasets/upgrade/3_4_0-add-email-config.diff
  PATCH2=~/datasets/upgrade/3_4_0-update-locale.diff

  if patch --dry-run -p1 < $PATCH1; then
     patch -p1 < $PATCH1
  else
     echo "Dry run for $PATCH1 failed. Aborting."
  fi

  if patch --dry-run -p1 < $PATCH2; then
     patch -p1 < $PATCH2
  else
     echo "Dry run for $PATCH2 failed. Aborting."
  fi

fi

~/datasets/tools/dbclient.sh < ~/datasets/${APPLICATION}/${DATASET_BRANCH}/${TEST}/database.sql