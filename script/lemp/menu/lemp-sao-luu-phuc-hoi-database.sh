#!/bin/sh
prompt="Nhap lua chon cua ban (0-Thoat):"
options=( "Thoat")
printf "=========================================================================\n"
printf "               LEMP - Manage VPS/Server by LEMP.VN \n"
printf "=========================================================================\n"
printf "                      Backup & Restore Database\n"
printf "=========================================================================\n"

PS3="$prompt"
select opt in "${options[@]}" ; do 

    case "$REPLY" in

    1 ) /etc/lemp/menu/4_database/lemp-sao-luu-data.sh;;
    2 ) /etc/lemp/menu/4_database/lemp-lan-luot-sao-luu-het-tat-ca-database.sh;;
    3 ) /etc/lemp/menu/4_database/lemp-phuc-hoi-database-chon-dinh-dang.sh;;
    4 ) /etc/lemp/menu/4_database/lemp-lay-link-sao-luu-database-backup-menu.sh;;
    #5 ) /etc/lemp/menu/4_database/lemp-list-database-tren-vps;; "Danh Sach Database Tren Server"
    5 ) clear && /etc/lemp/menu/4_database/lemp-them-xoa-database.sh;;
    0 ) clear && /etc/lemp/menu/4_database/lemp-them-xoa-database.sh;;

    
    *) echo "Ban nhap sai, vui long nhap theo danh sach";continue;;

    esac

done
