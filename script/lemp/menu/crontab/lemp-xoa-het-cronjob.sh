#!/bin/bash 
. /home/lemp.conf

if [ "$(crontab -l | awk 'NR==1 {print $1}')" == "" ]; then
clear
echo "========================================================================= "
echo "Ban chua tao crontab tren VPS !"
/etc/lemp/menu/crontab/lemp-cronjob-menu.sh
else
echo "========================================================================= "
read -r -p "Ban muon xoa het cac crontab dang chay? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
echo "Chuan bi xoa... "
sleep 3
crontab -r
clear
echo "========================================================================= "
echo "LEMP hoan tat xoa cac crontab hien tai"
/etc/lemp/menu/crontab/lemp-cronjob-menu.sh
;;
    *)
        echo ""
        ;;
esac
clear 
echo "========================================================================="
echo "Huy bo viec xoa het crontab !"
/etc/lemp/menu/crontab/lemp-cronjob-menu.sh
exit
fi
