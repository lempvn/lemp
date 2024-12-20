#!/bin/bash
echo "========================================================================="
echo "Su dung chuc nang nay de go bo LEMP khoi may chu"
echo "-------------------------------------------------------------------------"
echo "Trong qua trinh go bo, toan bo du lieu website, database ... se bi xoa"
echo "-------------------------------------------------------------------------"
echo "May chu se quay tro lai trang thai nhu moi."
echo "========================================================================="
read -r -p "Ban chac chan muon go bo LEMP? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
echo "-------------------------------------------------------------------------"
echo -n "Nhap [ OK ] de xac nhan: " 
read xacnhan
if [ ! "$xacnhan" = "OK" ]; then
clear
echo "========================================================================="
echo "Huy go bo LEMP"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi
echo "-------------------------------------------------------------------------"
echo "Chuan bi go bo LEMP, vui long doi ...."
sleep 2

# Dung cac dich vu
#systemctl stop exim.service 
#systemctl disable exim.service
systemctl stop nginx.service 
systemctl disable nginx.service 
systemctl stop mariadb.service 
systemctl disable mariadb.service 
systemctl stop php*-fpm.service 
systemctl disable php*-fpm.service 
systemctl stop redis.service 
systemctl disable redis.service 

# Go cai dat cac goi
sudo apt-get -y remove --purge mariadb* nginx php* exim mailutils httpd* syslog-ng htop pure-ftpd gcc g++ redis* memcached* unzip zip rar unrar rsync psmisc

# Xoa cac tep va thu muc khong can thiet
rm -rf /etc/nginx
rm -rf /etc/php-fpm.d
rm -rf /etc/php.d
rm -rf /etc/php.zts.d
rm -rf /etc/exim
rm -rf /var/lib/mysql
rm -rf /etc/mysql
rm -rf /etc/cron.d/*
rm -rf /etc/httpd
rm -rf /etc/syslog-ng
rm -rf /var/log/nginx
rm -rf /var/cache/ngx_pagespeed
rm -rf /etc/pure-ftpd
rm -rf /etc/motd 
rm -rf /home/*

# Xoa swap file neu co
if [ -f /swapfile ]; then
    swapoff /swapfile
    rm -rf /swapfile
fi

# Xoa cac tap tin cau hinh CSF neu co
if [ -f /etc/csf/csf.conf ]; then
    cd /etc/csf
    sh uninstall.sh
    cd
fi

# Lam sach va cap nhat
apt-get clean
apt-get -y update

clear
echo "========================================================================="
echo "Da hoan tat moi thu...!"
echo "-------------------------------------------------------------------------"
echo "May chu se khoi dong lai sau 3 giay de hoan tat...!"
sleep 3
reboot
exit
        ;;
    *)
    clear
    echo "========================================================================="
    echo "Huy go bo LEMP"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
        ;;
esac
