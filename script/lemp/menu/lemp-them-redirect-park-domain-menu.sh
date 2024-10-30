#!/bin/bash 

. /home/lemp.conf

prompt="Lua chon cua ban : "
options=( "Them Redirect Domain" "Them Park Domain" "Thoat")
printf "=========================================================================\n"
PS3="$prompt"
select opt in "${options[@]}"; do 

    case "$REPLY" in
    1) choose="redirect"; break;;
    2) choose="park"; break;;
    3) choose="cancle"; break;;
    *) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu";continue;;
    esac  
done
if [ "$choose" = "redirect" ]; then
/etc/lemp/menu/lemp-redirect-domain.sh
elif [ "$choose" = "park" ]; then
/etc/lemp/menu/lemp-park-domain.sh
else 
clear && /etc/lemp/menu/lemp-them-website-menu.sh
fi
