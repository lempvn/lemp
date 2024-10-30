#!/bin/bash 
. /home/lemp.conf
if [ ! -d "/etc/lemp/crontab" ]; then
mkdir -p /etc/lemp/crontab
else
rm -rf /etc/lemp/crontab/*
fi
if [ "$(crontab -l | awk 'NR==1 {print $1}')" == "" ]; then
clear
echo "========================================================================= "
echo "Ban chua tao crontab tren VPS !"
/etc/lemp/menu/crontab/lemp-cronjob-menu.sh
exit
fi
echo "========================================================================="
echo "Hay nhap ve phai cua Crontab tuc la khong nhap thoi gian"
echo "-------------------------------------------------------------------------"
echo "Vi du: Crontab can xoa: * * * * * /root/abc ta chi nhap: /root/abc"
echo "-------------------------------------------------------------------------"
echo -n "Nhap ve phai Crontab ban muon xoa [ENTER]:" 
read cronjob

if [ "$cronjob" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap chinh xac!"
/etc/lemp/menu/crontab/lemp-cronjob-menu.sh
exit
fi

if [ "$cronjob" = "auto-start-mysql" ]; then
clear
echo "========================================================================="
echo "Xoa crontab that bai! Ban khong the xoa crontab nay"
echo "-------------------------------------------------------------------------"
echo "Hay dung chuc nang [Auto re-start MySQL Server] trong [Tien Ich - Addon]"
/etc/lemp/menu/crontab/lemp-cronjob-menu.sh
exit
fi

echo "$cronjob" > /etc/lemp/crontab/test7.txt
if [ ! "$(grep "*" /etc/lemp/crontab/test7.txt | awk '{print $2}')" == "" ]; then
clear
echo "========================================================================="
echo "Xoa crontab that bai! "
echo "-------------------------------------------------------------------------"
echo "Ban chi duoc nhap ve phai cua crontab! "
rm -rf /etc/lemp/crontab/test7.txt
/etc/lemp/menu/crontab/lemp-cronjob-menu.sh
exit
fi
crontab -l > /etc/lemp/crontab/test2.txt
crontab -u root -l | grep -v $cronjob | crontab -u root -
crontab -l > /etc/lemp/crontab/test3.txt
if [ "$(wc -l /etc/lemp/crontab/test2.txt | awk '{print $1}')" == "$(wc -l /etc/lemp/crontab/test3.txt | awk '{print $1}')" ]; then
rm -rf /etc/lemp/crontab/*
clear
echo "========================================================================= "
echo "Xoa crontab that bai hoac crontab muon xoa khong ton tai tren he thong"
echo "-------------------------------------------------------------------------"
echo "Ban hay thu lai lan nua"
/etc/lemp/menu/crontab/lemp-cronjob-menu.sh
else
rm -rf /etc/lemp/crontab/*
clear
echo "========================================================================= "
echo "Ban da xoa thanh cong crontab."
if [ "$(crontab -l | awk 'NR==1 {print $1}')" == "" ]; then
echo "-------------------------------------------------------------------------"
echo "Hien tai khong co crontab nao dang chay."
else
echo "-------------------------------------------------------------------------"
echo "List Crontab hien tai:"
echo "-------------------------------------------------------------------------"
crontab -l
fi
/etc/lemp/menu/crontab/lemp-cronjob-menu.sh
exit
fi

