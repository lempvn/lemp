#!/bin/bash
. /home/lemp.conf

# Kiem tra xem Redis co dang chay tren Ubuntu khong
if [ "$(systemctl is-active redis.service)" == "active" ]; then
    clear
    /etc/lemp/menu/redis/lemp-tat-redis.sh
    exit
else
    clear
    /etc/lemp/menu/redis/lemp-bat-redis.sh
    exit
fi

# Neu khong phat hien Redis
clear
echo "========================================================================="
echo "Xin loi, LEMP khong phat hien Redis Cache tren he thong!"
lemp
exit
