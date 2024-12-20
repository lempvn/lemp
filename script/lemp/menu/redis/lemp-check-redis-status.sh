#!/bin/bash 
. /home/lemp.conf

# Kiem tra trang thai cua Redis
if [ ! "$(redis-cli ping)" = "PONG" ]; then
    clear
    echo "========================================================================="
    echo "Redis dang dung"
    echo "-------------------------------------------------------------------------"
    echo "Ban phai bat Redis len bang lenh [systemctl start redis.service]"
    /etc/lemp/menu/redis/lemp-redis-menu.sh
    exit
fi

echo "========================================================================="
echo "Chuc nang nay se kiem tra trang thai Redis trong 30 giay" 
echo "-------------------------------------------------------------------------"
echo "Sau do se tu dong quay tro lai Menu Quan Ly Redis Cache"
echo "-------------------------------------------------------------------------"
echo "Sau khi nhan [Enter], ban truy cap website da bat Redis"
echo "-------------------------------------------------------------------------"
echo "Va nhin vao trang thai Redis duoi dong nay"
echo "========================================================================="
read -p "Nhan [Enter] de bat dau kiem tra ..."

# Kiem tra trang thai Redis trong 30 giay
timeout 30 redis-cli monitor
clear

echo "========================================================================="
echo "Kiem tra Redis hoan thanh!"
echo "-------------------------------------------------------------------------"
echo "Redis dang hoat dong"
/etc/lemp/menu/redis/lemp-redis-menu.sh
