#!/bin/bash

. /home/lemp.conf
echo "========================================================================="
echo "Su dung chuc nang nay de xoa (remove) database tren server"
echo "-------------------------------------------------------------------------"
echo "Sau khi xoa database, ban khong the phuc hoi"
echo "-------------------------------------------------------------------------"
echo -n "Nhap ten database [ENTER]: " 
read dataname
dataname=`echo $dataname | tr '[A-Z]' '[a-z]'`
if [ "$dataname" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap lai!"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
exit
fi

if [ "$dataname" = "mysql" ] || [ "$dataname" = "infomation_schema" ] || [ "$dataname" = "performance_schema" ]; then
clear
echo "========================================================================="
echo "Ban crazy ? Ban muon xoa data he thong ? ?"
echo "-------------------------------------------------------------------------"
echo "Bye...!"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
exit
fi

if [ -f /var/lib/mysql/$dataname/db.opt ]; then
echo "-------------------------------------------------------------------------"
read -r -p "Da tim thay $dataname, ban chac chan muon xoa database nay ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "-------------------------------------------------------------------------"
    echo "Please wait....";sleep 1
    cat > "/tmp/config.temp" <<END
drop database $dataname;
END

mariadb -u root -p$mariadbpass < /tmp/config.temp
rm -f /tmp/config.temp

if [ -f /bin/lemp-backupdb-$dataname ]; then
echo "-------------------------------------------------------------------------"
echo "Phat hien $dataname trong danh sach tu dong sao luu"
echo "-------------------------------------------------------------------------"
echo "LEMP se remove $dataname khoi danh sach tu dong sao luu"
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
sleep 3
rm -rf /bin/lemp-backupdb-$dataname
cat > "/tmp/removebackupdb" <<END
sed --in-place '/lemp-backupdb-$dataname/d' /etc/cron.d/lemp.db.cron
END
chmod +x /tmp/removebackupdb
/tmp/removebackupdb 
rm -rf /tmp/removebackupdb
systemctl restart cron.service
fi
clear
echo "========================================================================="
echo "Xoa data $dataname thanh cong !"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
        ;;
    *)
        echo "========================================================================= "
        ;;
esac
else
clear
echo "========================================================================="
echo "Data $dataname khong ton tai tren he thong hoac trong rong"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
exit
fi

