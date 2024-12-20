#!/bin/bash

. /home/lemp.conf

if [ -f /etc/php.d/opcache.ini ]; then
echo "========================================================================="
echo "Zend OPcache is enabled !"
read -r -p "Do you want to disable it ?  [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "Please wait....";sleep 1
	mv /etc/php.d/opcache.ini /etc/php.d/opcache.bak
  if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
service php-fpm restart
else
systemctl restart php-fpm.service
fi 
clear
echo "========================================================================="
	echo "Disable Zend OPcache successfully !"
/etc/lemp/menu/lemp-opcache-menu
        ;;
    *)
        clear
echo "========================================================================="
echo "You typed wrong, Please fill accurately"
/etc/lemp/menu/lemp-opcache-menu
        ;;
esac
exit
fi
echo "OPcache is disabled ! Lets enable it to get the most productivity of VPS"
read -r -p "Do you want to enable it ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
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
echo "PHP-FPM can not restart! Maybe you did a wrong config  !"
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
echo "PHP-FPM can not restart! Maybe you did a wrong config  !"
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
echo "PHP-FPM can not restart! Maybe you did a wrong config  !"
/etc/lemp/menu/lemp-opcache-menu
exit
fi
fi
clear
echo "========================================================================="
	echo "Enable Zend OPcache successfully  !"
/etc/lemp/menu/lemp-opcache-menu
        ;;
    *)
        clear
echo "========================================================================="
echo "You typed wrong, Please fill accurately"
/etc/lemp/menu/lemp-opcache-menu
        ;;
esac
