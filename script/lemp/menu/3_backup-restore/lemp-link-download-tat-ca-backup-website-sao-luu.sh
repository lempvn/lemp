#!/bin/bash
. /home/lemp.conf
rm -rf /tmp/*vpsvn*
mkdir -p /tmp/danhsachwebsitebackupvpsvn
ls /etc/nginx/conf.d > /tmp/lemp-websitelist
sed -i 's/\.conf//g' /tmp/lemp-websitelist
 cat > "/tmp/lemp-replace" <<END
sed -i '/$mainsite/d' /tmp/lemp-websitelist
END
chmod +x /tmp/lemp-replace
/tmp/lemp-replace
rm -rf /tmp/lemp-replace
rm -rf /tmp/checksite-list
acction1="/tmp/lemp-websitelist"
while read -r checksite
    do
if [ -f /home/$mainsite/private_html/backup/$checksite/*.zip ]; then
echo "$checksite" >> /tmp/checksite-list
fi
 done < "$acction1"
if [ ! -f /tmp/checksite-list ]; then
clear
echo "========================================================================="
echo "lemp khong tim thay cac ban backup tren server"
/etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh
fi
sowebsitecobackup=$(cat /tmp/checksite-list | wc -l)
code=-`date |md5sum |cut -c '1-15'`
listwebsitebackup=$(cat /tmp/checksite-list)

getlink ()
{
find /home/$mainsite/private_html/backup/$website/ -name '*.zip' -type f -exec basename {} \;  > /tmp/linkbackup
filename=`cat /tmp/linkbackup`
find /home/$mainsite/private_html/backup/$website/ -type f -exec basename {} \;  > /tmp/linkbackupall
backupall=$(cat /tmp/linkbackupall)
if [ "$(cat /tmp/linkbackupall | wc -l)" -gt 1 ]; then
showinfo=`echo "File backup gan nhat (Thoi gian backup $(date -r /home/$mainsite/private_html/backup/$website/$filename +%H:%M/%F)):"`
else
showinfo=`echo "File backup (Thoi gian backup $(date -r /home/$mainsite/private_html/backup/$website/$filename +%H:%M/%F)): "`
fi
echo "========================================================================="
echo "Link Download Backup Cua $website: "
echo "-------------------------------------------------------------------------"
sleep 2
echo "http://$serverip:$priport/backup/$website/$filename"
echo "" >> /home/$mainsite/private_html/listbackup-AW$code.txt
echo "========================================================================================================================" >> /home/$mainsite/private_html/listbackup-AW$code.txt
echo "Link Download Backup Cua $website: " >> /home/$mainsite/private_html/listbackup-AW$code.txt

echo "------------------------------------------------------------------------------------------------------------------------" >> /home/$mainsite/private_html/listbackup-AW$code.txt
echo "$showinfo" >> /home/$mainsite/private_html/listbackup-AW$code.txt
echo "------------------------------------------------------------------------------------------------------------------------" >> /home/$mainsite/private_html//listbackup-AW$code.txt
echo "http://$serverip:$priport/backup/$website/$filename" >> /home/$mainsite/private_html/listbackup-AW$code.txt
#####################
if [ "$(cat /tmp/linkbackupall | wc -l)" -gt 1 ]; then
echo "------------------------------------------------------------------------------------------------------------------------"  >> /home/$mainsite/private_html/listbackup-AW$code.txt
echo "Tat Ca Cac File Back Up :" >> /home/$mainsite/private_html/listbackup-AW$code.txt
echo "------------------------------------------------------------------------------------------------------------------------" >> /home/$mainsite/private_html/listbackup-AW$code.txt
for backupfile in $backupall
do
echo "http://$serverip:$priport/backup/$website/$backupfile" >> /home/$mainsite/private_html/listbackup-AW$code.txt
done
fi
#########################
rm -rf /tmp/linkbackupall
rm -rf /tmp/linkbackup
touch /tmp/danhsachwebsitebackupvpsvn/$website
}

echo "========================================================================="
echo "Su dung chuc nang nay de lay link download cac file backup website"
echo "=========================================================================" 
read -r -p "Ban muon lay cac link download ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
echo "========================================================================="
rm -rf /home/$mainsite/private_html/listbackup*
echo "========================================================================================================================" > /home/$mainsite/private_html/listbackup-AW$code.txt
echo "         Link Download All Backup Files - Created by LEMP" >> /home/$mainsite/private_html/listbackup-AW$code.txt
echo "========================================================================================================================" >> /home/$mainsite/private_html/listbackup-AW$code.txt
echo "" >> /home/$mainsite/private_html/listbackup-AW$code.txt

for website in $listwebsitebackup 
do
getlink
done
clear
echo "========================================================================="
echo "Danh Sach Cac Website Co Backup:"
echo "-------------------------------------------------------------------------"
ls /tmp/danhsachwebsitebackupvpsvn | pr -2 -t
echo "-------------------------------------------------------------------------"
echo "Link download Tat Ca Cac File Backup:"
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport/listbackup-AW$code.txt"
echo "" >> /home/$mainsite/private_html/listbackup-AW$code.txt
echo "===================================================The End==============================================================" >> /home/$mainsite/private_html/listbackup-AW$code.txt
rm -rf /tmp/*vpsvn*
/etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh
   ;;
    *)
    clear
        echo "========================================================================= "
        echo "Huy bo lay link download cac file backup"
        /etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh
        rm -rf /tmp/*vpsvn*
        ;;
esac

