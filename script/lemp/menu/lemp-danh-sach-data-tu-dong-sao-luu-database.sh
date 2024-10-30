#!/bin/bash
. /home/lemp.conf
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
sleep 1
rm -rf /tmp/lemp-databaselist
ls /var/lib/mysql > /tmp/lemp-databaselist
rm -rf /tmp/checkautobackuplemp
mkdir -p /tmp/checkautobackuplemp
checkautobackup=$(cat /tmp/lemp-databaselist)
rm -rf /tmp/chitietbackupauto
randomcode=`date |md5sum |cut -c '1-12'`
for databasecheck in $checkautobackup 
do
if [ -f /bin/lemp-backupdb-$databasecheck ]; then
 if [ -f /etc/cron.d/lemp.db.cron ]; then
     if [ ! "$(grep lemp-backupdb-$databasecheck /etc/cron.d/lemp.db.cron)" == "" ]; then
     touch /tmp/checkautobackuplemp/$databasecheck
     if [ ! -f /tmp/chitietbackupauto ]; then
     touch /tmp/chitietbackupauto
     fi
	if [ "$(grep lemp /tmp/chitietbackupauto)" == "" ]; then
	echo "=========================================================================" >> /tmp/chitietbackupauto
	echo "Link Download Backup for Database Enabled Auto Backup - Created by LEMP" >> /tmp/chitietbackupauto
	echo "=========================================================================" >> /tmp/chitietbackupauto
	echo "Luu Y:" >> /tmp/chitietbackupauto
	echo "-------------------------------------------------------------------------" >> /tmp/chitietbackupauto
	echo "Cac Link Download Backup Cua Database Chi Kha Dung Khi Database Tren " >> /tmp/chitietbackupauto
	echo "-------------------------------------------------------------------------" >> /tmp/chitietbackupauto
	echo "Server Duoc Backup Thanh Cong. " >> /tmp/chitietbackupauto
	fi
filename=$(grep "$databasecheck" /bin/lemp-backupdb-$databasecheck | awk 'NR==7 {print $11}')
echo "=========================================================================" >> /tmp/chitietbackupauto
echo "Database $databasecheck:" >> /tmp/chitietbackupauto
echo "-------------------------------------------------------------------------" >> /tmp/chitietbackupauto
echo "http://$serverip:$priport/backup/$databasecheck/$filename" >> /tmp/chitietbackupauto   
     fi
 fi
fi  
done
if [  "$(ls -1 /tmp/checkautobackuplemp | wc -l)" == "0" ]; then
clear
echo "========================================================================="
echo "Hien tai khong co database nao duoc BAT che do tu dong backup"
else
rm -rf /home/$mainsite/private_html/linkAUTOBackupData*
mv /tmp/chitietbackupauto /home/$mainsite/private_html/linkAUTOBackupData-$randomcode.txt
clear
echo "========================================================================="
echo "Hien tai co $(ls -1 /tmp/checkautobackuplemp | wc -l) Database duoc BAT che do tu dong backup"
echo "-------------------------------------------------------------------------"
ls /tmp/checkautobackuplemp  | pr -2 -t
echo "========================================================================="
echo "List Link Download File Backup:"
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport/linkAUTOBackupData-$randomcode.txt"
fi
rm -rf /tmp/*lemp*
rm -rf /tmp/chitietbackupauto
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
