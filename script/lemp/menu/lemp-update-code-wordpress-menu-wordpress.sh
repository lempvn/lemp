#!/bin/bash 

. /home/lemp.conf

echo "========================================================================="
echo "Su dung chuc nang nay de update Wordpress code len phien ban moi nhat"  
echo "-------------------------------------------------------------------------"
echo "Truoc khi update, LEMP tien hanh sao luu database cho website"
echo "========================================================================="
#prompt="Nhap lua chon cua ban: "
prompt="Lua chon cua ban: "
options=( "Update 1 website" "Update tat ca Wordpress website" "Huy bo")
printf "LUA CHON CACH UPDATE\n"
printf "=========================================================================\n"
PS3="$prompt"
select opt in "${options[@]}"; do 

    case "$REPLY" in
    1) luachonupdate="update1site"; break;;
    2) luachonupdate="updateall"; break;;
    3) chonphpversion="cancel"; break;;
    *) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu";continue;;
    #*) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu";continue;;
    esac  
done
###################################
#Update 1 website
###################################
if [ "$luachonupdate" = "update1site" ]; then
/etc/lemp/menu/lemp-update-wordpresss-code-for-website.sh
###################################
#Update tat ca cac website
###################################
elif [ "$luachonupdate" = "updateall" ]; then
/etc/lemp/menu/lemp-update-wp-code-tat-ca-vps-website-wordpress.sh
###################################
#Huy bo update
###################################
else 
clear && /etc/lemp/menu/lemp-wordpress-tools-menu.sh
fi
