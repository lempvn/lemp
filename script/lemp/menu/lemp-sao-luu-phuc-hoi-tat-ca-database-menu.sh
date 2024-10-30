#!/bin/sh
prompt="Lua chon cua ban (0-Thoat):"
options=("Full Backup Database" "Link download backup file" "Restore Databases" )
printf "=========================================================================\n"
printf "               LEMP - Quan Ly VPS/Server by LEMP.VN \n"
printf "=========================================================================\n"
printf "                     Backup & Restore Full Database\n"
printf "=========================================================================\n"

PS3="$prompt"
select opt in "${options[@]}" ; do 

    case "$REPLY" in

    1 ) /etc/lemp/menu/lemp-befor-sao-luu-tat-ca-database.sh;;
    2 ) /etc/lemp/menu/lemp-link-sao-luu-all-database.sh;;
    3 ) /etc/lemp/menu/lemp-befor-phuc-hoi-tat-ca-database.sh;;
    4 ) clear && /etc/lemp/menu/4_database/lemp-them-xoa-database.sh;;
    0 ) clear && /etc/lemp/menu/4_database/lemp-them-xoa-database.sh;;

    
    *) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu !";continue;;

    esac

done
