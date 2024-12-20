#!/bin/bash
. /home/lemp.conf
code=-`date |md5sum |cut -c '1-15'`
nhapwebsite ()
{
echo -n "Nhap ten website [ENTER]: " 
read website
website=`echo $website | tr '[A-Z]' '[a-z]'`
}
echo "========================================================================="
echo "Su dung chuc nang nay de lay link download backup cua website"
echo "-------------------------------------------------------------------------"
echo -n "Nhap ten website [ENTER]: " 
read website
website=`echo $website | tr '[A-Z]' '[a-z]'`
if [ "$website" = "" ]; then
echo "========================================================================="
echo "Ban nhap sai, vui long nhap chinh xac"
echo "-------------------------------------------------------------------------"
nhapwebsite
fi

kiemtradomain3="^([[:alnum:]]([[:alnum:]\-]{0,61}[[:alnum:]])?\.)+[[:alpha:]]{2,14}$";
if [[ ! "$website" =~ $kiemtradomain3 ]]; then
	website=`echo $website | tr '[A-Z]' '[a-z]'`
echo "========================================================================="
echo "$website co le dung dinh dang ten mien!"
echo "-------------------------------------------------------------------------"
nhapwebsite
fi

if [ ! -f /home/$website/public_html/index.php ]; then
echo "========================================================================="
echo "$website khong ton tai tren server "
echo "-------------------------------------------------------------------------"
nhapwebsite
fi


if [ -f /home/$mainsite/private_html/backup/$website/*.zip ]; then
find /home/$mainsite/private_html/backup/$website/ -name '*.zip' -type f -exec basename {} \;  > /etc/lemp/linkbackup
filename=`cat /etc/lemp/linkbackup`
echo "-------------------------------------------------------------------------"
echo "Please wait..."
sleep 1
#####################
rm -rf /home/$mainsite/private_html/ListBackup$website*
rm -rf /tmp/linkbackupall
find /home/$mainsite/private_html/backup/$website/ -type f -exec basename {} \;  > /tmp/linkbackupall
backupall=$(cat /tmp/linkbackupall)
if [ "$(cat /tmp/linkbackupall | wc -l)" -gt 1 ]; then
echo "========================================================================================================================" > /home/$mainsite/private_html/ListBackup-$website$code.txt
echo "                                Link Download Backup Files For $website - Created by LEMP"  >> /home/$mainsite/private_html/ListBackup-$website$code.txt
echo "========================================================================================================================" >> /home/$mainsite/private_html/ListBackup-$website$code.txt
echo ""  >> /home/$mainsite/private_html/ListBackup-$website$code.txt
echo "File Backup Gan Day Nhat (Backup vao $(date -r /home/$mainsite/private_html/backup/$website/$filename +%H:%M/%F)): " >> /home/$mainsite/private_html/ListBackup-$website$code.txt
echo "------------------------------------------------------------------------------------------------------------------------" >> /home/$mainsite/private_html/ListBackup-$website$code.txt
echo "http://$serverip:$priport/backup/$website/$filename" >> /home/$mainsite/private_html/ListBackup-$website$code.txt
echo "------------------------------------------------------------------------------------------------------------------------" >> /home/$mainsite/private_html/ListBackup-$website$code.txt
echo "Danh Sach Tat Cac Cac File Backup:" >> /home/$mainsite/private_html/ListBackup-$website$code.txt
echo "------------------------------------------------------------------------------------------------------------------------" >> /home/$mainsite/private_html/ListBackup-$website$code.txt
for backupfile in $backupall
do
echo "http://$serverip:$priport/backup/$website/$backupfile" >> /home/$mainsite/private_html/ListBackup-$website$code.txt
done
fi
#########################
if [ "$(cat /tmp/linkbackupall | wc -l)" -gt 1 ]; then
showinfo=`echo "File Backup Gan Day Nhat (Backup vao $(date -r /home/$mainsite/private_html/backup/$website/$filename +%H:%M/%F)):"`
else
showinfo=`echo "File Backup (Backup vao $(date -r /home/$mainsite/private_html/backup/$website/$filename +%H:%M/%F)):"`
fi
clear
echo "========================================================================="
echo "Tim thay $website tren server !"
echo "-------------------------------------------------------------------------"
echo "$showinfo"
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport/backup/$website/$filename"
if [ "$(cat /tmp/linkbackupall | wc -l)" -gt 1 ]; then
echo "-------------------------------------------------------------------------"
echo "Danh Sach Tat Cac Cac File Backup:"
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport/ListBackup-$website$code.txt"
fi
rm -rf /etc/lemp/linkbackup
rm -rf /tmp/linkbackupall
echo "" >> /home/$mainsite/private_html/ListBackup-$website$code.txt
echo "===================================================The End==============================================================" >> /home/$mainsite/private_html/ListBackup-$website$code.txt
/etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh
else
clear
echo "========================================================================="
echo "Ban chua tao backup cho $website !"
/etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh
exit
fi
