#!/bin/bash
. /home/lemp.conf

# Kiem tra xem Redis co dang chay khong
if [ ! "$(redis-cli ping)" = "PONG" ]; then
    # Khoi dong dich vu Redis
    systemctl start redis.service
    clear
    /etc/lemp/menu/redis/lemp-install-redis.sh
else
    /etc/lemp/menu/redis/lemp-remove-redis.sh
fi
