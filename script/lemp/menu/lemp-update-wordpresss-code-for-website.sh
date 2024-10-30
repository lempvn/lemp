#!/bin/bash
. /home/lemp.conf

PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")

echo "========================================================================="
echo "Nhap ten website ban muon update wordpress code"
echo "-------------------------------------------------------------------------"
echo -n "Nhap ten website: " 
read website
if [ "$website" = "" ]; then
clear
echo "========================================================================="
echo "You typed wrong, please type in accurately! "
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
kiemtradomain3="^([[:alnum:]]([[:alnum:]\-]{0,61}[[:alnum:]])?\.)+[[:alpha:]]{2,14}";
if [[ ! "$website" =~ $kiemtradomain3 ]]; then
	website=`echo $website | tr '[A-Z]' '[a-z]'`
clear
echo "========================================================================="
echo "$website co le khong phai ten domain !"
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai !"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
if [ ! -f /etc/nginx/conf.d/$website.conf ]; then
clear
echo "========================================================================="
echo "Khong tim thay $website tren he thong"
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai !"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi

if [ ! -f /home/$website/public_html/wp-config.php ]; then
clear
echo "========================================================================="
echo "$website co the khong phai wordpress web hoac chua cai dat WP"
echo "-------------------------------------------------------------------------"
echo "Vui long cai dat Wordpress code truoc hoac thu domain khac"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
echo "-------------------------------------------------------------------------"
echo "Tim thay $website dang su dung wordpress code tren he thong"
echo "-------------------------------------------------------------------------"
echo "LEMP dang kiem tra Wordpress version"
echo "-------------------------------------------------------------------------"
sleep 3
date |md5sum |cut -c '1-8' > /tmp/abcd
random=$(cat /tmp/abcd)
tendatabase=`cat /home/$website/public_html/wp-config.php | grep DB_NAME | cut -d \' -f 4`
echo "`date '+%d%m'`" > /tmp/datetime
tenmo=$(cat /tmp/datetime)
chown -R www-data:www-data /home/$website/public_html
cd /home/$website/public_html/
lempcheckversion=$(wp core check-update --allow-root | tail -n1 | awk 'NR==1 {print $1}')
if [ "$lempcheckversion" == "Success:" ]; then
clear
cd
echo "========================================================================="
echo "Website $website dang su dung phien ban wordpress moi nhat"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
else
if [ ! -d /home/$website/public_html/0-lemp ]; then
mkdir -p /home/$website/public_html/0-lemp
fi
clear
echo "========================================================================="
echo "Phien ban wordpress hien tai cua $website: $(wp core version --allow-root)"
echo "-------------------------------------------------------------------------"
echo "Phien ban wordpress moi nhat: $lempcheckversion"
echo "-------------------------------------------------------------------------"
echo "LEMP se update wordpress code cua $website len $lempcheckversion"
echo "-------------------------------------------------------------------------"
echo "Truoc khi update, lemp se sao luu database"
echo "-------------------------------------------------------------------------"
echo "Link file backup database: "
echo "-------------------------------------------------------------------------"
echo "http://$website/0-lemp/$tendatabase-$random-$tenmo.sql.gz"
echo "-------------------------------------------------------------------------"
read -p "Nhan [Enter] de tiep tuc ..."
if [ "$(grep "default_storage_engine = MyISAM" /etc/mysql/mariadb.conf.d/100-lotaho.cnf | awk 'NR==1 {print $3}')" = "MyISAM" ]; then
mariadb-dump -u root -p$mariadbpass $tendatabase --lock-tables=false | gzip -9 > /home/$website/public_html/0-lemp/$tendatabase-$random-$tenmo.sql.gz
else
mariadb-dump -u root -p$mariadbpass $tendatabase --single-transaction | gzip -9 > /home/$website/public_html/0-lemp/$tendatabase-$random-$tenmo.sql.gz
fi
#/etc/lemp/menu/lemp-enable-tat-ca-cac-ham-php-php.ini
wp core update --allow-root
wp core update-db --allow-root
#/etc/lemp/menu/lemp-re-config-cac-ham-php-disable-php.ini
cd
chown -R www-data:www-data /home/$website/public_html

systemctl restart php${PHP_VERSION}-fpm.service

cd /home/$website/public_html
lempcheckversion=$(wp core check-update --allow-root | tail -n1 | awk 'NR==1 {print $1}')
clear
echo "========================================================================="
if [ "$lempcheckversion" == "Success:" ]; then
echo "Update Wordpress code cua $website thanh cong"
else
echo "Update wordpress code that bai"
fi
cd
if [ -f /home/$website/public_html/0-lemp/$tendatabase-$random-$tenmo.sql.gz ]; then
echo "-------------------------------------------------------------------------"
echo "Backup database $tendatabase thanh cong"
echo "-------------------------------------------------------------------------"
echo "Link file backup database:"
echo "-------------------------------------------------------------------------"
echo "http://$website/0-lemp/$tendatabase-$random-$tenmo.sql.gz"
else
echo "-------------------------------------------------------------------------"
echo "Backup database that bai"
fi
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
fi
