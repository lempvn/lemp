#!/bin/bash
echo "Please wait....";sleep 1
clear
echo "========================================================================="
echo "Authenication Failures: $(zgrep -i 'authentication failure' /var/log/auth.log | wc -l)"
/etc/lemp/menu/lemp-check-thong-tin-server.sh
