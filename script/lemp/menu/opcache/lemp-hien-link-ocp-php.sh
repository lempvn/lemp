#!/bin/sh
. /home/lemp.conf
if [ ! -f /etc/php.d/opcache.ini ]; then
clear
echo "========================================================================="
echo "Zend Opcache dang duoc TAT"
echo "-------------------------------------------------------------------------"
echo "Hay bat Zend Opcache len de su dung chuc nang nay"
/etc/lemp/menu/opcache/lemp-before-opcache.sh
else
echo "-------------------------------------------------------------------------"
echo "Please wait..."; sleep 1
clear
echo "========================================================================="
echo "Su Dung Link Duoi Day De Xem Zend Opcache Status:"
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport/ocp.php"
/etc/lemp/menu/opcache/lemp-before-opcache.sh
fi
