#!/bin/bash
. /home/lemp.conf

if [ ! -f /home/$mainsite/private_html/backup/AllDB/*.sql.gz ]; then
clear
echo "========================================================================="
echo "Ban chua thuc hien sao luu tat ca database !"
echo "-------------------------------------------------------------------------"
echo "Ban hay kiem tra lai !"
/etc/lemp/menu/lemp-sao-luu-phuc-hoi-tat-ca-database-menu.sh
exit
fi
find /home/$mainsite/private_html/backup/AllDB/ -type f -exec basename {} \;  > /tmp/backupname
filename=`cat /tmp/backupname`
rm -rf /tmp/backupname
echo "Please wait..."
sleep 1
clear
echo "========================================================================="
echo "Tim thay backup tat ca database tren server"
echo "-------------------------------------------------------------------------"
echo "Link download backup: "
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport/backup/AllDB/$filename"
/etc/lemp/menu/lemp-sao-luu-phuc-hoi-tat-ca-database-menu.sh
exit
fi
