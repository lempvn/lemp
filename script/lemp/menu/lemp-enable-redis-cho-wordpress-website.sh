#!/bin/bash 
. /home/lemp.conf

PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")

if [ ! "$(redis-cli ping)" = "PONG" ]; then
clear
echo "========================================================================="
echo "Redis dang stop"
echo "-------------------------------------------------------------------------"
echo "Ban phai bat Redis len bang lenh [ service redis start ]"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
echo "========================================================================="
echo "Su dung chuc nang nay de BAT Redis cho Wordpress Website"
echo "========================================================================="
echo -n "Nhap domain ban muon su dung Redis [ENTER]: " 
read website
clear
if [ "$website" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap lai."
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
kiemtradomain3="^([[:alnum:]]([[:alnum:]\-]{0,61}[[:alnum:]])?\.)+[[:alpha:]]{2,14}$";
if [[ ! "$website" =~ $kiemtradomain3 ]]; then
	website=`echo $website | tr '[A-Z]' '[a-z]'`
clear
echo "========================================================================="
echo "$website khong phai la domain!"
echo "-------------------------------------------------------------------------"
echo "Ban hay nhap lai !"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
if [ ! -f /etc/nginx/conf.d/$website.conf ]; then
clear
echo "========================================================================="
echo "$website khong ton tai tren he thong!"
echo "-------------------------------------------------------------------------"
echo "Ban hay nhap lai !"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
if [ ! -f /home/$website/public_html/wp-config.php ]; then
clear
echo "========================================================================="
echo "$website khong phai la wordpress blog hoac chua cai dat wordpress!"
echo "-------------------------------------------------------------------------"
echo "Vui long cai dat wp truoc hoac nhap domain khac"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
if [ ! "$(grep "WP_CACHE_KEY_SALT" /home/$website/public_html/wp-config.php)" == "" ]; then
clear
echo "========================================================================="
echo "$website da duoc config su dung Redis cache"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi

echo "-------------------------------------------------------------------------"
echo "Tim thay $website tren he thong"
echo "========================================================================= "
read -r -p "Ban muon BAT Redis Cache cho $website ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY])
echo "-------------------------------------------------------------------------"
echo "LEMP se cai dat Redis Cache cho $website"
echo "-------------------------------------------------------------------------"
echo "Cac Plugins se duoc cai dat: Nginx-Hepler, Redis Object Cache"
echo "-------------------------------------------------------------------------"
echo "Please wait.... !"
sleep 8
echo "-------------------------------------------------------------------------"

if [ ! -d /home/$website/public_html/wp-content/plugins/redis-cache ]; then
cd /home/$website/public_html
wp plugin install redis-cache --activate --allow-root
yes | cp -rf /home/$website/public_html/wp-content/plugins/redis-cache/includes/object-cache.php /home/$website/public_html/wp-content/object-cache.php
chown -R www-data:www-data /home/$website/public_html
cd
else
cd /home/$website/public_html
wp plugin activate redis-cache --allow-root
yes | cp -rf /home/$website/public_html/wp-content/plugins/redis-cache/includes/object-cache.php /home/$website/public_html/wp-content/object-cache.php
chown -R www-data:www-data /home/$website/public_html
cd
fi
if [ ! -d /home/$website/public_html/wp-content/plugins/nginx-helper ]; then
cd /home/$website/public_html
wp plugin install nginx-helper --activate --allow-root
cd
else
cd /home/$website/public_html
wp plugin activate nginx-helper --allow-root
cd
fi
#sed -i "/.*DB_COLLATE.*/adefine('WP_CACHE_KEY_SALT', '$website');" /home/$website/public_html/wp-config.php
#sed -i "/define('WP_CACHE_KEY_SALT', '$website');/adefine('WP_CACHE', true);" /home/$website/public_html/wp-config.php

#sed -i "/.*DB_COLLATE.*/a\if ! defined('WP_CACHE_KEY_SALT') define('WP_CACHE_KEY_SALT', '$website');" /home/$website/public_html/wp-config.php
#sed -i "/define('WP_CACHE_KEY_SALT', '$website');/a\if ! defined('WP_CACHE') define('WP_CACHE', true);" /home/$website/public_html/wp-config.php


systemctl restart php${PHP_VERSION}-fpm.service
systemctl restart redis.service

;;
    *)
       clear 
echo "========================================================================= "
echo "Huy bo BAT Redis Cache cho $website "
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
        ;;
esac
clear
echo "========================================================================="
echo "BAT Redis cho $website thanh cong "
echo "-------------------------------------------------------------------------"
echo "Ban hay kiem tra va kich hoat plugins: Nginx-Helper, Redis Object Cache"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
