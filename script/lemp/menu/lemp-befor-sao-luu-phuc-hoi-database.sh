#!/bin/sh
. /home/lemp.conf
if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
if [ "$(/sbin/service mysql status | awk 'NR==1 {print $3}')" == "running" ]; then
clear
/etc/lemp/menu/lemp-sao-luu-phuc-hoi-database.sh
else
clear
echo "========================================================================="
echo "Sorry, MariaDB dang stopped. Hay bat len truoc khi dung chuc nang nay!"
echo "-------------------------------------------------------------------------"
echo "Ban co the thu khoi dong MariaDB bang lenh [ service mysql start ]"
lemp
exit
fi
fi
#if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "7" ]; then 
if [ ! "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
/etc/lemp/menu/lemp-sao-luu-phuc-hoi-database.sh
fi
