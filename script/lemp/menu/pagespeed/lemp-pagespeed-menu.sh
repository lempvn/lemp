#!/bin/sh
prompt="Nhap lua chon cua ban (0-Thoat):"
options=("Enable Nginx Pagespeed" "Disable Nginx Pagespeed" "Clear Nginx Pagespeed Cache" "List Website BAT Nginx Pagespeed")

printf "=========================================================================\n"
printf "                LEMP - Quan Ly VPS/Server by LEMP.VN \n"
printf "=========================================================================\n"
printf "                         Quan Ly Nginx Pagespeed                                \n"
printf "=========================================================================\n"

PS3="$prompt"
select opt in "${options[@]}" "Thoat"; do 

    case "$REPLY" in
    1 ) /etc/lemp/menu/pagespeed/lemp-bat-pagespeed.sh;;
    2 ) /etc/lemp/menu/pagespeed/lemp-tat-pagespeed.sh;;
    3 ) /etc/lemp/menu/pagespeed/lemp-clear-pagespeed.sh;;
    4 ) /etc/lemp/menu/pagespeed/lemp-list-website-dang-bat-pagespeed.sh;;
    
    $(( ${#options[@]}+1 )) ) echo "bye!";  clear && /bin/lemp;;
    0 ) echo "bye!";  clear && /bin/lemp;;
    *) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu !";continue;;

    esac
done
