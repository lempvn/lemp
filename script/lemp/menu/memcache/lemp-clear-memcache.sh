#!/bin/bash
. /home/lemp.conf

# Kiem tra xem Memcached co dang chay khong
if [ "$(systemctl is-active memcached.service)" == "active" ]; then
    echo "-------------------------------------------------------------------------"
    echo "Please wait...."; sleep 1
    echo "flush_all" | nc -q 2 localhost 11211 
    clear
    echo "========================================================================= "
    echo "Clear memcached thanh cong !"
    /etc/lemp/menu/memcache/lemp-before-memcache-menu.sh
else
    clear
    echo "========================================================================= "
    echo "Memcached dang tat tren server."
    /etc/lemp/menu/memcache/lemp-before-memcache-menu.sh
    exit
fi
