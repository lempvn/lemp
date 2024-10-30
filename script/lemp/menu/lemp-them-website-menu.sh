#!/bin/bash
if [ ! -f /etc/cron.d/lemp.code.cron ]; then
touch /etc/cron.d/lemp.code.cron
fi
prompt="Lua chon cua ban (0-Thoat):"
#options=( "Them Website" "Them Park & Redirect Domain" "Them website + Wordpress (Auto Setup)" "Them website + Forum Code (Auto Setup)" "Them Website + Opencart (Auto Setup)" "Them website + Wordpress (Download Code)" "Them Website + Joomla (Download Code)" "Them Website + Drupal (Download Code)" "List Website Tren Server")
options=( "Them Website" "Them Park & Redirect Domain" "Them website + Wordpress (Auto Setup)" "Them website + Wordpress (Download Code)" "List Website Tren Server")

printf "=========================================================================\n"
printf "                LEMP - Quan Ly VPS/Server by LEMP.VN \n"
printf "=========================================================================\n"
printf "                          Them Website Vao Server\n"
printf "=========================================================================\n"

PS3="$prompt"
select opt in "${options[@]}" ; do 

    case "$REPLY" in

    1) /etc/lemp/menu/lemp-them-website.sh;;
    2) /etc/lemp/menu/lemp-them-redirect-park-domain-menu.sh;;
    3) /etc/lemp/menu/lemp-them-website-auto-setup-wordpress-menu.sh;;
    4) /etc/lemp/menu/lemp-them-website-wp.sh;;
    5) /etc/lemp/menu/lemp-list-website-tren-vps.sh;; 
    6) clear && lemp;;
    0) clear && lemp;;
        *) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu !";continue;;

    esac

done



