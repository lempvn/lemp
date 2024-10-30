#!/bin/bash
. /home/lemp.conf
echo "========================================================================="
echo "Su dung chuc nang nay de tao backup cho cac file config va Vhost"
echo "-------------------------------------------------------------------------"
echo "Danh sach file va folder se duoc backup: server.cnf, www.conf, php.ini"
echo "-------------------------------------------------------------------------"
echo "php-fpm.conf va Folder Nginx (chua cac file Vhost, SSL ...)" 
echo "========================================================================="
read -r -p "Ban muon sao luu cac file config & vhost? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
        echo "-------------------------------------------------------------------------"
        echo "Please wait ..."
        sleep 1
        rm -rf /home/$mainsite/private_html/Backupconfigandvhost*
        backupsys=$(date | md5sum | cut -c '1-12') 
        mkdir -p /usr/local/backup-system
        cp -r /etc/nginx /usr/local/backup-system/
        \cp -uf /etc/my.cnf.d/server.cnf /usr/local/backup-system/
        \cp -uf /etc/php/*/php.ini /usr/local/backup-system/   # Duong dan den php.ini tren Ubuntu
        \cp -uf /etc/php/*/fpm/php-fpm.conf /usr/local/backup-system/  # Duong dan den php-fpm.conf tren Ubuntu
        cp -r /etc/php/*/fpm/pool.d/www.conf /usr/local/backup-system/  # Duong dan den www.conf tren Ubuntu
        cd /usr/local/backup-system/
        zip -r backupsys.zip *
        mv backupsys.zip /home/$mainsite/private_html/Backupconfigandvhost-$backupsys.zip
        cd
        rm -rf /usr/local/backup-system
        clear
        echo "========================================================================="
        echo "Link Download File Backup:"
        echo "-------------------------------------------------------------------------"
        echo "http://$serverip:$priport/Backupconfigandvhost-$backupsys.zip"
        /etc/lemp/menu/tienich/lemp-tien-ich.sh
        ;;
    *)
       clear
       echo "========================================================================= "
       echo "Huy bo tao backup cho file config & Vhost."
       /etc/lemp/menu/tienich/lemp-tien-ich.sh
       ;;
esac
