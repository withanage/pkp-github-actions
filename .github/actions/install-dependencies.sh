#!/bin/bash


set -e

# Search for composer.json files, and run Composer to install the dependencies.
find . -maxdepth 4 -name composer.json -exec bash -c 'composer --no-ansi --working-dir="`dirname {}`" install --optimize-autoloader' ";"

sudo npm cache clean -f
sudo npm install -g n
sudo n  $NODE_VERSION
source ~/.bashrc

# Install node modules
npm i g -npm
npm i @vue/cli-service
npm i cypress@12.17.4
npm install
npm run build
