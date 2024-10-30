#!/bin/bash
. /home/lemp.conf
echo "========================================================================="
echo "Dung chuc nang nay de BAT/TAT che do Auto backup database tren server"
echo "-------------------------------------------------------------------------"
echo -n "Nhap ten Database [ENTER]: " 
read dataname
if [ "$dataname" = "" ]; then
clear
echo "========================================================================="
echo "Ban chua nhap ten database !"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
exit
fi
if [ ! -f /var/lib/mysql/$dataname/db.opt ]; then
clear
echo "========================================================================="
echo "Database: $dataname khong ton tai tren he thong"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
exit
fi
if [ "$(ls -1 /var/lib/mysql/$dataname | wc -l)" == 1 ]; then
clear
echo "========================================================================="
echo "Database $dataname chua co du lieu"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
exit
fi

rm -rf /tmp/databaseautobackup
echo "$dataname" > /tmp/databaseautobackup
if [ -f /bin/lemp-backupdb-$dataname ]; then
 if [ -f /etc/cron.d/lemp.db.cron ]; then
     if [ ! "$(grep lemp-backupdb-$dataname /etc/cron.d/lemp.db.cron)" == "" ]; then
     /etc/lemp/menu/lemp-TAT-tu-dong-sao-luu-database.sh
     fi
 fi
fi 
 /etc/lemp/menu/lemp-BAT-tu-dong-sao-luu-database.sh
