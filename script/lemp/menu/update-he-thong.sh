#!/bin/bash

. /home/lemp.conf

PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")

echo "========================================================================="
echo "Chuc nang nay se update Ubuntu system, MariaDB va PHP-FPM."
echo "-------------------------------------------------------------------------"
read -r -p "Ban chac chan muon update? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
        echo "-------------------------------------------------------------------------"
        echo "Chuan bi update ..... "
        sleep 1
        sudo apt update
		#sudo DEBIAN_FRONTEND=noninteractive apt -yqq upgrade
        sudo DEBIAN_FRONTEND=noninteractive apt -yqq full-upgrade
        rm -rf /tmp/*opcache*
        
        if [ -f /etc/php/${PHP_VERSION}/mods-available/opcache.bak ]; then  # Cap nhat voi phien ban PHP dang su dung
            yes | cp -rf /etc/php/${PHP_VERSION}/mods-available/opcache.bak /tmp
        fi
        if [ -f /etc/php/${PHP_VERSION}/mods-available/opcache.ini ]; then
            yes | cp -rf /etc/php/${PHP_VERSION}/mods-available/opcache.ini /tmp
        fi
        
        rm -rf /etc/php/${PHP_VERSION}/*opcache*
        sudo DEBIAN_FRONTEND=noninteractive apt -yqq upgrade php\*
        rm -rf /tmp/abc.txt
        
        if [ -f /tmp/opcache.bak ]; then
            yes | cp -rf /tmp/opcache.bak /etc/php/${PHP_VERSION}/mods-available
        fi
        if [ -f /tmp/opcache.ini ]; then
            yes | cp -rf /tmp/opcache.ini /etc/php/${PHP_VERSION}/mods-available
        fi
        
        rm -rf /tmp/*opcache*
        chmod 777 /var/lib/php/sessions/  # Dam bao duong dan dung voi Ubuntu
        clear
        echo "========================================================================="
        echo "Da cap nhat thanh cong server"
        /etc/lemp/menu/lemp-update-upgrade-service-menu.sh
        ;;
    *) 
        rm -rf /tmp/abc.txt
        clear
        echo "========================================================================="
        echo "Ban da huy bo update "
        /etc/lemp/menu/lemp-update-upgrade-service-menu.sh
        exit
        ;;
esac
