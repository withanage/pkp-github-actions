#!/bin/bash

# @file tools/travis/run-tests.sh
#
# Copyright (c) 2014-2021 Simon Fraser University
# Copyright (c) 2010-2021 John Willinsky
# Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
#
# Script to run data build, unit, and integration tests.
#

set -e

export BASEURL="http://localhost" # This is the URL to the installation directory.
export DBHOST=localhost # Database hostname
export DBNAME=${APPLICATION} # Database name
export DBUSERNAME=${APPLICATION} # Database username
export DBPASSWORD=${APPLICATION} # Database password
export FILESDIR=files # Files directory (relative to application directory -- do not do this in production!)
export DATABASEDUMP=database.sql.gz  # Path and filename where a database dump can be created/accessed
export FILESDUMP=files.tar.gz # Path and filename where a database dump can be created/accessed


tar czf ${FILESDUMP} ${FILESDIR}

# If desired, store the built dataset in https://github.com/pkp/datasets
if [[ "GITHUB_PULL_REQUEST" == "false" && "$SAVE_BUILD" == "true" ]]; then
	git clone --depth 1 https://pkp-machine-user:${GITHUB_ACCESS_KEY}@github.com/pkp/datasets
	rm -rf datasets/${APPLICATION}/${DATASET_BRANCH}/${TEST}
	mkdir -p datasets/${APPLICATION}/${DATASET_BRANCH}/${TEST}
	zcat ${DATABASEDUMP} > datasets/${APPLICATION}/${DATASET_BRANCH}/${TEST}/database.sql

	tar -C datasets/${APPLICATION}/${DATASET_BRANCH}/${TEST} -x -z -f ${FILESDUMP}
	# The geolocation DB is too big for github; do not include it
	rm -f datasets/${APPLICATION}/${DATASET_BRANCH}/${TEST}/files/usageStats/IPGeoDB.mmdb

	cp config.inc.php datasets/${APPLICATION}/${DATASET_BRANCH}/${TEST}/config.inc.php
	cp -r public datasets/${APPLICATION}/${DATASET_BRANCH}/${TEST}
	rm -f datasets/${APPLICATION}/${DATASET_BRANCH}/${TEST}/public/.gitignore

	# Add sample export data to the datasets, as appropriate for the app
	case "$APPLICATION" in
		ojs) php tools/importExport.php NativeImportExportPlugin export datasets/${APPLICATION}/${DATASET_BRANCH}/${TEST}/native-export-sample.xml publicknowledge issue 1 ;;
		omp) php tools/importExport.php NativeImportExportPlugin export datasets/${APPLICATION}/${DATASET_BRANCH}/${TEST}/native-export-sample.xml publicknowledge monograph 1 ;;
		ops) php tools/importExport.php NativeImportExportPlugin export datasets/${APPLICATION}/${DATASET_BRANCH}/${TEST}/native-export-sample.xml publicknowledge preprint 1 ;;
	esac

	cd datasets
	git add --all
	git commit -m "Update datasets (${DATASET_BRANCH})"
	git push
	cd ..
fi

