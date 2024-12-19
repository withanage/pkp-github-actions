#!/bin/bash

set -e

sed -i 's/; smtp_server = mail\.example\.com/smtp_server = localhost/' config.inc.php
sed -i 's/; smtp_port = 25/smtp_port = 1025/' config.inc.php
sed -i 's/; smtp = On/smtp = On/'  config.inc.php
sed -i 's/default = sendmail/default = smtp/' config.inc.php

