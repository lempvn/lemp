#!/bin/bash

. /home/lemp.conf

if [ -f /etc/php.d/ioncube.ini ]; then
echo "========================================================================="
echo "Su dung chuc nang nay de Cai Dat / Remove Ioncube cho server"
echo "-------------------------------------------------------------------------"
echo "Ioncube Loader da duoc cai dat tren server."
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon remove Ioncube ?  [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "-------------------------------------------------------------------------"
    echo "Please wait ..."
    sleep 1
    
rm -rf /etc/php.d/*.ioncube.*
rm -rf /etc/php.d/ioncube.*
rm -rf /usr/local/ioncube
if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
service php-fpm restart
else
systemctl restart php-fpm.service
fi
clear
echo "========================================================================="

	echo "Go bo Ioncube Loader thanh cong !"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
        ;;
    *)
       clear
    echo "========================================================================="
   echo "Ban huy bo remove Ioncube Loader"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
        ;;
esac
exit
fi
php_version1=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")
if [ "$php_version1" == "7.0" ]; then
clear
echo "========================================================================="
echo "Ban dang dung PHP 7.0"
echo "-------------------------------------------------------------------------"
echo "Chuc nang nay khong ho tro PHP 7.0"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi
echo "========================================================================="
echo "Su dung chuc nang nay de Cai Dat / Remove Ioncube cho server"
echo "-------------------------------------------------------------------------"
echo "Ioncube Loader chua duoc cai dat tren server"
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon cai dat Ioncube Loader  ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "-------------------------------------------------------------------------"
		echo "Please wait..."
		sleep 1
/etc/lemp/menu/lemp-enable-tat-ca-cac-ham-php-php.ini
sleep 1

# tao file nay de goi toi file cai dat ioncube thi no moi cai
echo "ioncubestatus=1" > /tmp/change_php_config

## Ioncube
/etc/lemp/menu/nangcap-php/setup-ioncube.sh

/etc/lemp/menu/lemp-re-config-cac-ham-php-disable-php.ini
if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
service php-fpm restart
else
systemctl restart php-fpm.service
fi
clear
echo "========================================================================="
echo "Cai dat Ioncube Loader vao server thanh cong !"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
       ;;
    *)
    clear
    echo "========================================================================="
   echo "Ban huy install Ioncube Loader"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
        ;;
esac
exit
fi
