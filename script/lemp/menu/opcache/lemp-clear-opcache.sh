#!/bin/bash 
. /home/lemp.conf
if [ ! -f /etc/php.d/opcache.ini ]; then
clear
echo "========================================================================="
echo "Zend Opcache current DISABLE"
echo "-------------------------------------------------------------------------"
echo "Please enable it to use this function"
/etc/lemp/menu/opcache/lemp-before-opcache.sh
fi
if [ -f /etc/php.d/opcache.ini ]; then
echo "-------------------------------------------------------------------------"
echo "Please wait....";sleep 1

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
echo "Zend Opcache khong the clear vi PHP-FPM khong the khoi dong. "
echo "-------------------------------------------------------------------------"
echo "Co the ban da config PHP-FPM sai !!"
/etc/lemp/menu/opcache/lemp-before-opcache.sh
exit
fi
fi


#if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "7" ]; then 
if [ ! "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
test_php=$(/bin/systemctl status  php-fpm.service | awk 'NR==3 {print $2}')
if [ "$test_php" == "inactive" ]; then
clear
echo "========================================================================="
echo "Zend Opcache khong the clear vi PHP-FPM bi stop. "
/etc/lemp/menu/opcache/lemp-before-opcache.sh
exit
fi
fi


#if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "7" ]; then 
if [ ! "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
test_php=$(/bin/systemctl status  php-fpm.service | awk 'NR==3 {print $2}')
if [ "$test_php" == "failed" ]; then
clear
echo "========================================================================="
echo "Zend Opcache khong the clear vi PHP-FPM khong the khoi dong. "
echo "-------------------------------------------------------------------------"
echo "Co the ban da config PHP-FPM sai !!"
/etc/lemp/menu/opcache/lemp-before-opcache.sh
exit
fi
fi
clear
echo "========================================================================= "
echo "Ban da hoan thanh clear Zend Opcache "
/etc/lemp/menu/opcache/lemp-before-opcache.sh
fi
clear
echo "========================================================================= "
echo "Zend OPcache dang disable tren VPS"
echo "-------------------------------------------------------------------------"
echo "Hay bat Zend Opcache len de VPS co hieu suat tot nhat!"
/etc/lemp/menu/opcache/lemp-before-opcache.sh
fi
