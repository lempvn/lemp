#!/bin/bash
. /home/lemp.conf
if [ -f /home/$mainsite/private_html/backup/home/*.zip ]; then
find /home/$mainsite/private_html/backup/$website/ -name '*.zip' -type f -exec basename {} \;  > /etc/lemp/linkbackup
filename=`cat /etc/lemp/linkbackup`
echo "-------------------------------------------------------------------------"
echo "Please wait..."
sleep 1
clear
echo "========================================================================="
echo "Tim thay file backup cua thu muc Home"
echo "-------------------------------------------------------------------------"
echo "Link download backup: "
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport/backup/home/$filename"
/etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh
rm -rf /etc/lemp/linkbackup
else
clear
echo "========================================================================="
echo "Ban chua tao file backup code folder Home !"
/etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh
exit
fi
