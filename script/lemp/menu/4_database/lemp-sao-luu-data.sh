#!/bin/bash
. /home/lemp.conf
rm -rf /tmp/*vpsvn*
code=`date |md5sum |cut -c '1-12'`
ls -l /var/lib/mysql | grep "^d" | awk -F" " '{print $9}' | grep -Ev "(Database|information_schema|mysql|performance_schema|lempCheckDB)" > /tmp/listdabasevpsvn
checksize=$(du -sb /tmp/listdabasevpsvn | awk 'NR==1 {print $1}')
   if [ "$checksize" == "0" ]; then
   clear
   echo "========================================================================="
   echo "Khong tim thay database co du lieu tren server"
   /etc/lemp/menu/4_database/lemp-them-xoa-database.sh
   exit
   fi
sodatabasetrenserver=$(cat /tmp/listdabasevpsvn | wc -l)
listdatabasetrenserver=$(cat /tmp/listdabasevpsvn)
mkdir -p /tmp/saoluudatabasethanhcongvpsvn
mkdir -p /tmp/saoluudatabasethatbaivpsvn
rm -rf /tmp/*check*
for database in $listdatabasetrenserver 
do
if [ ! "$(ls -1 /var/lib/mysql/$database | wc -l)" == "1" ]; then
echo "$database" >> /tmp/checvpsbase-list
fi
 done

if [ ! -f /tmp/checvpsbase-list ]; then
rm -rf /tmp/*vpsvn*
rm -rf /tmp/*list*
clear
echo "========================================================================="
echo "Khong tim thay database co du lieu tren server"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
exit
fi
abc456=-`date |md5sum |cut -c '1-10'`
saoluudata ()
{
	echo "--------------------------------------------------------------------------"
echo "Vui long khong tat man hinh....!"
sleep 1
	if [  -f /bin/lemp-backupdb-$dataname ]; then
	if [ ! "$(grep /bin/lemp-backupdb-$dataname /etc/cron.d/lemp.db.cron)" == "" ]; then
filename2=$(grep "$dataname" /bin/lemp-backupdb-$dataname | awk 'NR==7 {print $11}')
thongbao=$(echo " ($dataname BAT Auto Backup)")
	else
filename2=$dataname$abc456.sql.gz
thongbao=$(echo "")
	fi
else
filename2=$dataname$abc456.sql.gz
thongbao=$(echo "")
fi
if [ ! -d /home/$mainsite/private_html/backup/$dataname ]; then
mkdir -p /home/$mainsite/private_html/backup/$dataname
fi
cd /home/$mainsite/private_html/backup/$dataname
rm -rf *.sql.gz
if [ "$(grep "default_storage_engine = MyISAM" /etc/mysql/mariadb.conf.d/100-lotaho.cnf | awk 'NR==1 {print $3}')" = "MyISAM" ]; then
mariadb-dump -u root -p$mariadbpass $dataname --lock-tables=false | gzip -6 > $filename2
else
mariadb-dump -u root -p$mariadbpass $dataname --single-transaction | gzip -6 > $filename2
fi

cd
clear
if [ -f /home/$mainsite/private_html/backup/$dataname/$filename2 ]; then
echo "========================================================================="
echo "Link file backup$thongbao:"
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport/backup/$dataname/$filename2"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
else
echo "========================================================================="
echo "Backup Database $dataname failed"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
fi
}
echo "========================================================================="
echo "Su dung chuc nang nay de backup database tren server"
echo "-------------------------------------------------------------------------"
echo -n "Nhap ten Database [ENTER]: " 
read dataname

if [ -f /var/lib/mysql/$dataname/db.opt ]; then
echo "-------------------------------------------------------------------------"
echo "Tim thay data $dataname tren server"
echo "-------------------------------------------------------------------------"
if [ -f /home/$mainsite/private_html/backup/$dataname/*.sql.gz ]; then
find /home/$mainsite/private_html/backup/$dataname -name '*.sql.gz' -type f -exec basename {} \;  > /tmp/backupname
filename=`cat /tmp/backupname`
rm -rf /tmp/backupname
echo "Phat hien file backup cu: $filename"
echo "--------------------------------------------------------------------------"
echo "File backup duoc tao vao: $(date -r /home/$mainsite/private_html/backup/$dataname/$filename +%H:%M/%F)"
echo "--------------------------------------------------------------------------"
read -r -p "Ban muon xoa no va tao sao luu moi ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "--------------------------------------------------------------------------"
	echo "Dang sao luu data $dataname ...."
	saoluudata
        ;;
    *)
rm -rf /tmp/lemp_ten_file_cu
if [ ! -d /home/$mainsite/private_html/backup/$dataname ]; then
mkdir -p /home/$mainsite/private_html/backup/$dataname
fi
cd /home/$mainsite/private_html/backup/$dataname
if [ -f /home/$mainsite/private_html/backup/$dataname/*.sql.gz ]; then
for file in *.sql.gz; do
time=$(date -r /home/$mainsite/private_html/backup/$dataname/$file +%H%M-%d%m%y)
    mv "$file" "`basename $file .sql.gz`.sql.gz.$time"
    echo "$file.$time" > /tmp/lemp_ten_file_cu
done
fi
cd
echo "========================================================================="
echo "LEMP se doi ten file backup cu thanh:"
echo "-------------------------------------------------------------------------"
echo "`cat /tmp/lemp_ten_file_cu`"
echo "-------------------------------------------------------------------------"
echo "Sau de se tien hanh sao luu $dataname"
echo "-------------------------------------------------------------------------"
echo "Vui long khong tat man hinh ssh nay ..."
sleep 6
	if [  -f /bin/lemp-backupdb-$dataname ]; then
	if [ ! "$(grep /bin/lemp-backupdb-$dataname /etc/cron.d/lemp.db.cron)" == "" ]; then
filename2=$(grep "$dataname" /bin/lemp-backupdb-$dataname | awk 'NR==7 {print $11}')
thongbao=$(echo " ($dataname Enabled Auto Backup)")
	else
filename2=$dataname$abc456.sql.gz
thongbao=$(echo "")
	fi
else
filename2=$dataname$abc456.sql.gz
thongbao=$(echo "")
fi
sleep 1
if [ ! -d /home/$mainsite/private_html/backup/$dataname ]; then
mkdir -p /home/$mainsite/private_html/backup/$dataname
fi
cd /home/$mainsite/private_html/backup/$dataname


if [ "$(grep "default_storage_engine = MyISAM" /etc/mysql/mariadb.conf.d/100-lotaho.cnf | awk 'NR==1 {print $3}')" = "MyISAM" ]; then
mariadb-dump -u root -p$mariadbpass $dataname --lock-tables=false | gzip -6 > $filename2
else
mariadb-dump -u root -p$mariadbpass $dataname --single-transaction | gzip -6 > $filename2
fi

cd
clear
if [ -f /home/$mainsite/private_html/backup/$dataname/$filename2 ]; then
echo "========================================================================="
echo "Link Backup File:"
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport/backup/$dataname/$filename2"
echo "-------------------------------------------------------------------------"
echo "File Backup Cu Duoc Doi Ten Thanh:"
echo "-------------------------------------------------------------------------"
echo "$(cat /tmp/lemp_ten_file_cu)"
rm -rf /tmp/*lemp*
else
echo "========================================================================="
echo "Backup Database $dataname failed"
fi
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
        ;;
esac
else
	echo "Dang sao luu data $dataname ..."
	saoluudata
fi

else
clear
echo "========================================================================="
echo "Khong tim thay $dataname tren server, vui long check lai!"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
exit
fi
