#!/bin/bash
. /home/lemp.conf

if [ "$(crontab -l | awk 'NR==1 {print $1}')" == "" ]; then
clear
echo "========================================================================= "
echo "Ban chua tao crontab tren VPS !"
/etc/lemp/menu/crontab/lemp-cronjob-menu.sh
exit
fi
clear
echo "========================================================================= "
echo "Danh sach Crontab dang chay:"
echo "-------------------------------------------------------------------------"
crontab -l
/etc/lemp/menu/crontab/lemp-cronjob-menu.sh
exit
fi
