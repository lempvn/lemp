#!/bin/bash

echo "=========================================================================="
echo "chmod 755 menu... "
echo "=========================================================================="

find /etc/lemp/menu -type f -exec chmod 755 {} \;
#find /etc/lemp/menu/checkddos -type f -exec chmod 755 {} \;
#find /etc/lemp/menu/crontab -type f -exec chmod 755 {} \;
#find /etc/lemp/menu/CSF-Fiwall -type f -exec chmod 755 {} \;
#find /etc/lemp/menu/database-example -type f -exec chmod 755 {} \;
#find /etc/lemp/menu/downloadlog -type f -exec chmod 755 {} \;
#find /etc/lemp/menu/memcache -type f -exec chmod 755 {} \;
#find /etc/lemp/menu/menucheck -type f -exec chmod 755 {} \;
#find /etc/lemp/menu/nang-cap-mariaDB -type f -exec chmod 755 {} \;
#find /etc/lemp/menu/nangcap-php -type f -exec chmod 755 {} \;
#find /etc/lemp/menu/opcache -type f -exec chmod 755 {} \;
#find /etc/lemp/menu/pagespeed -type f -exec chmod 755 {} \;
#find /etc/lemp/menu/swap -type f -exec chmod 755 {} \;
#find /etc/lemp/menu/tienich -type f -exec chmod 755 {} \;

#for d in /opt/vps_lemp/script/lemp/menu/*
for d in /etc/lemp/menu/*
do
	if [ -d $d ]; then
		echo $d
		find $d -type f -exec chmod 755 {} \;
	fi
done
