#!/bin/bash 

. /home/lemp.conf
#prompt="Type in your choice: "
prompt="Nhap lua chon cua ban: "
options=( "Sub-Domain" "Sub-directories" "Huy bo cai dat")
  echo "========================================================================="
  echo "Lua chon cach cai dat Wordpress Multisite"
  echo "-------------------------------------------------------------------------"
  echo "Sub-domain: http://username.website.com"
  echo "-------------------------------------------------------------------------"
  echo "Sub-directories: http://website.com/username"
  echo "========================================================================="
PS3="$prompt"
select opt in "${options[@]}"; do 

    case "$REPLY" in
    1) multisitehow="subdomain"; break;;
    2) multisitehow="subdirectories"; break;;
    3) multisitehow="cancle"; break;;
    *) echo "Ban nhap sai, Vui long nhap theo danh sach trong list";continue;;
    #*) echo "You typed wrong, Please type in the ordinal number on the list";continue;;
    esac  
done
###################################
#subdomain
###################################
if [ "$multisitehow" = "subdomain" ]; then
/etc/lemp/menu/lemp-setup-wp-multisite-sub-domain-wordpress.sh
###################################
#Super Cache
###################################
elif [ "$multisitehow" = "subdirectories" ]; then
/etc/lemp/menu/lemp-setup-wp-multisite-sub-folder-wordpress.sh
###################################
else 
clear && /etc/lemp/menu/lemp-wordpress-tools-menu.sh
fi
