#!/bin/bash 
. /home/lemp.conf

# Kiem tra xem Redis co dang chay khong
if [ ! "$(redis-cli ping)" = "PONG" ]; then
    clear
    echo "========================================================================="
    echo "Redis dang dung"
    echo "-------------------------------------------------------------------------"
    echo "Ban phai bat Redis len bang lenh [ systemctl start redis.service ]"
    /etc/lemp/menu/redis/lemp-redis-menu.sh
    exit
fi

echo "-------------------------------------------------------------------------"
echo "Please wait ..." 
sleep 1

# Xoa tat ca du lieu trong Redis
( echo "flushall" ) | redis-cli
clear

echo "========================================================================="
echo "Xoa cache Redis thanh cong"
echo "-------------------------------------------------------------------------"
/etc/lemp/menu/redis/lemp-redis-menu.sh
