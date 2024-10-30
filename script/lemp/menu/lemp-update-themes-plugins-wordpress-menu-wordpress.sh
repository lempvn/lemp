#!/bin/bash 

. /home/lemp.conf
echo "========================================================================="
echo "Su dung chuc nang nay de update Themes va Plugins cho wordpress website"  
echo "========================================================================="
#prompt="Nhap lua chon cua ban: "
prompt="Lua chon cua ban: "
options=( "Update 1 Website" "Update Tat Ca Websites" "Huy Bo")
printf "LUA CHON UPDATE 1 WEBSITE HOAC TAT CA WORDPRESS WEBSITE TREN SERVER\n"
printf "=========================================================================\n"
PS3="$prompt"
select opt in "${options[@]}"; do 

    case "$REPLY" in
    1) luachonupdate="update1site"; break;;
    2) luachonupdate="updateall"; break;;
    3) luachonupdate="cancel"; break;;
    *) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu";continue;;
    #*) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu";continue;;
    esac  
done
###################################
#Update 1 website
###################################
if [ "$luachonupdate" = "update1site" ]; then
/etc/lemp/menu/lemp-nang-cap-plugins-themes-wordpress.sh
###################################
#Update tat ca cac website
###################################
elif [ "$luachonupdate" = "updateall" ]; then
/etc/lemp/menu/lemp-nang-cap-plugins-themes-tat-ca-website-wordpress.sh
###################################
#Huy bo update
###################################
else 
clear && /etc/lemp/menu/lemp-wordpress-tools-menu.sh
fi