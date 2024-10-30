#!/bin/bash
. /home/lemp.conf

PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")

echo "========================================================================="
echo "Su dung chuc nang nay de fix loi [Missed Schedule] cho WP Website" 
echo "-------------------------------------------------------------------------"
echo "LEMP se cai dat plugin: [WP Missed Schedule] cho WP website va tu dong"
echo "-------------------------------------------------------------------------"
echo "BAT no. Plugin nay se chay 5 phut 1 lan va tu dong republish nhung post "
echo "-------------------------------------------------------------------------"
echo "bi loi Missed Schedule nhung gan nhu khong tieu ton tai nguyen server."
echo "========================================================================="
echo -n "Nhap ten website [ENTER]: " 
read website
website=`echo $website | tr '[A-Z]' '[a-z]'`
if [ "$website" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap chinh xac."
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
kiemtradomain3="^([[:alnum:]]([[:alnum:]\-]{0,61}[[:alnum:]])?\.)+[[:alpha:]]{2,14}$";
if [[ ! "$website" =~ $kiemtradomain3 ]]; then
	website=`echo $website | tr '[A-Z]' '[a-z]'`
clear
echo "========================================================================="
echo "$website co the khong dung dinh dang domain"
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai !"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
if [ ! -f /etc/nginx/conf.d/$website.conf ]; then
clear
echo "========================================================================="
echo "$website khong ton tai tren he thong"
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai !"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
if [ ! -f /home/$website/public_html/wp-config.php ]; then
clear
echo "========================================================================="
echo "$website khong su dung wordpress code hoac chua cai dat!"
echo "-------------------------------------------------------------------------"
echo "Vui long cai dat wordpress code truoc hoac nhap domain khac"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi

if [ -d /home/$website/public_html/wp-content/plugins/wp-missed-schedule ]; then
clear
echo "========================================================================="
echo "Ban da cai dat plugin wp-missed-schedule cho $website!"
echo "-------------------------------------------------------------------------"
echo "Hay acctive neu ban dang Disable no."
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi

echo "========================================================================="
read -r -p "Ban muon fix loi Missed Schedule cho $website ?  [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "-------------------------------------------------------------------------"
    echo "Please wait..."    		
    sleep 1
cd /tmp
rm -rf /tmp/wp-missed-schedule.zip
#wget -q --no-check-certificate https://lemp.com/script/lemp/Softwear/wp-missed-schedule.zip
wget -q --no-check-certificate https://github.com/vpsvn/vps-vps-software/raw/main/wp-missed-schedule.zip
if [ ! -f /tmp/wp-missed-schedule.zip ]; then
#wget -q --no-check-certificate https://lemp.com/script/lemp/Softwear/wp-missed-schedule.zip
wget -q --no-check-certificate https://github.com/vpsvn/vps-vps-software/raw/main/wp-missed-schedule.zip
fi
unzip -q wp-missed-schedule.zip -d /home/$website/public_html/wp-content/plugins/
rm -rf /tmp/wp-missed-schedule.zip
chown -R www-data:www-data /home/$website/public_html/wp-content/plugins/wp-missed-schedule/*
cd /home/$website/public_html
#/etc/lemp/menu/lemp-enable-tat-ca-cac-ham-php-php.ini
wp plugin activate wp-missed-schedule --allow-root
#/etc/lemp/menu/lemp-re-config-cac-ham-php-disable-php.ini
cd

systemctl restart php${PHP_VERSION}-fpm.service

clear
echo "========================================================================="
if [ -d /home/$website/public_html/wp-content/plugins/wp-missed-schedule ]; then
echo "Fix loi Missed Schedule cho $website thanh cong !"
else
echo "Fix loi Missed Schedule chua hoan thanh !"
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai!"
fi
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
        ;;
    *)
       clear
    echo "========================================================================="
   echo "Cancel !"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
        ;;
esac
exit
