#!/bin/bash
clear
echo "-------------------------------------------------------------------------"
echo "Bat dau go cai dat Memcached"
echo "Please wait...."; sleep 1
rm -rf /etc/memcached.conf
sudo DEBIAN_FRONTEND=noninteractive apt -yqq remove memcached
clear
echo "========================================================================= "
echo "Go cai dat Memcached thanh cong."
/etc/lemp/menu/memcache/lemp-before-memcache-menu.sh