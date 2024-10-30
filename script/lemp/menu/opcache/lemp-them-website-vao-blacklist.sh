#!/bin/bash

. /home/lemp.conf
if [ ! -f /etc/php.d/opcache.ini ]; then
clear
echo "========================================================================="
echo "Zend Opcache dang duoc TAT"
echo "-------------------------------------------------------------------------"
echo "Hay bat Zend Opcache len de su dung chuc nang nay"
/etc/lemp/menu/opcache/lemp-before-opcache.sh
fi


echo "========================================================================="
echo "Su dung chuc nang nay de them website vao Zend Opcache Blacklist."
echo "-------------------------------------------------------------------------"
echo "Sau khi them, Zend Opcache se khong cache php files cho website do nua"
echo "========================================================================="
echo -n "Nhap ten website [ENTER]: " 
read website

if [ "$website" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap lai!"
/etc/lemp/menu/opcache/lemp-before-opcache.sh
exit
fi


kiemtradomain3="^([[:alnum:]]([[:alnum:]\-]{0,61}[[:alnum:]])?\.)+[[:alpha:]]{2,14}$";
if [[ ! "$website" =~ $kiemtradomain3 ]]; then
	website=`echo $website | tr '[A-Z]' '[a-z]'`
clear
echo "========================================================================="
echo "$website co le khong phai la domain !!"
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai  !"
/etc/lemp/menu/opcache/lemp-before-opcache.sh
exit
fi

if [ ! -f /etc/nginx/conf.d/$website.conf ]; then
clear
echo "========================================================================="
echo "$website khong ton tai tren he thong"
echo "-------------------------------------------------------------------------"
echo "Ban hay nhap lai"
/etc/lemp/menu/opcache/lemp-before-opcache.sh
exit
fi
if [ ! "$(grep /home/$website /etc/lemp/opcache.blacklist)" == "" ]; then
clear
echo "========================================================================="
echo "Ban da them $website vao Zend Opcache Blacklist tu truoc"
/etc/lemp/menu/opcache/lemp-before-opcache.sh
exit
fi
echo "-------------------------------------------------------------------------"
echo "Tim thay $website tren he thong "
echo "-------------------------------------------------------------------------"
echo "LEMP se them $website vao Zend Opcache Blacklist"
echo "-------------------------------------------------------------------------"
echo "Please wait..."; sleep 4
echo "-------------------------------------------------------------------------"
echo "/home/$website/" >> /etc/lemp/opcache.blacklist
if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
service php-fpm restart
else
systemctl restart php-fpm.service
fi
clear
echo "========================================================================="
echo "Them $website vao Zend Opcache Blacklist thanh cong !"
/etc/lemp/menu/opcache/lemp-before-opcache.sh






























