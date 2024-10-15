#!/bin/bash

set -e
sudo apt install python2
wget https://bootstrap.pypa.io/pip/2.7/get-pip.py
sudo python2 get-pip.py
sudo pip install six
sudo pip install https://github.com/google/closure-linter/zipball/master
wget "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/jslint4java/jslint4java-2.0.2-dist.zip"
unzip jslint4java-2.0.2-dist.zip
mv jslint4java-2.0.2/jslint4java-2.0.2.jar ~/bin/jslint4java.jar
