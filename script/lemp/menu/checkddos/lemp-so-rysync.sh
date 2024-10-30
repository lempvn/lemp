#!/bin/bash
echo "Please wait....";sleep 1
clear
echo "========================================================================="
echo "Connections SYN_RECV: $(netstat -n | grep :80 | grep SYN_RECV|wc -l)"
echo "Connections SYN_RECV on port 443: $(netstat -n | grep :443 | grep SYN_RECV | wc -l)"

/etc/lemp/menu/lemp-kiem-tra-ddos.sh
