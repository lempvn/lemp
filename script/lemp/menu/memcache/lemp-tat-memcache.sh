#!/bin/bash
. /home/lemp.conf

echo "-------------------------------------------------------------------------"
echo "Please wait...."; sleep 1
systemctl disable memcached.service
systemctl stop memcached.service

clear
echo "========================================================================= "
echo "Stop memcached thanh cong !"
/etc/lemp/menu/memcache/lemp-before-memcache-menu.sh
