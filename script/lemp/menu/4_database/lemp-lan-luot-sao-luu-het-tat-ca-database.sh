#!/bin/bash
. /home/lemp.conf
rm -rf /tmp/*vpsvn*
code=`date |md5sum |cut -c '1-19'`
echo "$(mariadb --user=root --password=$mariadbpass -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|mysql|performance_schema)")" > /tmp/listdabasevpsvn
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
 
sodatabase=$(cat /tmp/checvpsbase-list | wc -l)
saoluudata ()
{
randomcode=-`date |md5sum |cut -c '1-11'`
if [ -f /bin/lemp-backupdb-$dataname ]; then
if [ ! "$(grep lemp-backupdb-$dataname /etc/cron.d/lemp.db.cron)" == "" ]; then
filename=$(grep "$dataname" /bin/lemp-backupdb-$dataname | awk 'NR==7 {print $11}')
####
if [ ! -d /home/$mainsite/private_html/backup/$dataname ]; then
mkdir -p /home/$mainsite/private_html/backup/$dataname
fi
cd /home/$mainsite/private_html/backup/$dataname
if [ -f /home/$mainsite/private_html/backup/$dataname/*.sql.gz ]; then
for file in *.sql.gz; do
time=$(date -r /home/$mainsite/private_html/backup/$dataname/$file +%H%M-%d%m%y)
    mv "$file" "`basename $file .sql.gz`.sql.gz.$time"
    echo "$file.$time" > /tmp/lemp_ten_file_cu_data
done
fi
if [ "$(grep "default_storage_engine = MyISAM" /etc/mysql/mariadb.conf.d/100-lotaho.cnf | awk 'NR==1 {print $3}')" = "MyISAM" ]; then
mariadb-dump -u root -p$mariadbpass $dataname --lock-tables=false | gzip -6 > $filename
else
mariadb-dump -u root -p$mariadbpass $dataname --single-transaction | gzip -6 > $filename
fi


cd
if [ -f /home/$mainsite/private_html/backup/$dataname/$filename ]; then
echo "========================================================================="
echo "Sao Luu Database $dataname  (Dang duoc BAT Auto Backup) :"
sleep 1
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport/backup/$dataname/$filename"
if [ -f /tmp/lemp_ten_file_cu_data ]; then
echo "-------------------------------------------------------------------------"
echo "File backup cu duoc doi ten thanh:"
echo "-------------------------------------------------------------------------"
echo "`cat /tmp/lemp_ten_file_cu_data`"
rm -rf /tmp/lemp_ten_file_cu_data
fi
sleep 3
echo "========================================================================================================================" >> /home/$mainsite/private_html/Listbackupall-DB-$code.txt
echo "Database $dataname (Dang duoc BAT Auto Backup) :" >> /home/$mainsite/private_html/Listbackupall-DB-$code.txt 
echo "------------------------------------------------------------------------------------------------------------------------" >> /home/$mainsite/private_html/Listbackupall-DB-$code.txt
echo "http://$serverip:$priport/backup/$dataname/$filename" >> /home/$mainsite/private_html/Listbackupall-DB-$code.txt
touch /tmp/saoluudatabasethanhcongvpsvn/$dataname
else
echo "=========================================================================" 
echo "Sao luu Database $dataname that bai !"
echo "========================================================================================================================" >> /home/$mainsite/private_html/Listbackupall-DB-$code.txt
echo "Sao luu Database $dataname that bai !" >> /home/$mainsite/private_html/Listbackupall-DB-$code.txt
touch /tmp/saoluudatabasethatbaivpsvn/$dataname
fi
fi
fi

if [ ! -f /bin/lemp-backupdb-$dataname ]; then
####
if [ ! -d /home/$mainsite/private_html/backup/$dataname ]; then
mkdir -p /home/$mainsite/private_html/backup/$dataname
fi
cd /home/$mainsite/private_html/backup/$dataname
if [ -f /home/$mainsite/private_html/backup/$dataname/*.sql.gz ]; then
for file in *.sql.gz; do
time=$(date -r /home/$mainsite/private_html/backup/$dataname/$file +%H%M-%d%m%y)
    mv "$file" "`basename $file .sql.gz`.sql.gz.$time"
    echo "$file.$time" > /tmp/lemp_ten_file_cu_data
done
fi
if [ "$(grep "default_storage_engine = MyISAM" /etc/mysql/mariadb.conf.d/100-lotaho.cnf | awk 'NR==1 {print $3}')" = "MyISAM" ]; then
mariadb-dump -u root -p$mariadbpass $dataname --lock-tables=false | gzip -6 > $dataname$randomcode.sql.gz
else
mariadb-dump -u root -p$mariadbpass $dataname --single-transaction | gzip -6 > $dataname$randomcode.sql.gz
fi

cd
if [ -f /home/$mainsite/private_html/backup/$dataname/$dataname$randomcode.sql.gz ]; then
echo "========================================================================="
echo "Sao Luu Database $dataname :"
sleep 3
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport/backup/$dataname/$dataname$randomcode.sql.gz"
if [ -f /tmp/lemp_ten_file_cu_data ]; then
echo "-------------------------------------------------------------------------"
echo "File backup cu duoc doi ten thanh:"
echo "-------------------------------------------------------------------------"
echo "`cat /tmp/lemp_ten_file_cu_data`"
rm -rf /tmp/lemp_ten_file_cu_data
fi
sleep 3
echo "========================================================================================================================" >> /home/$mainsite/private_html/Listbackupall-DB-$code.txt
echo "Database $dataname :" >> /home/$mainsite/private_html/Listbackupall-DB-$code.txt 
echo "------------------------------------------------------------------------------------------------------------------------" >> /home/$mainsite/private_html/Listbackupall-DB-$code.txt
echo "http://$serverip:$priport/backup/$dataname/$dataname$randomcode.sql.gz" >> /home/$mainsite/private_html/Listbackupall-DB-$code.txt
touch /tmp/saoluudatabasethanhcongvpsvn/$dataname
else
echo "=========================================================================" 
echo "Sao luu Database $dataname that bai !"
echo "========================================================================================================================" >> /home/$mainsite/private_html/Listbackupall-DB-$code.txt
echo "Sao luu Database $dataname that bai !" >> /home/$mainsite/private_html/Listbackupall-DB-$code.txt
touch /tmp/saoluudatabasethatbaivpsvn/$dataname
fi
fi
}

echo "========================================================================="
echo "Su dung chuc nang nay de backup tat ca database tren server"
echo "-------------------------------------------------------------------------"
echo "LEMP se lan luot backup tung database mot tren server cho den het."
echo "-------------------------------------------------------------------------"
echo "Tuy thuoc vao so luong database va dung luong tung database ma thoi gian"
echo "-------------------------------------------------------------------------"
echo "hoan thanh sao luu tat ca database co the nhanh hay cham."
echo "=========================================================================" 
read -r -p "Ban muon LEMP lan luot sao luu tat ca database ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
echo "========================================================================="
echo "Tong Database tren server: $sodatabasetrenserver | Database co du lieu: $sodatabase"
echo "-------------------------------------------------------------------------"
echo "LEMP se sao luu $sodatabase database co du lieu tren server"
echo "========================================================================="
echo "PLEASE DO NOT TURNOFF THIS CREEEN !"
echo "========================================================================="
sleep 2
rm -rf /home/$mainsite/private_html/Listbackupall*
echo "========================================================================================================================" > /home/$mainsite/private_html/Listbackupall-DB-$code.txt
echo "                                  Link Download Backup All Database - Created by lemp" >> /home/$mainsite/private_html/Listbackupall-DB-$code.txt
echo "========================================================================================================================" >> /home/$mainsite/private_html/Listbackupall-DB-$code.txt
echo "" >> /home/$mainsite/private_html/Listbackupall-DB-$code.txt
echo "" >> /home/$mainsite/private_html/Listbackupall-DB-$code.txt
echo "" >> /home/$mainsite/private_html/Listbackupall-DB-$code.txt
listdatabases=$(cat /tmp/checvpsbase-list)
for dataname in $listdatabases 
do
saoluudata
done
clear
echo "========================================================================="
echo "Co $sodatabase Database co du lieu tren server"
echo "-------------------------------------------------------------------------"
if [ "$(ls -1 /tmp/saoluudatabasethanhcongvpsvn | wc -l)" == "$sodatabase" ]; then
echo "Backup tat ca database thanh cong"
else
echo "Backup that bai $(ls -1 /tmp/saoluudatabasethatbaivpsvn | wc -l) database"
echo "-------------------------------------------------------------------------"
echo "Database sao luu that bai:"
echo "-------------------------------------------------------------------------"
ls /tmp/saoluudatabasethatbaivpsvn
fi
if [ ! "$(ls -1 /tmp/saoluudatabasethatbaivpsvn | wc -l)" == "$sodatabase" ]; then
echo "-------------------------------------------------------------------------"
echo "List Backup Files:"
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport/Listbackupall-DB-$code.txt"
fi
rm -rf /tmp/*vpsvn*
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
   ;;
    *)
    clear
    rm -rf /tmp/*vpsvn*
        echo "========================================================================= "
        echo "Huy bo lan luot sao luu tat ca database"
        /etc/lemp/menu/4_database/lemp-them-xoa-database.sh
        ;;
esac

