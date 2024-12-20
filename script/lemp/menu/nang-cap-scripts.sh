#!/bin/bash
. /home/lemp.conf

if [ ! -f /etc/lemp/lemp.version ]; then
clear
echo "========================================================================="
echo "Xin loi, chung toi khong the biet phien ban hien tai cua ban"
echo "-------------------------------------------------------------------------"
echo "Hay chac rang ban chay script offical tu website https://github.com/vpsvn/lemp-version-2"
lemp
exit
fi

maximumsize=10
rm -rf /etc/lemp/lemp.newversion
cd /etc/lemp
#timeout 3 wget -q http://hostingaz.vn/script/lemp/lemp.newversion
timeout 3 wget --no-check-certificate -q https://raw.githubusercontent.com/vpsvn/lemp-version-2/main/version -O /etc/lemp/lemp.newversion

cd
if [ -f /etc/lemp/lemp.newversion ]; then
checksizeversion=$(du -sb /etc/lemp/lemp.newversion | awk 'NR==1 {print $1}')
if [ "$checksizeversion" == "0" ];then
rm -rf /etc/lemp/lemp.newversion
fi
if [ $checksizeversion -gt $maximumsize ]; then
rm -rf /etc/lemp/lemp.newversion
fi
fi

if [ ! -f /etc/lemp/lemp.newversion ]; then
clear
printf "=========================================================================\n"
echo "Khong the kiem tra phien ban update LEMP"
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai"
/etc/lemp/menu/lemp-update-upgrade-service-menu.sh
else
LOCALVER=`cat /etc/lemp/lemp.version`
REMOVER=`cat /etc/lemp/lemp.newversion`
fi


chuaCoBanMoi="n"
if [ "$LOCALVER" == "$REMOVER" ]; then
clear
rm -rf /etc/lemp/lemp.newversion
echo "========================================================================="
echo "Ban dang su dung phien ban moi nhat cua LEMP - Phien ban: $LOCALVER"
echo "-------------------------------------------------------------------------"
echo "Xem LEMP update Log tai: https://github.com/vpsvn/lemp-version-2"

echo -n "Ban van muon cap nhat lai LEMP chu? [y/N] "
read vanCapNhat
if [ "$vanCapNhat" = "y" ]; then
echo "OK sir! tien trinh cap nhat se duoc tiep tuc..."
sleep 3
chuaCoBanMoi="y"
else
/etc/lemp/menu/lemp-update-upgrade-service-menu.sh
exit
fi
fi

printf "=========================================================================\n"
printf "Xem LEMP update Log tai: https://github.com/vpsvn/lemp-version-2\n"
printf "=========================================================================\n"
printf "Da phat hien update cho LEMP\n"
echo "-------------------------------------------------------------------------"
printf "Phien ban ban dang su dung: $LOCALVER\n"
echo "-------------------------------------------------------------------------"
printf "Phien ban ban moi nhat tai thoi diem hien tai: $REMOVER\n"
printf "=========================================================================\n"

if [ "$chuaCoBanMoi" = "y" ]; then
response="y"
else
read -r -p "Ban chac chan muon update LEMP ? [y/N] " response
fi

if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
echo "-------------------------------------------------------------------------" 
echo "Chuan bi update LEMP..... "
sleep 1

rm -rf /etc/lemp/lemp-update
#wget -q http://hostingaz.vn/script/lemp/lemp-update -O /etc/lemp/lemp-update && chmod +x /etc/lemp/lemp-update
wget --no-check-certificate -q https://raw.githubusercontent.com/vpsvn/lemp-version-2/main/script/lemp/lemp-update -O /etc/lemp/lemp-update
chmod +x /etc/lemp/lemp-update
bash /etc/lemp/lemp-update

else

clear
printf "=========================================================================\n"
echo "Ban da huy bo update LEMP"
/etc/lemp/menu/lemp-update-upgrade-service-menu.sh

fi

#
clear && /etc/lemp/menu/lemp-update-upgrade-service-menu.sh

exit
