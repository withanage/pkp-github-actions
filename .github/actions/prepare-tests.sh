#!/bin/bash

set -e


# Set  environment variables.
export BASEURL="http://localhost" # This is the URL to the installation directory.
export DBHOST=localhost # Database hostname
export DBNAME=${APPLICATION} # Database name
export DBUSERNAME=${APPLICATION} # Database username
export DBPASSWORD=${APPLICATION} # Database password
export FILESDIR=files # Files directory (relative to application directory -- do not do this in production!)

# Install required software
sudo apt-get install -q -y libbiblio-citation-parser-perl libhtml-parser-perl

# Create the database and grant permissions.
if [[ "$TEST" == "pgsql" ]]; then
  sudo service postgresql start
	psql -c "DROP DATABASE IF EXISTS \"${DBNAME}\";" -U postgres
  psql -c "DROP USER IF EXISTS  \"${DBUSERNAME}\" ;" -U postgres
	psql -c "CREATE DATABASE \"${DBNAME}\";" -U postgres
	psql -c "CREATE USER \"${DBUSERNAME}\" WITH PASSWORD '${DBPASSWORD}';" -U postgres
	psql -c "GRANT ALL PRIVILEGES ON DATABASE \"${DBNAME}\" TO \"${DBUSERNAME}\";" -U postgres
	echo "${DBHOST}:5432:${DBNAME}:${DBUSERNAME}:${DBPASSWORD}" > ~/.pgpass
	chmod 600 ~/.pgpass
	export DBTYPE=PostgreSQL
elif [[ "$TEST" == "mysql" ]]; then
	sudo service mysql start
	sudo mysql -u root -e "DROP DATABASE IF EXISTS  \`${DBNAME}\` ";
  sudo mysql -u root -e "DROP USER IF EXISTS \`${DBUSERNAME}\`@${DBHOST}";
	sudo mysql -u root -e "CREATE DATABASE \`${DBNAME}\` DEFAULT CHARACTER SET utf8"
	sudo mysql -u root -e "CREATE USER \`${DBUSERNAME}\`@${DBHOST} IDENTIFIED BY '${DBPASSWORD}'"
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

# Make the files directory (this will be files_dir in config.inc.php after installation).
mkdir -p files
mkdir -p public


set +e
