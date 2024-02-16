#!/bin/bash

#
# USAGE:
# runAllTests.sh [options]
#  -C Include class tests in lib/pkp.
#  -P Include plugin tests in lib/pkp.
#  -c Include class tests in application.
#  -p Include plugin tests in application.
#  -d Display debug output from phpunit.
# If no options are specified, then all tests will be executed.
#
# Some tests will certain require environment variables in order to cnfigure
# Set  environment variables.
#export BASEURL="http://localhost" # This is the URL to the installation directory.
export DBHOST=localhost # Database hostname
export DBNAME=${APPLICATION} # Database name
export DBUSERNAME=${APPLICATION} # Database username
export DBPASSWORD=${APPLICATION} # Database password
export FILESDIR=files # Files directory (relative to application directory -- do not do this in production!)
export DATABASEDUMP=database.sql.gz  # Path and filename where a database dump can be created/accessed
export FILESDUMP=files.tar.gz # Path and filename where a database dump can be created/accessed

set -e # Fail on first error


### Command Line Options ###

# Run all types of tests by default, unless one or more is specified
DO_ALL=1

# Various types of tests
DO_PKP_CLASSES=0
DO_PKP_PLUGINS=0
DO_APP_CLASSES=0
DO_APP_PLUGINS=0
DO_COVERAGE=0
DEBUG=""

# Parse arguments
while getopts "CPcpdR" opt; do
	case "$opt" in
		C)	DO_ALL=0
			DO_PKP_CLASSES=1
			;;
		P)	DO_ALL=0
			DO_PKP_PLUGINS=1
			;;
		c)	DO_ALL=0
			DO_APP_CLASSES=1
			;;
		p)	DO_ALL=0
			DO_APP_PLUGINS=1
			;;
		d)	DEBUG="--debug"
			;;
		R)	DO_COVERAGE=1
			;;
	esac
done
PHPUNIT='php lib/pkp/lib/vendor/phpunit/phpunit/phpunit --configuration lib/pkp/tests/phpunit.xml --testdox --no-interaction'

# Where to look for tests
TEST_SUITES='--testsuite '

if [ \( "$DO_ALL" -eq 1 \) -o \( "$DO_PKP_CLASSES" -eq 1 \) ]; then
	TEST_SUITES="${TEST_SUITES}LibraryClasses,"
fi

if [ \( "$DO_ALL" -eq 1 \) -o \( "$DO_PKP_PLUGINS" -eq 1 \) ]; then
	TEST_SUITES="${TEST_SUITES}LibraryPlugins,"
fi

if [ \( "$DO_ALL" -eq 1 \) -o \( "$DO_APP_CLASSES" -eq 1 \) ]; then
	TEST_SUITES="${TEST_SUITES}ApplicationClasses,"
fi

if [ \( "$DO_ALL" -eq 1 \) -o \( "$DO_APP_PLUGINS" -eq 1 \) ]; then
	TEST_SUITES="${TEST_SUITES}ApplicationPlugins,"
fi

if [ "$DO_COVERAGE" -eq 1 ]; then
	export XDEBUG_MODE=coverage
fi

$PHPUNIT $DEBUG -v ${TEST_SUITES%%,}

if [ "$DO_COVERAGE" -eq 1 ]; then
	cat lib/pkp/tests/results/coverage.txt
fi
