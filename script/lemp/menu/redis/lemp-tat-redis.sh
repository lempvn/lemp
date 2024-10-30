#!/bin/bash
. /home/lemp.conf

echo "-------------------------------------------------------------------------" 
echo "Please wait....";sleep 1
systemctl disable redis
systemctl stop redis

clear
echo "========================================================================= "
echo "Stop Redis thanh cong !"
/etc/lemp/menu/redis/lemp-redis-menu.sh
