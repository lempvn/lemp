#!/bin/bash
echo "Please wait...."; sleep 1
clear
echo "========================================================================="
echo "Last APT update: $(grep 'apt-get upgrade' /var/log/dpkg.log | awk '{print $1,$2,$3}' | tail -n 1)"
/etc/lemp/menu/lemp-check-thong-tin-server.sh
