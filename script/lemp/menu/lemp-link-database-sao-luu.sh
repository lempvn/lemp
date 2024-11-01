#!/bin/bash
. /home/lemp.conf
code=-`date |md5sum |cut -c '1-15'`
echo "========================================================================="
echo "Su dung chuc nang nay de lay link file backup cua database"
echo "-------------------------------------------------------------------------"
echo -n "Nhap ten database [ENTER]: " 
read databasename
if [ "$databasename" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap lai !"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
exit
fi
if [ ! -f /var/lib/mysql/$databasename/db.opt ]; then
clear
echo "========================================================================="
echo "Database $databasename khong ton tai tren he thong !"
echo "-------------------------------------------------------------------------"
echo "Ban hay kiem tra lai !"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
exit
fi

if [ ! -f  /home/$mainsite/private_html/backup/$databasename/*.sql.gz ]; then
clear
echo "========================================================================="
echo "$databasename chua duoc backup tren server !"
echo "-------------------------------------------------------------------------"
echo "Ban hay kiem tra lai !"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
else
find /home/$mainsite/private_html/backup/$databasename/ -name '*.sql.gz' -type f -exec basename {} \;  > /tmp/linvpsbasename
filename=`cat /tmp/linvpsbasename`
echo "-------------------------------------------------------------------------"
echo "Please wait..."
sleep 1
########################
#####################
rm -rf /home/$mainsite/private_html/ListBackup$databasename*
rm -rf /tmp/linkbackupall
find /home/$mainsite/private_html/backup/$databasename/ -type f -exec basename {} \;  > /tmp/linkbackupall
backupall=$(cat /tmp/linkbackupall)
if [ "$(cat /tmp/linkbackupall | wc -l)" -gt 1 ]; then
echo "========================================================================================================================" > /home/$mainsite/private_html/ListBackup-$databasename$code.txt
echo "                            Link Download Backup Files For $databasename - Created by LEMP"  >> /home/$mainsite/private_html/ListBackup-$databasename$code.txt
echo "========================================================================================================================" >> /home/$mainsite/private_html/ListBackup-$databasename$code.txt
echo ""  >> /home/$mainsite/private_html/ListBackup-$databasename$code.txt
echo "------------------------------------------------------------------------------------------------------------------------" >> /home/$mainsite/private_html/Listbackupall-DB-$code.txt
echo "File backup gan nhat (Backup vao $(date -r /home/$mainsite/private_html/backup/$databasename/$filename +%H:%M/%F)):" >> /home/$mainsite/private_html/ListBackup-$databasename$code.txt
echo "------------------------------------------------------------------------------------------------------------------------" >> /home/$mainsite/private_html/ListBackup-$databasename$code.txt
echo "http://$serverip:$priport/backup/$databasename/$filename" >> /home/$mainsite/private_html/ListBackup-$databasename$code.txt
echo "------------------------------------------------------------------------------------------------------------------------" >> /home/$mainsite/private_html/ListBackup-$databasename$code.txt
echo "Tat ca file backup:" >> /home/$mainsite/private_html/ListBackup-$databasename$code.txt
echo "------------------------------------------------------------------------------------------------------------------------" >> /home/$mainsite/private_html/ListBackup-$databasename$code.txt
for backupfile in $backupall
do
echo "http://$serverip:$priport/backup/$databasename/$backupfile" >> /home/$mainsite/private_html/ListBackup-$databasename$code.txt
done
fi
#########################
if [ "$(cat /tmp/linkbackupall | wc -l)" -gt 1 ]; then
showinfo=`echo "File Backup Gan Day Nhat (Backup vao $(date -r /home/$mainsite/private_html/backup/$databasename/$filename +%H:%M/%F)):"`
else
showinfo=`echo "File Backup (Backup vao $(date -r /home/$mainsite/private_html/backup/$databasename/$filename +%H:%M/%F)):"`
fi
clear
echo "========================================================================="
echo "Tim thay backup $databasename tren server"
echo "-------------------------------------------------------------------------"
echo "$showinfo"
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport/backup/$databasename/$filename"
if [ "$(cat /tmp/linkbackupall | wc -l)" -gt 1 ]; then
echo "-------------------------------------------------------------------------"
echo "Danh Sach Tat Cac Cac File Backup:"
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport/ListBackup-$databasename$code.txt"
fi
rm -rf /tmp/linkbackupall
rm -rf /tmp/linvpsbasename
echo "" >> /home/$mainsite/private_html/ListBackup-$databasename$code.txt
echo "===================================================The End==============================================================" >> /home/$mainsite/private_html/ListBackup-$databasename$code.txt

/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
exit
fi
