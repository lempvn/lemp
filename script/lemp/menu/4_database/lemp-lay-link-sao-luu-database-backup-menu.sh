#!/bin/bash 

. /home/lemp.conf

prompt="Nhap lua chon cua ban: "
options=( "1 Database" "Tat Ca Database" "Huy Bo")
printf "=========================================================================\n"
printf "LUA CHON LAY LINK DOWNLOAD FILE BACKUP 1 DATABASE HAY TAT CA CAC DATABASE  \n"
printf "=========================================================================\n"
PS3="$prompt"
select opt in "${options[@]}"; do 

    case "$REPLY" in
    1) laylink="1database"; break;;
    2) laylink="tatca"; break;;
    3) laylink="cancle"; break;;
    *) echo "Ban nhap sai ! Ban vui long chon so trong danh sach";continue;;
    esac  
done
###################################
#
###################################
if [ "$laylink" = "1database" ]; then
/etc/lemp/menu/lemp-link-database-sao-luu.sh
###################################
#
###################################
elif [ "$laylink" = "tatca" ]; then
/etc/lemp/menu/lemp-link-download-tat-ca-backup-database-sao-luu.sh
###################################
#
###################################
else 
clear && /etc/lemp/menu/4_database/lemp-them-xoa-database.sh
fi
