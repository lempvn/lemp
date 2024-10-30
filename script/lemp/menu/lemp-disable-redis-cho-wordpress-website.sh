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
echo "Su sung chuc nang nay de TAT Redis cho Wordpress Website"
echo "========================================================================="
echo -n "Nhap ten domain  [ENTER]: " 
read website
if [ "$website" = "" ]; then
clear
echo "========================================================================="
echo "Ban vui long nhap website"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
kiemtradomain3="^([[:alnum:]]([[:alnum:]\-]{0,61}[[:alnum:]])?\.)+[[:alpha:]]{2,14}$";
if [[ ! "$website" =~ $kiemtradomain3 ]]; then
	website=`echo $website | tr '[A-Z]' '[a-z]'`
clear
echo "========================================================================="
echo "$website Khong phai la domain"
echo "-------------------------------------------------------------------------"
echo "Ban hay nhap lai !"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
if [ ! -f /etc/nginx/conf.d/$website.conf ]; then
clear
echo "========================================================================="
echo "$website khong ton tai tren he tong!"
echo "-------------------------------------------------------------------------"
echo "Ban hay nhap lai !"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
if [ ! -f /home/$website/public_html/wp-config.php ]; then
clear
echo "========================================================================="
echo "$website khong phai wordpress site hoac chua cai dat!"
echo "-------------------------------------------------------------------------"
echo "Hay cai dat wordpress truoc hoac nhap ten domain khac"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
if [  "$(grep "WP_CACHE_KEY_SALT" /home/$website/public_html/wp-config.php)" == "" ]; then
clear
echo "========================================================================="
echo "$website khong su dung Redis Cache"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
echo "-------------------------------------------------------------------------"
echo "Tim thay $website tren he thong"
echo "========================================================================= "
read -r -p "Ban muon TAT Redis Cache cho $website ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY])
echo "-------------------------------------------------------------------------"
echo "LEMP se vo hieu hoa Redis Cache cho $website"
echo "-------------------------------------------------------------------------"
echo "Cac Plugins se duoc xoa: Nginx-Hepler, Redis Object Cache"
echo "-------------------------------------------------------------------------"
echo "Please wait.... !"
sleep 5
echo "-------------------------------------------------------------------------"
if [ -d /home/$website/public_html/wp-content/plugins/redis-cache ]; then
rm -rf /home/$website/public_html/wp-content/plugins/redis-cache
fi
if [ -d /home/$website/public_html/wp-content/plugins/nginx-helper ]; then
rm -rf /home/$website/public_html/wp-content/plugins/nginx-helper
fi
sed -i '/WP_CACHE_KEY_SALT/d' /home/$website/public_html/wp-config.php
sed -i '/WP_CACHE/d' /home/$website/public_html/wp-config.php
rm -rf /home/$website/public_html/wp-content/object-cache.php

systemctl restart php${PHP_VERSION}-fpm.service
systemctl restart redis.service

;;
    *)
       clear 
echo "========================================================================= "
echo "Huy bo TAT Redis Cache cho $website "
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
        ;;
esac
clear
echo "========================================================================="
echo "TAT redis cache cho $website thanh cong "
/etc/lemp/menu/lemp-wordpress-tools-menu.sh


