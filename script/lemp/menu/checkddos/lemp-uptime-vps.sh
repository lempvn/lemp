#!/bin/bash
echo "Please wait....";sleep 1
clear
echo "========================================================================="
echo "VPS Uptime: $(uptime | awk '{print $3,$4}' | sed 's/,/ /g')"
/etc/lemp/menu/lemp-check-thong-tin-server.sh