#!/bin/bash
. /home/lemp.conf
echo "========================================================================="
echo "Su dung chuc nang nay de BAT Zend Opcache cho server"
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon bat Zend Opcache ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "-------------------------------------------------------------------------"
    echo "Please wait....";sleep 1
	mv /etc/php.d/opcache.bak /etc/php.d/opcache.ini
if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
service php-fpm restart
else
systemctl restart php-fpm.service
fi

if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
test_php=$(/sbin/service php-fpm status | awk 'NR==1 {print $3}')
if [ "$test_php" == "stopped" ]; then
clear
echo "========================================================================="
echo "PHP-FPM khong the khoi dong! "
echo "-------------------------------------------------------------------------"
echo "Co the ban da config PHP-FPM sai !"
/etc/lemp/menu/opcache/lemp-before-opcache.sh
exit
fi
fi


#if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "7" ]; then 
if [ ! "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
	if [ ! "`systemctl is-active php-fpm.service`" == "active" ]; then
clear
echo "========================================================================="
echo "PHP-FPM khong the khoi dong! "
echo "-------------------------------------------------------------------------"
echo "Co the ban da config PHP-FPM sai !"
/etc/lemp/menu/opcache/lemp-before-opcache.sh
exit
fi
fi

clear
echo "========================================================================="
	echo "BAT Zend OPcache thanh cong  !"
/etc/lemp/menu/opcache/lemp-before-opcache.sh
        ;;
    *)
        clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap lai"
/etc/lemp/menu/opcache/lemp-before-opcache.sh
        ;;
esac
