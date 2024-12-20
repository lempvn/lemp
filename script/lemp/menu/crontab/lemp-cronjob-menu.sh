#!/bin/bash
prompt="Nhap lua chon cua ban (0-Thoat):"
options=("Them Crontab" "Xoa 1 Crontab" "Xoa Tat Ca Crontab" "List Crontab")
printf "=========================================================================\n"
printf "                LEMP - Quan Ly VPS/Server by LEMP.VN \n"
printf "=========================================================================\n"
printf "                              Quan Ly Cronjob \n"
echo "========================================================================="
if [ ! -f /var/spool/cron/crontabs/root ]; then
printf "                           Crontab running: 0 \n"
else
printf "                           Crontab running: $(wc -l /var/spool/cron/crontabs/root | awk '{print $1}') \n"
fi
printf "=========================================================================\n"

PS3="$prompt"
select opt in "${options[@]}" ; do 

    case "$REPLY" in

    1 ) /etc/lemp/menu/crontab/lemp-them-cronjob.sh;;
    2 ) /etc/lemp/menu/crontab/lemp-xoa-mot-crontab.sh;;
    3 ) /etc/lemp/menu/crontab/lemp-befor-xoa-het-cronjob.sh;;
    4 ) /etc/lemp/menu/crontab/lemp-crontab-hien-tai.sh;;
    #5 ) clear && /bin/lemp;;
    0 ) clear && /bin/lemp;;
    
    *) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu";continue;;

    esac
done

