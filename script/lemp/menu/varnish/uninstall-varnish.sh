#!/bin/bash

# Go bo Varnish tren Ubuntu da cai dat tu packagecloud.io

remove_varnish_repo () {
    # Xoa repository Varnish
    rm -rf /etc/apt/sources.list.d/varnishcache*
}

echo "========================================================================="

# Kiem tra phien ban Varnish hien tai
if [ -f /etc/lemp/varnish.version ]; then
    printf "                   Phien ban Varnish hien tai: $(cat /etc/lemp/varnish.version) \n"
else
    printf "                  Varnish Cache chua duoc cai dat\n"
    printf "          Hoac khong duoc cai dat thong qua LEMP \n"
fi

echo "-------------------------------------------------------------------------"
varnishd -V
echo "========================================================================="
echo "Xoa repo: rm -rf /etc/apt/sources.list.d/varnishcache_varnish74.list"
echo "========================================================================="

echo -n "Ban co muon go bo Varnish Cache khong? [y/N] "
read goBoVarnish

if [ "$goBoVarnish" = "y" ]; then
    clear
    echo "Ok ok! Chuan bi go bo Varnish Cache..."
    sleep 2

    # Kiem tra va go bo Varnish
    dpkg -l | grep -i varnish
    sudo apt-get -y remove --purge varnish
    remove_varnish_repo
    sudo apt-get update
    dpkg -l | grep -i varnish
else
    echo "Huy bo thao tac: go bo Varnish Cache..."
    sleep 2
    clear
fi

# Chay lai lenh cai dat (neu can)
#/etc/lemp/menu/varnish/install-varnish.sh
