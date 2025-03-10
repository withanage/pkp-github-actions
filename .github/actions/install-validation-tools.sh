#!/bin/bash

# @file actions/install-validation-tools.sh
#
# Copyright (c) 2014-2025 Simon Fraser University
# Copyright (c) 2010-2025 John Willinsky
# Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
#
# Script to install the validation tools

set -e
wget https://www.python.org/ftp/python/2.7.9/Python-2.7.9.tgz
sudo tar xzf Python-2.7.9.tgz
cd Python-2.7.9
sudo ./configure --enable-optimizations
sudo make altinstall
cd ../
wget https://bootstrap.pypa.io/pip/2.7/get-pip.py
sudo python2 get-pip.py
sudo pip install six
sudo pip install https://github.com/google/closure-linter/zipball/master
wget "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/jslint4java/jslint4java-2.0.2-dist.zip"
unzip jslint4java-2.0.2-dist.zip
mv jslint4java-2.0.2/jslint4java-2.0.2.jar ~/bin/jslint4java.jar
