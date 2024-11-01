#!/bin/bash
. /home/lemp.conf
echo "========================================================================="
echo "Su dung chuc nang nay de sao luu database theo dinh dang .sql.gz "
echo "========================================================================="
echo -n "Nhap ten website: " 
read website
if [ "$website" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap lai "
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
kiemtradomain3="^([[:alnum:]]([[:alnum:]\-]{0,61}[[:alnum:]])?\.)+[[:alpha:]]{2,14}$";
if [[ ! "$website" =~ $kiemtradomain3 ]]; then
	website=`echo $website | tr '[A-Z]' '[a-z]'`
clear
echo "========================================================================="
echo "$website Co the khong dung dinh dang domain!"
echo "-------------------------------------------------------------------------"
echo "Ban hay lam lai !"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
if [ ! -f /etc/nginx/conf.d/$website.conf ]; then
clear
echo "========================================================================="
echo "$website khong ton tai tren he thong!"
echo "-------------------------------------------------------------------------"
echo "Ban hay lam lai"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
if [ -f /home/$website/public_html/wp-config-sample.php ]; then
if [ ! -f /home/$website/public_html/wp-config.php ]; then
clear
echo "========================================================================="
echo "$website co code wordpress nhung chua cai dat !"
echo "-------------------------------------------------------------------------"
echo "Hay cai dat wordpress va thu lai !"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
fi
if [ ! -f /home/$website/public_html/wp-config.php ]; then
clear
echo "========================================================================="
echo "$website khong phai wordpress blog !"
echo "-------------------------------------------------------------------------"
echo "Ban hay lam lai."
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
tendatabase=`cat /home/$website/public_html/wp-config.php | grep DB_NAME | cut -d \' -f 4`
echo "-------------------------------------------------------------------------"
echo "Tim thay $website tren he thong"
echo "-------------------------------------------------------------------------"
echo "$website su dung wordpress code"
echo "-------------------------------------------------------------------------"
echo "Database $website su dung: $tendatabase"
echo "-------------------------------------------------------------------------"
echo "Chuan bi sao luu .... "
echo "-------------------------------------------------------------------------"
sleep 2
randomwp=`date |md5sum |cut -c '1-7'`
echo "`date '+%d%m%H'`" > /tmp/datetime
if [ ! -d /home/$website/public_html/0-lemp ]; then
mkdir -p /home/$website/public_html/0-lemp
fi
cd /home/$website/public_html/0-lemp
if [ "$(grep "default_storage_engine = MyISAM" /etc/mysql/mariadb.conf.d/100-lotaho.cnf | awk 'NR==1 {print $3}')" = "MyISAM" ]; then
mariadb-dump -u root -p$mariadbpass $tendatabase --lock-tables=false | gzip -6 > $tendatabase-$randomwp-$(cat /tmp/datetime).sql.gz
else
mariadb-dump -u root -p$mariadbpass $tendatabase --single-transaction | gzip -6 > $tendatabase-$randomwp-$(cat /tmp/datetime).sql.gz
fi

cd
clear
if [ -f /home/$website/public_html/0-lemp/$tendatabase-$randomwp-$(cat /tmp/datetime).sql.gz ]; then
echo "========================================================================="
echo "Sao luu database $tendatabase thanh cong !"
echo "-------------------------------------------------------------------------"
echo "Link download backup:"
echo "-------------------------------------------------------------------------"
echo "http://$website/0-lemp/$tendatabase-$randomwp-$(cat /tmp/datetime).sql.gz"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
else
echo "=========================================================================" 
echo "Sao luu database that bai"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
fi
