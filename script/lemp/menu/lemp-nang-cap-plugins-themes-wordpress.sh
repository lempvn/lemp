#!/bin/bash
. /home/lemp.conf

PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")

echo "========================================================================="
echo "Nhap ten website ban muon nang cap themes va plugins "
echo "-------------------------------------------------------------------------" 
echo -n "Nhap ten website: " 
read website
if [ "$website" = "" ]; then
clear
echo "========================================================================="
echo "You typed wrong, please type in accurately! "
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
kiemtradomain3="^([[:alnum:]]([[:alnum:]\-]{0,61}[[:alnum:]])?\.)+[[:alpha:]]{2,14}$";
if [[ ! "$website" =~ $kiemtradomain3 ]]; then
	website=`echo $website | tr '[A-Z]' '[a-z]'`
clear
echo "========================================================================="
echo "$website co le khong phai ten domain !"
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai !"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
if [ ! -f /etc/nginx/conf.d/$website.conf ]; then
clear
echo "========================================================================="
echo "Khong tim thay $website tren he thong"
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai !"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi

if [ ! -f /home/$website/public_html/wp-config.php ]; then
clear
echo "========================================================================="
echo "$website co the khong phai wordpress web hoac chua cai dat WP"
echo "-------------------------------------------------------------------------"
echo "Vui long cai dat Wordpress code truoc hoac thu domain khac"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
databasename=`cat /home/$website/public_html/wp-config.php | grep DB_NAME | cut -d \' -f 4`
echo "-------------------------------------------------------------------------"
echo "Tim thay $website dang su dung wordpress code tren he thong"
echo "========================================================================="
echo "LUA CHON UPDATE PLUGIN & THEMES"
echo "========================================================================="
prompt="Lua chon cua ban: "
options=( "Update tat ca themes" "Update tat ca plugins" "Huy bo")
PS3="$prompt"
select opt in "${options[@]}"; do 

    case "$REPLY" in
    1) cachlam="updatethemes"; break;;
    2) cachlam="updateplugins"; break;;
    3) cachlam="updatecahai"; break;;  
    4) cachlam="huybo"; break;; 
    *) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu";continue;;
    esac  
done
###################################
#oooo
###################################
if [ "$cachlam" = "updatethemes" ]; then
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
echo "-------------------------------------------------------------------------"
sleep 1
cd /home/$website/public_html/
chown -R www-data:www-data /home/$website/public_html/wp-content/themes
#/etc/lemp/menu/lemp-enable-tat-ca-cac-ham-php-php.ini
wp theme update --all --allow-root | grep Success: > /tmp/update-themes-status
#/etc/lemp/menu/lemp-re-config-cac-ham-php-disable-php.ini
chown -R www-data:www-data /home/$website/public_html/wp-content/themes

systemctl restart php${PHP_VERSION}-fpm.service

cd
clear
echo "========================================================================="
if [ "$(cat /tmp/update-themes-status)" = "Success: Updated 0/0 themes." ]; then
echo "$website: 0 theme need update"
rm -rf /tmp/update-themes-status
else
echo "$wpwebsite: $(cat /tmp/update-themes-status | sed 's/Success://')"
rm -rf /tmp/update-themes-status
fi
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
elif [ "$cachlam" = "updateplugins" ]; then
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
sleep 1
chown -R www-data:www-data /home/$website/public_html/wp-content/plugins
cd /home/$website/public_html/
#/etc/lemp/menu/lemp-enable-tat-ca-cac-ham-php-php.ini
wp plugin update --all --allow-root | grep Success: > /tmp/update-plugins-status
#/etc/lemp/menu/lemp-re-config-cac-ham-php-disable-php.ini
chown -R www-data:www-data /home/$website/public_html/wp-content/plugins

systemctl restart php${PHP_VERSION}-fpm.service
 
cd
clear
echo "========================================================================="
if [ "$(cat /tmp/update-plugins-status)" = "Success: Updated 0/0 plugins." ]; then
echo "$website: 0 plugin need update"
rm -rf /tmp/update-plugins-status
else
echo "$wpwebsite: $(cat /tmp/update-plugins-status | sed 's/Success://')"
rm -rf /tmp/update-plugins-status
fi
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
else 
clear
echo "========================================================================="
echo "Huy bo update Themes & PLugins cho $website"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
fi


