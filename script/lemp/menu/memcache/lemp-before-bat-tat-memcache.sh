#!/bin/bash
. /home/lemp.conf

if [ -f /etc/init.d/memcached ]; then 
    if [ "$(systemctl is-active memcached.service)" == "active" ]; then
        /etc/lemp/menu/memcache/lemp-tat-memcache.sh
        exit
    fi
    if [ "$(systemctl is-active memcached.service)" == "inactive" ]; then
        /etc/lemp/menu/memcache/lemp-bat-memcache.sh
        clear
        exit
    fi
fi

clear
echo "========================================================================="
echo "Sorry, LEMP khong phat hien Memcached tren he thong !"
lemp
exit
