#!/bin/bash
prompt="Nhap lua chon cua ban (0-Thoat):"
if [ ! -f /usr/local/maldetect/conf.maldet ]; then
options=( "Scan 1 website" "Scan All websites" "View Last Scan Report" "Cai Dat Linux Malware Detect")
else
options=( "Scan 1 website" "Scan All websites" "View Last Scan Report" "Remove Linux Malware Detect")
fi
printf "=========================================================================\n"
printf "               LEMP - Quan Ly VPS/Server by LEMP.VN \n"
printf "=========================================================================\n"
if [ ! -f /usr/local/maldetect/conf.maldet ]; then
printf "                Linux Malware Detect (LMD) - Not Install\n"
else
printf "                 Linux Malware Detect (LMD) - Installed \n"
fi
printf "=========================================================================\n"
printf "\n"
PS3="$prompt"
select opt in "${options[@]}" ; do 

    case "$REPLY" in


    
    1) /etc/lemp/menu/lemp-scan-website-maldet.sh;;
    2) /etc/lemp/menu/lemp-scan-home-maldet.sh;;
    3) /etc/lemp/menu/lemp-view-last-scan-report.sh;;
    4) /etc/lemp/menu/lemp-befor-maldet-cai-dat.sh;;
    5) clear && lemp;;
    0) clear && lemp;;
        *) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu !";continue;;

    esac

done





