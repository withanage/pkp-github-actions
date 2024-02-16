#!/bin/bash

# Script to dump a copy of the database.

set -e # Fail on first error

export DBHOST=localhost # Database hostname
export DBNAME=${APPLICATION} # Database name
export DBUSERNAME=${APPLICATION} # Database username
export DBPASSWORD=${APPLICATION} # Database password
export DATABASEDUMP=database.sql.gz # Path and filename where a database dump can be created/accessed
export FILESDUMP=~/files.tar.gz # Path and filename where a database dump can be created/accessed
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

