#!/bin/bash
. /home/lemp.conf

echo "-------------------------------------------------------------------------"
echo "Please wait....";sleep 1
systemctl restart redis
systemctl enable redis-server

clear
echo "========================================================================= "
echo "Bat Redis Cache thanh cong."
/etc/lemp/menu/redis/lemp-redis-menu.sh
