#!/bin/bash
. /home/lemp.conf
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
sleep 1
rm -rf /tmp/lemp-websitelist
ls /etc/nginx/conf.d > /tmp/lemp-websitelist
sed -i 's/\.conf//g' /tmp/lemp-websitelist 
rm -rf /tmp/checkautobackuplemp
mkdir -p /tmp/checkautobackuplemp
checkautobackup=$(cat /tmp/lemp-websitelist)
rm -rf /tmp/chitietbackupauto
randomcode=`date |md5sum |cut -c '1-12'`
for websitecheck in $checkautobackup 
do
if [ -f /bin/lemp-backupcode-$websitecheck ]; then
 if [ -f /etc/cron.d/lemp.code.cron ]; then
     if [ ! "$(grep lemp-backupcode-$websitecheck /etc/cron.d/lemp.code.cron)" == "" ]; then
     touch /tmp/checkautobackuplemp/$websitecheck
     if [ ! -f /tmp/chitietbackupauto ]; then
     touch /tmp/chitietbackupauto
     fi
	if [ "$(grep LEMP /tmp/chitietbackupauto)" == "" ]; then
	echo "=========================================================================" >> /tmp/chitietbackupauto
	echo "Link Download Backup Cho Website - Created by LEMP" >> /tmp/chitietbackupauto
	echo "=========================================================================" >> /tmp/chitietbackupauto
	echo "Luu Y:" >> /tmp/chitietbackupauto
	echo "-------------------------------------------------------------------------" >> /tmp/chitietbackupauto
	echo "Cac Link Download Backup Cua Website Chi Kha Dung Khi Website Tren Server" >> /tmp/chitietbackupauto
	echo "-------------------------------------------------------------------------" >> /tmp/chitietbackupauto
	echo "Duoc Backup Thanh Cong. " >> /tmp/chitietbackupauto
	fi
pathname=$(grep "\/home\/$mainsite\/private_html\/backup\/$websitecheck" /bin/lemp-backupcode-$websitecheck | awk 'NR==6 {print $3}')
filename=$(basename $pathname)
echo "=========================================================================" >> /tmp/chitietbackupauto
echo "Website $websitecheck:" >> /tmp/chitietbackupauto
echo "-------------------------------------------------------------------------" >> /tmp/chitietbackupauto
echo "http://$serverip:$priport/backup/$websitecheck/$filename" >> /tmp/chitietbackupauto
echo "-------------------------------------------------------------------------" >> /tmp/chitietbackupauto
echo "" >> /tmp/chitietbackupauto    
     fi
 fi
fi  
done
if [  "$(ls -1 /tmp/checkautobackuplemp | wc -l)" == "0" ]; then
clear
echo "========================================================================="
echo "Hien tai khong co website nao duoc BAT tu dong backup"
else
rm -rf /home/$mainsite/private_html/linkAUTOBackupWeb*
mv /tmp/chitietbackupauto /home/$mainsite/private_html/linkAUTOBackupWeb-$randomcode.txt
clear
echo "========================================================================="
echo "Hien tai co $(ls -1 /tmp/checkautobackuplemp | wc -l) website dang bat Auto Backup code"
echo "-------------------------------------------------------------------------"
ls /tmp/checkautobackuplemp  | pr -2 -t
echo "========================================================================="
echo "List Link Download File Backup:"
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport/linkAUTOBackupWeb-$randomcode.txt"
fi
rm -rf /tmp/*lemp*
/etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh
