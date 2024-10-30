#!/bin/bash
. /home/lemp.conf

# Kiem tra trang thai Redis va khoi dong lai neu dang chay
if [ "$(systemctl is-active redis.service)" == "active" ]; then
    echo "Please wait...."; sleep 1
    systemctl restart redis.service
    clear
    echo "========================================================================= "
    echo "Restart Redis thanh cong!"
    /etc/lemp/menu/redis/lemp-before-redis-menu
else
    clear
    echo "========================================================================= "
    echo "Redis Cache dang tat tren server."
    /etc/lemp/menu/redis/lemp-before-redis-menu
    exit
fi
