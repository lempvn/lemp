#!/bin/bash
. /home/lemp.conf

# Kiem tra trang thai cua Memcached
if [ "$(systemctl is-active memcached.service)" == "active" ]; then
    echo "Please wait...."; sleep 1
    systemctl restart memcached.service
    clear
    echo "========================================================================= "
    echo "Restart memcached thanh cong !"
    /etc/lemp/menu/memcache/lemp-before-memcache-menu.sh
else
    clear
    echo "========================================================================= "
    echo "Memcached dang Disable tren server."
    /etc/lemp/menu/memcache/lemp-before-memcache-menu.sh
    exit
fi
