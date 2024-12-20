#!/bin/sh
. /home/lemp.conf


echo "Chuan bi phuc hoi Database..."
sleep 1
find /home/$mainsite/private_html/backup/AllDB/ -type f -exec basename {} \;  > /tmp/backupname
filename=`cat /tmp/backupname`
rm -rf /tmp/backupname
cd /home/$mainsite/private_html/backup/AllDB
gunzip < $filename | mysql -u root -p$mariadbpass
cd
listdata=`date |md5sum |cut -c '1-4'`
cd /var/lib/mysql
echo "=========================================================================" > /home/$mainsite/private_html/listdata/$listdata-listdata.txt
echo "                             LIST DATABASE "                         >>/home/$mainsite/private_html/listdata/$listdata-listdata.txt
echo "=========================================================================" >> /home/$mainsite/private_html/listdata/$listdata-listdata.txt
tree -d -i -L 1 >> /home/$mainsite/private_html/listdata/$listdata-listdata.txt
sed -i 's/directories/database tren VPS (mysql va performance_schema la database mac dinh.)/g' /home/$mainsite/private_html/listdata/$listdata-listdata.txt
echo "=========================================================================" >> /home/$mainsite/private_html/listdata/$listdata-listdata.txt
cd

clear
echo "========================================================================="
echo "Phuc hoi tat ca database tren VPS da hoan thanh !"
echo "-------------------------------------------------------------------------"
echo "Danh sach cac database tren VPS:"
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport/listdata/$listdata-listdata.txt"
/etc/lemp/menu/lemp-sao-luu-phuc-hoi-tat-ca-database-menu.sh
