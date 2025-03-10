#!/bin/bash

# @file actions/checkout_user_repo.sh
#
# Copyright (c) 2014-2025 Simon Fraser University
# Copyright (c) 2010-2025 John Willinsky
# Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
#
# Script to dump a copy of the database.

set -e # Fail on first error

export DBHOST=localhost # Database hostname
export DBNAME=${APPLICATION}-ci # Database name
export DBUSERNAME=${APPLICATION}-ci # Database username
export DBPASSWORD=${APPLICATION}-ci # Database password
export DATABASEDUMP=database.sql.gz # Path and filename where a database dump can be created/accessed
export FILESDUMP=files.tar.gz # Path and filename where a database dump can be created/accessed
export DBTYPE=${DBTYPE}


# Dump the completed database.
case "$DBTYPE" in
	PostgreSQL)
	 pg_dump --clean --username=$DBUSERNAME --host=$DBHOST $DBNAME | gzip -9 > $DATABASEDUMP
		;;
	MySQL|MySQLi)
    mysqldump --no-tablespaces --user=$DBUSERNAME --password=$DBPASSWORD --host=$DBHOST $DBNAME | gzip -9 > $DATABASEDUMP
		;;
	*)
		echo "Unknown DBTYPE \"${DBTYPE}\"!"
		exit 1
esac

