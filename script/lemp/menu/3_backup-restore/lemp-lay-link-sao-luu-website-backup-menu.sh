#!/bin/bash 

. /home/lemp.conf

prompt="Lua chon cua ban: "
options=( "1 Website" "Tat Ca Website" "Huy Bo")
printf "=========================================================================\n"
printf "LAY LINK DOWNLOAD BACKUP CUA 1 WEBSITE HOAC TAT CA WEBSITE\n"
printf "=========================================================================\n"
PS3="$prompt"
select opt in "${options[@]}"; do 

    case "$REPLY" in
    1) laylink="1website"; break;;
    2) laylink="tatca"; break;;
    3) laylink="cancle"; break;;
    *) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu";continue;;
    esac  
done
###################################
#
###################################
if [ "$laylink" = "1website" ]; then
/etc/lemp/menu/3_backup-restore/lemp-link-tai-sao-luu-1-site.sh
###################################
#
###################################
elif [ "$laylink" = "tatca" ]; then
/etc/lemp/menu/3_backup-restore/lemp-link-download-tat-ca-backup-website-sao-luu.sh
###################################
#
###################################
else 
clear && /etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh
fi