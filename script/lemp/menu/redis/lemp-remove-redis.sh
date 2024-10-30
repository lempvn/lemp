#!/bin/bash
clear
echo "-------------------------------------------------------------------------"
echo "Bat dau go cai dat Redis Cache"
echo "Please wait....";sleep 1
rm -rf /etc/redis/redis.conf
sudo DEBIAN_FRONTEND=noninteractive apt -yqq remove redis*
clear
echo "========================================================================= "
echo "Go cai dat Redis Cache thanh cong."
/etc/lemp/menu/redis/lemp-redis-before-menu.sh
