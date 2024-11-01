#!/bin/bash
prompt="Lua chon cua ban:"
options=( "Restart MySQL" "Restart Nginx" "Restart PHP-FPM" "Restart VPS" "Exit" )
printf "=========================================================================\n"
printf "                LEMP - Manage VPS/Server by LEMP.VN \n"
printf "=========================================================================\n"
printf "                            Restart Service\n"
printf "=========================================================================\n"

PS3="$prompt"
select opt in "${options[@]}" ; do 

    case "$REPLY" in

    1) /etc/lemp/menu/tienich/lemp-restart-mysql.sh;;
    2) /etc/lemp/menu/tienich/lemp-restart-nginx.sh;;
    3) /etc/lemp/menu/tienich/lemp-restart-php.sh;;
    4) /etc/lemp/menu/tienich/lemp-reboot-vps.sh;;
    0) clear && /etc/lemp/menu/tienich/lemp-tien-ich.sh;;

            *) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu !";continue;;

    esac
done
