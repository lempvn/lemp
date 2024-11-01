#!/bin/bash
. /home/lemp.conf

PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")

cd /etc/nginx/conf.d
ls > /tmp/websitelist
sed -i 's/\.conf//g' /tmp/websitelist
cd
rm -rf /tmp/wordpresslist
acction1="/tmp/websitelist"
while read -r wpsite
    do
if [ -f /home/$wpsite/public_html/wp-config.php ]; then
echo "$wpsite" >> /tmp/wordpresslist
fi
 done < "$acction1"
 if [ ! -f /tmp/wordpresslist ]; then
clear
echo "========================================================================="
 echo "LEMP khong tim thay website chay Wordpress Code tren Server"
 /etc/lemp/menu/lemp-wordpress-tools-menu.sh
 exit
 fi
echo "========================================================================="
#prompt="Nhap lua chon cua ban: "
prompt="Lua chon cua ban: "
options=( "Update PLugins" "Update Themes" "Huy Bo")
printf "LUA CHON UPDATE PLUGINS HOAC THEMES\n"
printf "=========================================================================\n"
PS3="$prompt"
select opt in "${options[@]}"; do 

    case "$REPLY" in
    1) luachonupdate="updateplugin"; break;;
    2) luachonupdate="updatethemes"; break;;
    3) luachonupdate="cancel"; break;;
    *) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu";continue;;
    
    esac  
done
###################################
#Update plugin
###################################
if [ "$luachonupdate" = "updateplugin" ]; then
#/etc/lemp/menu/lemp-enable-tat-ca-cac-ham-php-php.ini
sositewp=$(cat /tmp/wordpresslist | wc -l)
echo "========================================================================="
echo "Hien tai co $sositewp website dang su dung wordpress code tren server" 
echo "-------------------------------------------------------------------------"
echo "LEMP se check va update tat ca plugins cua $sositewp website nay"
sleep 1
acction2="/tmp/wordpresslist"
while read -r wpwebsite
    do
if [ -f /home/$wpwebsite/public_html/wp-config.php ]; then
cd /home/$wpwebsite/public_html
#echo "========================================================================="
#echo "Update Status For: $wpwebsite"
chown -R www-data:www-data /home/$wpwebsite/public_html/wp-content/plugins
#/etc/lemp/menu/lemp-enable-tat-ca-cac-ham-php-php.ini
wp plugin update --all --allow-root | grep Success: > /tmp/update-plugins-status
chown -R www-data:www-data /home/$wpwebsite/public_html/wp-content/plugins
   if [ "$(cat /tmp/update-plugins-status)" = "Success: Updated 0/0 plugins." ]; then
echo "-------------------------------------------------------------------------"
echo "$wpwebsite: 0 plugin need update"
rm -rf /tmp/update-plugins-status
  else
  echo "-------------------------------------------------------------------------"
echo "$wpwebsite: $(cat /tmp/update-plugins-status | sed 's/Success://')"
rm -rf /tmp/update-plugins-status
cd
  fi
  fi
done < "$acction2"
rm -rf /tmp/wordpresslist
#/etc/lemp/menu/lemp-re-config-cac-ham-php-disable-php.ini
echo "-------------------------------------------------------------------------"

systemctl restart php${PHP_VERSION}-fpm.service

###################################
#Update tat ca themes
###################################
elif [ "$luachonupdate" = "updatethemes" ]; then
#/etc/lemp/menu/lemp-enable-tat-ca-cac-ham-php-php.ini
sositewp=$(cat /tmp/wordpresslist | wc -l)
echo "========================================================================="
echo "Hien tai co $sositewp website dang su dung wordpress code tren server" 
echo "-------------------------------------------------------------------------"
echo "LEMP su check va update tat ca Themes cua $sositewp website nay"
sleep 1
acction2="/tmp/wordpresslist"
while read -r wpwebsite
    do
if [ -f /home/$wpwebsite/public_html/wp-config.php ]; then
chown -R www-data:www-data /home/$wpwebsite/public_html/wp-content/themes
cd /home/$wpwebsite/public_html
#echo "========================================================================="
#echo "Update Status For: $wpwebsite"
#/etc/lemp/menu/lemp-enable-tat-ca-cac-ham-php-php.ini
wp theme update --all --allow-root | grep Success: > /tmp/update-themes-status
chown -R www-data:www-data /home/$wpwebsite/public_html/wp-content/themes
   if [ "$(cat /tmp/update-themes-status)" = "Success: Updated 0/0 themes." ]; then
echo "-------------------------------------------------------------------------"
echo "$wpwebsite: 0 Themes need update"
rm -rf /tmp/update-themes-status
  else
  echo "-------------------------------------------------------------------------"
echo "$wpwebsite: $(cat /tmp/update-themes-status | sed 's/Success://')"
rm -rf /tmp/update-themes-status
cd
  fi
  fi
done < "$acction2"
rm -rf /tmp/wordpresslist
echo "-------------------------------------------------------------------------"
#/etc/lemp/menu/lemp-re-config-cac-ham-php-disable-php.ini

systemctl restart php${PHP_VERSION}-fpm.service

###################################
#Huy bo update
###################################
else 
clear && /etc/lemp/menu/lemp-wordpress-tools-menu.sh
fi
