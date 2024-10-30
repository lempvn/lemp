#!/bin/bash
prompt="Lua chon cua ban (0-Thoat):"
options=("Services dang chay va RAM dung" "RAM MySQL su dung" "Free Disc " "Uptime VPS" "CPU Load average" "Last YUM update" "Authenication Failures" "User dang nhat gan day" "Xem thong tin CPU" "Check I/O Speed" "Check download Speed")
printf "=========================================================================\n"
printf "                LEMP - Manage VPS/Server by LEMP.VN             \n"
printf "=========================================================================\n"
printf "                     Check VPS/Server information\n"
printf "=========================================================================\n"
PS3="$prompt"
select opt in "${options[@]}" "Thoat"; do 

    case "$REPLY" in
    1) clear && echo "=========================================================================" && /etc/lemp/menu/lemp-tien-trinh-dang-chay-ram-use.sh;;
    2) /etc/lemp/menu/checkddos/lemp-ram-mysql-dung.sh;;
    3) /etc/lemp/menu/checkddos/lemp-dung-luong-disc-trong.sh;;
    4) /etc/lemp/menu/checkddos/lemp-uptime-vps.sh;;
    5) /etc/lemp/menu/checkddos/lemp-load-average.sh;;
    6) /etc/lemp/menu/checkddos/lemp-lan-cap-nhat-yum-cuoi.sh;;
    7) /etc/lemp/menu/checkddos/lemp-Authenication-Failures.sh;;
    8) /etc/lemp/menu/checkddos/lemp-user-dang-nhap-gan-day.sh;;
    9) echo "-------------------------------------------------------------------------" && cat /proc/cpuinfo && echo "-------------------------------------------------------------------------";;
    10) echo "-------------------------------------------------------------------------" && dd if=/dev/zero of=test bs=64k count=16k conv=fdatasync; rm test && echo "-------------------------------------------------------------------------";;
#    11) clear && wget http://hostingaz.vn/script/others/freeVPSbench.sh -O - -o /dev/null|bash;;
    11) clear && wget --no-check-certificate https://raw.githubusercontent.com//vpsvn/lemp-version-2/main/script/others/freeVPSbench.sh -O - -o /dev/null|bash;;
    0) clear && lemp;;
$(( ${#options[@]}+1 )) ) echo "Bye!";  clear && /bin/lemp;;
    *) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu !";continue;;

    esac
done
