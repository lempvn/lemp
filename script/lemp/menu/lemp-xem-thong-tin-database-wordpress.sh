#!/bin/bash
. /home/lemp.conf
echo "========================================================================="
echo "Su dung chuc nang nay xem thong tin database cua Wordpress website"
echo "-------------------------------------------------------------------------" 
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

echo "-------------------------------------------------------------------------"
echo "Tim thay $website trong he thong"
echo "-------------------------------------------------------------------------"
echo "$website su dung wordpress code"
echo "-------------------------------------------------------------------------"
echo "LEMP chuan bi lay thong tin database"
echo "-------------------------------------------------------------------------"
echo "Please wait .... "
echo "-------------------------------------------------------------------------"
sleep 3

databasename=`cat /home/$website/public_html/wp-config.php | grep DB_NAME | cut -d \' -f 4`
databaseuser=`cat /home/$website/public_html/wp-config.php | grep DB_USER | cut -d \' -f 4`
databasepass=`cat /home/$website/public_html/wp-config.php | grep DB_PASSWORD | cut -d \' -f 4`
clear
echo "========================================================================="
echo "Thong tin database cua $website"
echo "-------------------------------------------------------------------------"
echo "Database name: $databasename"
echo "-------------------------------------------------------------------------"
echo "Username: $databaseuser"
echo "-------------------------------------------------------------------------"
echo "Password: $databasepass"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh

