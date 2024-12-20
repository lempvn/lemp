#!/bin/bash 
. /home/lemp.conf
if [ ! -d "/etc/lemp/crontab" ]; then
mkdir -p /etc/lemp/crontab
else
rm -rf /etc/lemp/crontab/*
fi
echo "========================================================================="
echo "Xem cach tao lenh crontab tai: https://crontab.guru"
echo "-------------------------------------------------------------------------"
echo -n "Crontab ban muon them [ENTER]: " 
read cronjob
if [ "$cronjob" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap chinh xac!"
/etc/lemp/menu/crontab/lemp-cronjob-menu.sh
exit
fi
if [ "$(grep "$cronjob" /var/spool/cron/crontabs/root)" == "$cronjob" ]; then
clear
echo "========================================================================= "
echo "Crontab ban vua nhap da ton tai tren he thong!"
/etc/lemp/menu/crontab/lemp-cronjob-menu.sh
exit
fi
crontab -l > /etc/lemp/crontab/test4.txt
(crontab -u root -l ; echo "$cronjob") | crontab -u root -
crontab -l > /etc/lemp/crontab/test5.txt
if [ "$(wc -l /etc/lemp/crontab/test4.txt | awk '{print $1}')" == "$(wc -l /etc/lemp/crontab/test5.txt | awk '{print $1}')" ]; then
rm -rf /etc/lemp/crontab/*
clear
echo "========================================================================= "
echo "Them crontab that bai! Crontab cua ban co the khong chinh xac"
echo "-------------------------------------------------------------------------"
echo "Tao lenh crontab tai https://crontab.guru"
/etc/lemp/menu/crontab/lemp-cronjob-menu.sh
else
rm -rf /etc/lemp/crontab/*
clear
echo "========================================================================= "
echo "Ban da them thanh cong crontab vao he thong."
echo "-------------------------------------------------------------------------"
echo "List Crontab hien tai:"
echo "-------------------------------------------------------------------------"
crontab -l
/etc/lemp/menu/crontab/lemp-cronjob-menu.sh
exit
fi
