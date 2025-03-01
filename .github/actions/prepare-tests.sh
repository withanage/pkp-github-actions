#!/bin/bash

# @file actions/prepare-tests.sh
#
# Copyright (c) 2014-2025 Simon Fraser University
# Copyright (c) 2010-2025 John Willinsky
# Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
#
# Script to prepare the environment for running tests

set -e


# Set  environment variables.
export BASEURL="http://localhost" # This is the URL to the installation directory.
export DBHOST=localhost # Database hostname
export DBNAME=${APPLICATION}-ci # Database name
export DBUSERNAME=${APPLICATION}-ci # Database username
export DBPASSWORD=${APPLICATION}-ci # Database password
export FILESDIR=files # Files directory (relative to application directory -- do not do this in production!)
export DATABASEDUMP=database.sql.gz # Path and filename where a database dump can be created/accessed
export FILESDUMP=files.tar.gz # Path and filename where a database dump can be created/accessed

export CYPRESS_DBHOST='127.0.0.1' # Database hostname
export CYPRESS_BASE_URL='http://localhost:80'
export CYPRESS_DBNAME=${APPLICATION}-ci # Database name
export CYPRESS_DBUSERNAME=${APPLICATION}-ci # Database username
export CYPRESS_DBPASSWORD=${APPLICATION}-ci # Database password
export CYPRESS_FILESDIR=files
echo '{ "baseUrl": "'${CYPRESS_BASE_URL}'", "DBHOST": "'${CYPRESS_DBHOST}'", "DBUSERNAME": "'$CYPRESS_DBUSERNAME'","DBPASSWORD": "'$CYPRESS_DBPASSWORD'","DBNAME": "'$CYPRESS_DBNAME'",  "FILESDIR": "'$CYPRESS_FILESDIR'"}' > cypress.env.json

# Install required software
sudo apt-get install -q -y libbiblio-citation-parser-perl libhtml-parser-perl


# Create the database and grant permissions.
if [[ "$TEST" == "pgsql" ]]; then
  echo "${DBHOST}:5432:${DBNAME}:${DBUSERNAME}:${DBPASSWORD}" > ~/.pgpass
  chmod 600 ~/.pgpass
  sudo service postgresql restart
	sudo -u postgres psql -c "DROP DATABASE IF EXISTS \"${DBNAME}\";" -U postgres
  sudo -u postgres psql -c "DROP USER IF EXISTS  \"${DBUSERNAME}\" ;" -U postgres
  sudo -u postgres psql -c "CREATE USER \"${DBUSERNAME}\" WITH PASSWORD '${DBPASSWORD}';" -U postgres
  sudo -u postgres psql -c "CREATE DATABASE  \"${DBNAME}\" OWNER \"${DBUSERNAME}\" ;" -U postgres

	export DBTYPE=PostgreSQL
elif [[ "$TEST" == "mysql" ]]; then
	sudo service mysql start
	sudo mysql -u root -e "DROP DATABASE IF EXISTS  \`${DBNAME}\` ";
  sudo mysql -u root -e "DROP USER IF EXISTS \`${DBUSERNAME}\`@${DBHOST}";
	sudo mysql -u root -e "CREATE DATABASE \`${DBNAME}\` DEFAULT CHARACTER SET utf8"
	sudo mysql -u root -e "CREATE USER \`${DBUSERNAME}\`@${DBHOST} IDENTIFIED WITH mysql_native_password BY '${DBPASSWORD}';  ";
	sudo mysql -u root -e "GRANT ALL ON \`${DBNAME}\`.* TO \`${DBUSERNAME}\`@${DBHOST} WITH GRANT OPTION"
	export DBTYPE=MySQLi
elif [[ "$TEST" == "mariadb" ]]; then
	sudo service mariadb start
	sudo mysql -u root -e "DROP DATABASE IF EXISTS  \`${DBNAME}\` ";
  sudo mysql -u root -e "DROP USER IF EXISTS \`${DBUSERNAME}\`@${DBHOST}";
  sudo mysql -u root -e "CREATE DATABASE \`${DBNAME}\` DEFAULT CHARACTER SET utf8"
	sudo mysql -u root -e "CREATE USER \`${DBUSERNAME}\`@${DBHOST} IDENTIFIED BY '${DBPASSWORD}'"
	sudo mysql -u root -e "GRANT ALL ON \`${DBNAME}\`.* TO \`${DBUSERNAME}\`@${DBHOST} WITH GRANT OPTION"
	export DBTYPE=MySQLi
fi

# Use the template configuration file.
cp config.TEMPLATE.inc.php config.inc.php

# setup sendria mail server
source  $GITHUB_WORKSPACE/pkp-github-actions/.github/actions/change-configuration.sh

# Use DISABLE_PATH_INFO = 1 to turn on disable_path_info mode in config.inc.php.
if [[ "$DISABLE_PATH_INFO" == "1" ]]; then
	sed -i -e "s/disable_path_info = Off/disable_path_info = On/" config.inc.php
fi

# Make the files directory (this will be files_dir in config.inc.php after installation).
if [ ! -d "files" ]; then
    mkdir files
fi
if [ ! -d "public" ]; then
    mkdir public
fi
