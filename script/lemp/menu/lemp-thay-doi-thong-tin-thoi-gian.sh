#!/bin/bash
prompt="Lua chon cua ban (0-Thoat): "
options=("GMT" "GMT+1" "GMT+2" "GMT+3" "GMT+4" "GMT+5" "GMT+6" "GMT+7" "GMT+8" "GMT+9" "GMT+10" "GMT+11" "GMT+12" "GMT-1" "GMT-2" "GMT-3" "GMT-4" "GMT-5" "GMT-6" "GMT-7" "GMT-8" "GMT-9" "GMT-10" "GMT-11" "GMT-12")
printf "=========================================================================\n"
printf "           LEMP - Quan Ly VPS/Server by LEMP.VN \n"
printf "=========================================================================\n"
printf "                    Cai Dat Mui Gio Cho Server  \n"
printf "=========================================================================\n"
printf "         Gio Hien Tai Cua Server: $(date | awk 'NR==1 {print $1,$2,$3,$4,$6}')\n"
printf "=========================================================================\n"
PS3="$prompt"
select opt in "${options[@]}"; do 

    case "$REPLY" in
    1) muigio="GMT"; break;;
    2) muigio="GMT+1"; break;;
    3) muigio="GMT+2"; break;;
    4) muigio="GMT+3"; break;;
    5) muigio="GMT+4"; break;;
    6) muigio="GMT+5"; break;;
    7) muigio="GMT+6"; break;;
    8) muigio="GMT+7"; break;;
    9) muigio="GMT+8"; break;;
    10) muigio="GMT+9"; break;;
    11) muigio="GMT+10"; break;;
    12) muigio="GMT+11"; break;;
    13) muigio="GMT+12"; break;;
    14) muigio="GMT-1"; break;;
    15) muigio="GMT-2"; break;;
    16) muigio="GMT-3"; break;;
    17) muigio="GMT-4"; break;;
    18) muigio="GMT-5"; break;;
    19) muigio="GMT-6"; break;;
    20) muigio="GMT-7"; break;;
    21) muigio="GMT-8"; break;;
    22) muigio="GMT-9"; break;;
    23) muigio="GMT-10"; break;;
    24) muigio="GMT-11"; break;;
    25) muigio="GMT-12"; break;;
    26) clear && /etc/lemp/menu/tienich/lemp-tien-ich.sh;;
    0) clear && /etc/lemp/menu/tienich/lemp-tien-ich.sh;;

  
    *) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu !";continue;;
    esac
    
done
if [ "$muigio" = "GMT" ]; then
	yes | cp /usr/share/zoneinfo/Etc/GMT /etc/localtime
elif [ "$muigio" = "GMT+1" ]; then
	yes | cp /usr/share/zoneinfo/Etc/GMT-1 /etc/localtime
elif [ "$muigio" = "GMT+2" ]; then
	yes | cp /usr/share/zoneinfo/Etc/GMT-2 /etc/localtime
elif [ "$muigio" = "GMT+3" ]; then
	yes | cp /usr/share/zoneinfo/Etc/GMT-3 /etc/localtime
elif [ "$muigio" = "GMT+4" ]; then
	yes | cp /usr/share/zoneinfo/Etc/GMT-4 /etc/localtime
elif [ "$muigio" = "GMT+5" ]; then
	yes | cp /usr/share/zoneinfo/Etc/GMT-5 /etc/localtime
elif [ "$muigio" = "GMT+6" ]; then
	yes | cp /usr/share/zoneinfo/Etc/GMT-6 /etc/localtime
elif [ "$muigio" = "GMT+7" ]; then
	yes | cp /usr/share/zoneinfo/Etc/GMT-7 /etc/localtime
elif [ "$muigio" = "GMT+8" ]; then
	yes | cp /usr/share/zoneinfo/Etc/GMT-8 /etc/localtime
elif [ "$muigio" = "GMT+9" ]; then
	yes | cp /usr/share/zoneinfo/Etc/GMT-9 /etc/localtime
elif [ "$muigio" = "GMT+10" ]; then
	yes | cp /usr/share/zoneinfo/Etc/GMT-10 /etc/localtime
elif [ "$muigio" = "GMT+11" ]; then
	yes | cp /usr/share/zoneinfo/Etc/GMT-11 /etc/localtime
elif [ "$muigio" = "GMT+12" ]; then
	yes | cp /usr/share/zoneinfo/Etc/GMT-12 /etc/localtime
elif [ "$muigio" = "GMT-1" ]; then
	yes | cp /usr/share/zoneinfo/Etc/GMT+1 /etc/localtime
elif [ "$muigio" = "GMT-2" ]; then
	yes | cp /usr/share/zoneinfo/Etc/GMT+2 /etc/localtime
elif [ "$muigio" = "GMT-3" ]; then
	yes | cp /usr/share/zoneinfo/Etc/GMT+3 /etc/localtime
elif [ "$muigio" = "GMT-4" ]; then
	yes | cp /usr/share/zoneinfo/Etc/GMT+4 /etc/localtime
elif [ "$muigio" = "GMT-5" ]; then
	yes | cp /usr/share/zoneinfo/Etc/GMT+5 /etc/localtime
elif [ "$muigio" = "GMT-6" ]; then
	yes | cp /usr/share/zoneinfo/Etc/GMT+6 /etc/localtime
elif [ "$muigio" = "GMT-7" ]; then
	yes | cp /usr/share/zoneinfo/Etc/GMT+7 /etc/localtime
elif [ "$muigio" = "GMT-8" ]; then
	yes | cp /usr/share/zoneinfo/Etc/GMT+8 /etc/localtime
elif [ "$muigio" = "GMT-9" ]; then
	yes | cp /usr/share/zoneinfo/Etc/GMT+9 /etc/localtime
elif [ "$muigio" = "GMT-10" ]; then
	yes | cp /usr/share/zoneinfo/Etc/GMT+10 /etc/localtime
elif [ "$muigio" = "GMT-11" ]; then
	yes | cp /usr/share/zoneinfo/Etc/GMT+11 /etc/localtime
else 
	yes | cp /usr/share/zoneinfo/Etc/GMT+12 /etc/localtime
fi
echo "Cho xiu..."
sleep 1
clear
echo "========================================================================="
echo "Thay doi Timezone cho Server thanh cong."
echo "-------------------------------------------------------------------------"
echo "Thoi gian cua server la: $(date | awk 'NR==1 {print $1,$2,$3,$4,$6}')"
/etc/lemp/menu/lemp-thay-doi-thong-tin-thoi-gian.sh
exit
fi
