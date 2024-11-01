#!/bin/bash

. /home/lemp.conf

PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")

echo "========================================================================="
#echo "Mac dinh, che do tu dong cap nhat luon BAT tren WordPress Website"
echo "-------------------------------------------------------------------------"
echo "Su dung chuc nang nay de TAT - BAT tinh nang auto update nay."
echo "========================================================================="
echo -n "Nhap ten website [ENTER]: " 
read website
website=`echo $website | tr '[A-Z]' '[a-z]'`
if [ "$website" = "" ]; then
    clear
    echo "========================================================================="
    echo "Ban nhap sai, vui long nhap chinh xac."
    /etc/lemp/menu/lemp-wordpress-tools-menu.sh
    exit
fi

kiemtradomain3="^([[:alnum:]]([[:alnum:]\-]{0,61}[[:alnum:]])?\.)+[[:alpha:]]{2,14}$"
if [[ ! "$website" =~ $kiemtradomain3 ]]; then
    clear
    echo "========================================================================="
    echo "$website co the khong dung dinh dang domain"
    echo "-------------------------------------------------------------------------"
    echo "Ban vui long thu lai!"
    /etc/lemp/menu/lemp-wordpress-tools-menu.sh
    exit
fi

if [ ! -f /etc/nginx/conf.d/$website.conf ]; then
    clear
    echo "========================================================================="
    echo "$website khong ton tai tren he thong"
    echo "-------------------------------------------------------------------------"
    echo "Ban vui long thu lai!"
    /etc/lemp/menu/lemp-wordpress-tools-menu.sh
    exit
fi

if [ ! -f /home/$website/public_html/wp-config.php ]; then
    clear
    echo "========================================================================="
    echo "$website khong su dung WordPress code hoac chua cai dat!"
    echo "-------------------------------------------------------------------------"
    echo "Vui long cai dat WordPress code truoc hoac nhap domain khac"
    /etc/lemp/menu/lemp-wordpress-tools-menu.sh
    exit
fi

if grep -q "define('WP_AUTO_UPDATE_CORE'" /home/$website/public_html/wp-config.php; then
    echo "========================================================================="
    echo "$website hien tai dang TAT tu dong nang cap!"
    echo "-------------------------------------------------------------------------"
    read -r -p "Ban muon BAT auto update? [y/N] " response
    case $response in
        [yY][eE][sS]|[yY]) 
            echo "-------------------------------------------------------------------------"
            echo "Vui long cho..."
            sleep 1
            
            # Xoa dong WP_AUTO_UPDATE_CORE neu ton tai
            sed -i "/define('WP_AUTO_UPDATE_CORE', false);/d" /home/$website/public_html/wp-config.php  
            # Them dong de bat auto update
            echo "define('WP_AUTO_UPDATE_CORE', true);" >> /home/$website/public_html/wp-config.php

            systemctl restart php${PHP_VERSION}-fpm.service
            
            clear
            echo "========================================================================="
            echo "BAT Auto Update cho $website thanh cong!"
            /etc/lemp/menu/lemp-wordpress-tools-menu.sh
            ;;
        *)
            clear
            echo "========================================================================="
            echo "Ban huy thay doi cai dat auto update cho $website"
            /etc/lemp/menu/lemp-wordpress-tools-menu.sh
            ;;
    esac
    exit
fi

echo "========================================================================="
echo "$website hien tai dang BAT tu dong nang cap!"
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon TAT auto update? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
        echo "-------------------------------------------------------------------------"
        echo "Vui long cho..."
        sleep 1
        
        # Them dong de tat auto update
        sed -i "/define('WP_AUTO_UPDATE_CORE', true);/d" /home/$website/public_html/wp-config.php
        echo "define('WP_AUTO_UPDATE_CORE', false);" >> /home/$website/public_html/wp-config.php
        
        systemctl restart php${PHP_VERSION}-fpm.service
        
        clear
        echo "========================================================================="
        echo "TAT Auto Update cho $website thanh cong!"
        /etc/lemp/menu/lemp-wordpress-tools-menu.sh
        ;;
    *)
        clear
        echo "========================================================================="
        echo "Ban huy thay doi cai dat auto update cho $website"
        /etc/lemp/menu/lemp-wordpress-tools-menu.sh
        ;;
esac
exit
