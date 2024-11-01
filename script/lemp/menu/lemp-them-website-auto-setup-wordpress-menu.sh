#!/bin/bash 

. /home/lemp.conf

if [ ! -f /usr/local/bin/wp ]; then
echo "========================================================================="
echo "Installing  WP-CLI" ; sleep 2
#wget -q --no-check-certificate https://lemp.com/script/lemp/Softwear/wp-cli.phar
#wget -q --no-check-certificate https://github.com/itvn9online/lemp-free/raw/master/script/lemp/Softwear/wp-cli.phar
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
wp --version --allow-root > /etc/lemp/wpcli.version 
fi

if [ ! -f /etc/lemp/wpcli.version ]; then
touch -a -m -t 201601180130.09 /etc/lemp/wpcli.version 
fi

fileTime3=$(date -r /etc/lemp/wpcli.version +%d)
curTime3=$(date +%d)
if [ ! "$fileTime3" == "$curTime3" ]; then
wp_cli_update=`wp cli check-update --allow-root | awk 'NR==1 {print $1}'`
wp --version --allow-root > /etc/lemp/wpcli.version 
if [ ! "$wp_cli_update" = "Success:" ]; then
echo "========================================================================="
echo "Update for WP-CLI Found ! Updating WP-CLI ..." ; 
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
sleep 4
#/etc/lemp/menu/lemp-enable-tat-ca-cac-ham-php-php.ini

echo y | wp cli update --allow-root
#/etc/lemp/menu/lemp-re-config-cac-ham-php-disable-php.ini
wp --version --allow-root > /etc/lemp/wpcli.version 
clear
/etc/lemp/menu/lemp-them-website-menu.sh
fi
fi

prompt="Nhap lua chon cua ban: "
options=( "Redis Cache" "WP Super cache" "W3 Total Cache" "Huy bo")
printf "=========================================================================\n"
printf "Tuy thuoc vao loai cache ban su dung ma LEMP config Vhost cho phu hop  \n"
printf "=========================================================================\n"
PS3="$prompt"
select opt in "${options[@]}"; do 

    case "$REPLY" in
    1) vhostconfig="redis"; break;;
    2) vhostconfig="supercache"; break;;
    3) vhostconfig="w3total"; break;;
    4) vhostconfig="cancel"; break;;
    *) echo "Ban nhap sai ! Ban vui long chon so trong danh sach";continue;;
    esac  
done
###################################
#Redis Cache
###################################
if [ "$vhostconfig" = "redis" ]; then
/etc/lemp/menu/lemp-them-website-wp-auto-install-redis-cache.sh
###################################
#Super Cache
###################################
elif [ "$vhostconfig" = "supercache" ]; then
/etc/lemp/menu/lemp-them-website-wp-auto-install-super-cache.sh
###################################
#W3 Total Cache
###################################
elif [ "$vhostconfig" = "w3total" ]; then
/etc/lemp/menu/lemp-them-website-wp-auto-install-w3-total-cache.sh
else 
clear && /etc/lemp/menu/lemp-them-website-menu.sh
fi
