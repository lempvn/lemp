#!/bin/bash

if [ "$(redis-cli ping)" = "PONG" ]; then
echo "Working" > /tmp/lemp-redis-info.txt
else
echo "Stopped" > /tmp/lemp-redis-info.txt
fi
