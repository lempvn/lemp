#!/bin/bash
echo "Please wait....";sleep 1
clear
echo "========================================================================="
echo "Connections to 80 Port (http): $(netstat -n | grep :80 |wc -l)"
echo "-------------------------------------------------------------------------"
echo "Connections to 443 Port (https): $(netstat -n | grep :443 |wc -l)"
echo "-------------------------------------------------------------------------"

/etc/lemp/menu/lemp-kiem-tra-ddos.sh
