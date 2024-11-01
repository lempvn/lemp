#!/bin/bash
. /home/lemp.conf
echo "========================================================================="
echo "Su dung chuc nang nay de TAT Zend Opcache cho server"
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon tat Zend Opcache ?  [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
   echo "-------------------------------------------------------------------------"
   echo "Please wait....";sleep 1
	mv /etc/php.d/opcache.ini /etc/php.d/opcache.bak
if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
service php-fpm restart
else
systemctl restart php-fpm.service
fi
clear
echo "========================================================================="
	echo "Tat Zend OPcache thanh cong !"
/etc/lemp/menu/opcache/lemp-dang-tat-opcache-menu.sh
        ;;
    *)
        clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap lai"
/etc/lemp/menu/opcache/lemp-before-opcache.sh
        ;;
esac
exit
fi
