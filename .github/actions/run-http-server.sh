#!/bin/bash

sudo apt-get install socat
sudo socat TCP-LISTEN:80,fork,reuseaddr TCP:localhost:8000 &

# Run the PHP internal server on port 8080.
php -S 127.0.0.1:8000 -t . >& access.log &
sleep 3
if nc -z 127.0.0.1 80 2>/dev/null; then
   echo "Info: Server 127.0.0.1:80 is accessible"
else
  echo ":Warning: Server 127.0.0.1:80 cannot be accessed"
fi