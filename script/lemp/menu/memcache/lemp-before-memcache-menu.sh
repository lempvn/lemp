#!/bin/bash

# Kiem tra xem file cau hinh cua Memcached co ton tai khong
if [ -f /etc/memcached.conf ]; then
    # Neu ton tai file cau hinh, chay menu phu hop
    /etc/lemp/menu/memcache/lemp-memcache-menu.sh
else
    # Neu khong ton tai, chay menu khac
    /etc/lemp/menu/memcache/lemp-memcache-menu-no-config.sh
fi

