#!/bin/bash
. /home/lemp.conf

# Kiem tra xem Redis co dang chay khong
if [ ! "$(redis-cli ping)" = "PONG" ]; then
    # Khoi dong dich vu Redis
    systemctl restart redis
    clear
    /etc/lemp/menu/redis/lemp-redis-menu-no-config.sh
else
    /etc/lemp/menu/redis/lemp-redis-menu.sh
fi
