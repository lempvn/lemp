#!/bin/bash 
. /home/lemp.conf
if [ -f /etc/php.d/opcache.ini ]; then

if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
service php-fpm restart
fi
#if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "7" ]; then 
if [ ! "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
systemctl restart php-fpm.service
fi

if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
test_php=$(/sbin/service php-fpm status | awk 'NR==1 {print $3}')
if [ "$test_php" == "stopped" ]; then
clear
echo "========================================================================="
echo "Zend Opcache khong the clear vi PHP-FPM khong the khoi dong lai. "
echo "-------------------------------------------------------------------------"
echo "Co the ban da config sai gi do!"
/etc/lemp/menu/lemp-opcache-menu
exit
fi
fi

#if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "7" ]; then 
if [ ! "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
test_php=$(/bin/systemctl status  php-fpm.service | awk 'NR==3 {print $2}')
if [ "$test_php" == "inacctive" ]; then
clear
echo "========================================================================="
echo "Zend Opcache khong the clear vi PHP-FPM khong the khoi dong lai. "
echo "-------------------------------------------------------------------------"
echo "Co the ban da config sai gi do!"
/etc/lemp/menu/lemp-opcache-menu
exit
fi
fi

#if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "7" ]; then 
if [ ! "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
test_php=$(/bin/systemctl status  php-fpm.service | awk 'NR==3 {print $2}')
if [ "$test_php" == "failed" ]; then
clear
echo "========================================================================="
echo "Zend Opcache khong the clear vi PHP-FPM khong the khoi dong lai. "
echo "-------------------------------------------------------------------------"
echo "Co the ban da config sai gi do!"
/etc/lemp/menu/lemp-opcache-menu
exit
fi
fi
echo "Please wait....";sleep 1
clear
echo "========================================================================= "
echo "Ban da hoan thanh Clear Opcache "
/etc/lemp/menu/lemp-opcache-menu
fi
clear
echo "========================================================================= "
echo "Zend OPcache dang Disable tren VPS"
echo "Hay bat Zend Opcache len de VPS co hieu suat tot nhat."
/etc/lemp/menu/lemp-opcache-menu
exit
fi
