#!/bin/bash
clear
echo "-------------------------------------------------------------------------"
echo "Chuan bi qua trinh cai dat Redis"
echo "Please wait....";sleep 1
sudo DEBIAN_FRONTEND=noninteractive apt -yqq install redis
echo "-------------------------------------------------------------------------"
echo "Please wait....";sleep 1
systemctl start redis.service
systemctl enable redis.service
clear
echo "========================================================================= "
echo "Cai dat Redis Cache thanh cong."
/etc/lemp/menu/redis/lemp-redis-before-menu.sh

