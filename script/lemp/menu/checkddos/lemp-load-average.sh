#!/bin/bash
echo "Please wait....";sleep 1
clear
echo "========================================================================="
echo "CPU Load Average: $(uptime | awk '{print $10,$11,$12}' | sed 's/,/ /g')"
/etc/lemp/menu/lemp-check-thong-tin-server.sh