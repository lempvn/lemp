#!/bin/bash
printf "=========================================================================\n"
echo "Dung chuc nang nay de BAT hoac TAT che do tu dong sao luu cho website"
echo "-------------------------------------------------------------------------"
echo -n "Nhap ten website [ENTER]: " 
read website
website=`echo $website | tr '[A-Z]' '[a-z]'`
if [ "$website" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap lai !"
/etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh
exit
fi
kiemtradomain3="^([[:alnum:]]([[:alnum:]\-]{0,61}[[:alnum:]])?\.)+[[:alpha:]]{2,12}$";
if [[ ! "$website" =~ $kiemtradomain3 ]]; then
	website=`echo $website | tr '[A-Z]' '[a-z]'`
	clear
echo "========================================================================="
echo "$website co le khong phai la domain !!"
/etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh
exit
fi
if [ ! -f /etc/nginx/conf.d/$website.conf ]; then
clear
echo "========================================================================="
echo "Website khong ton tai tren he thong"
/etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh
exit
fi
if [ ! -f /home/$website/public_html/index.php ]; then
clear
echo "========================================================================="
echo "$website khong co du lieu. Hay chon website khac."
/etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh
exit
fi
rm -rf /tmp/websiteautobackup
echo "$website" > /tmp/websiteautobackup
if [ -f /bin/lemp-backupcode-$website ]; then
 if [ -f /etc/cron.d/lemp.code.cron ]; then
     if [ ! "$(grep lemp-backupcode-$website /etc/cron.d/lemp.code.cron)" == "" ]; then
     /etc/lemp/menu/3_backup-restore/lemp-TAT-tu-dong-sao-luu-code.sh
     fi
 fi
fi 
 /etc/lemp/menu/3_backup-restore/lemp-BAT-tu-dong-sao-luu-code.sh
