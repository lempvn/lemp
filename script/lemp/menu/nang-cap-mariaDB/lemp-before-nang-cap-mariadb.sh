#!/bin/sh
. /home/lemp.conf
if [ -f /etc/yum.repos.d/MariaDB.repo ]; then
 if [ ! "`grep 5.5 /etc/yum.repos.d/MariaDB.repo`" = "" ]; then
 mariadbversion=5.5
 fi
fi
if [ -f /etc/yum.repos.d/mariadb.repo ]; then
 if [ ! "`grep 5.5 /etc/yum.repos.d/mariadb.repo`" = "" ]; then
 mariadbversion=5.5
 fi
fi
if [ ! -f /etc/yum.repos.d/mariadb.repo ]; then
if [ ! -f /etc/yum.repos.d/MariaDB10.repo ]; then
mariadbversion=5.5
fi
fi
if [ "$mariadbversion" = "5.5" ]; then
/etc/lemp/menu/nang-cap-mariaDB/lemp-nang-cap-mariadb-to-10-version.sh
else
clear
echo "========================================================================="
echo "Ban dang su dung MariaDB phien ban 10.0 !"
/etc/lemp/menu/lemp-update-upgrade-service-menu.sh
exit
fi
