#!/bin/bash
clear
echo "-------------------------------------------------------------------------"
echo "Chuan bi qua trinh cai dat Memcached"
echo "Please wait....";sleep 1
sudo DEBIAN_FRONTEND=noninteractive apt -yqq install memcached
echo "-------------------------------------------------------------------------"
echo "Please wait....";sleep 1
systemctl start memcached.service
systemctl enable memcached.service
clear
echo "========================================================================= "
echo "Cai dat Memcached thanh cong."
/etc/lemp/menu/memcache/lemp-before-memcache-menu.sh