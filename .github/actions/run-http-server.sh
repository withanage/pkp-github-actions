#!/bin/bash

sudo apt-get install socat
sudo socat TCP-LISTEN:80,fork,reuseaddr TCP:localhost:8000 &

# Run the PHP internal server on port 8080.
php -S 127.0.0.1:8000 -t . >& access.log &
sleep 3
if nc -z localhost 80 2>/dev/null; then
   echo "Info: localhost:80 is accessible"
else
  echo ":Warning: localhost:80 cannot be accessed"
  exit 1

fi