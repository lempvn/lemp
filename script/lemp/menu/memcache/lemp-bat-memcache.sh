#!/bin/bash
. /home/lemp.conf


systemctl start memcached.service
systemctl enable memcached.service 
clear
echo "========================================================================= "
echo "Bat Memcached thanh cong."
/etc/lemp/menu/memcache/lemp-before-memcache-menu.sh
