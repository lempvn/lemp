#!/bin/sh
. /home/lemp.conf
rm -rf /tmp/lemp.newversion*
cd /tmp
timeout 3 wget -q https://vps.vn/script/lemp/lemp.newversion
cd
LOCALVER=`cat /etc/lemp/lemp.version`
 if [ ! -f /tmp/lemp.newversion ]; then 
 clear
printf "=========================================================================\n"
echo "LEMP Khong the kiem tra phien ban LEMP hien tai"
echo "-------------------------------------------------------------------------"
echo "(LEMP cant not check current version)"
/etc/lemp/menu/lemp-update-upgrade-service-menu.sh
 exit
 fi
if [ -f /tmp/lemp.newversion ]; then
REMOVER=`cat /tmp/lemp.newversion`
if [ ! "$LOCALVER" == "$REMOVER" ]; then
clear
printf "=========================================================================\n"
echo "Ban phai update LEMP len phien ban moi nhat de su dung chuc nang nay"
echo "-------------------------------------------------------------------------"
echo "(You must update LEMP to latest version to use this function)"
/etc/lemp/menu/lemp-update-upgrade-service-menu.sh
fi
fi
if [ "$(grep lemp.COM /bin/lemp)" != "" ]; then
options=("EngLish (Current)" "VietNamese" "Exit")
else
options=("EngLish" "VietNamese (Current)" "Exit")
fi
prompt="Nhap lua chon cua ban:" 
printf "=========================================================================\n"
printf "                LEMP - Quan Ly VPS/Server by LEMP.VN \n"             
printf "=========================================================================\n"
printf "                       Lua Chon Ngon Ngu Cho lemp                                \n"
printf "=========================================================================\n"
PS3="$prompt"
select opt in "${options[@]}" ; do 

    case "$REPLY" in

    1) /etc/lemp/menu/lemp-chuyen-ngon-ngu-sang-tieng-anh.sh;;
    2) /etc/lemp/menu/lemp-chuyen-ngon-ngu-sang-tieng-viet.sh;;
    3) clear && /etc/lemp/menu/lemp-update-upgrade-service-menu.sh;; 
    0) clear && /etc/lemp/menu/lemp-update-upgrade-service-menu.sh;; 
    *) echo "You typed wrong, Please type in the ordinal number on the list";continue;;

    esac
done
 
