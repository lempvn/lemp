#!/bin/bash

# Kiem tra trang thai dich vu MariaDB
if systemctl is-active --quiet mariadb; then
    echo "Please wait...."; sleep 1
    clear
    echo "========================================================================="
    echo "RAM MariaDB su dung: $(ps aux | grep mariadb | grep -v "grep" | awk '{ s += $6 } END { print s/1024, "Mb"}')"
    /etc/lemp/menu/lemp-check-thong-tin-server.sh
else
    clear
    echo "========================================================================="
    echo "MariaDB status: Stopped"
    /etc/lemp/menu/lemp-check-thong-tin-server.sh
    exit
fi
