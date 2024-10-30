#!/bin/bash
prompt="Lua chon cua ban (0-Thoat):"
options=("Tao Tai Khoan FTP Cho Website" "Xoa Tai Khoan FTP" "Thay Mat Khau Tai Khoan FTP" "Xem Thong Tin FTP Cua Website" "Cai dat FTP Server" )
printf "=========================================================================\n"
printf "                LEMP - Quan Ly VPS/Server by LEMP.VN \n"
printf "=========================================================================\n"
printf "                           Quan Ly FTP Server \n"
printf "=========================================================================\n"
echo ""
PS3="$prompt"
select opt in "${options[@]}" "Thoat"; do 

    case "$REPLY" in
    1) /etc/lemp/menu/ftpserver/lemp-tao-ftp-user-cho-domain.sh;;
    2) /etc/lemp/menu/ftpserver/lemp-xoa-ftp-user.sh;;
    3) /etc/lemp/menu/ftpserver/lemp-thay-mat-khau-user-ftp.sh;;
    4) /etc/lemp/menu/ftpserver/lemp-view-userftp-password.sh;;
    5) /etc/lemp/menu/ftpserver/ftp-server-install.sh;;
    0) clear && lemp;;
$(( ${#options[@]}+1 )) ) echo "";  clear && lemp;;
     *) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu !";continue;;

    esac

done
