#!/bin/bash
prompt="Lua chon cua ban (0-Thoat):"
options=( "Tao domain key & Sign SSL certificate" "Tai Domain CSR va Vhost Mau " "Fix Khong the download files")
printf "=========================================================================\n"
printf "                LEMP - Quan Ly VPS/Server by LEMP.VN \n"
printf "=========================================================================\n"
printf "                            Setup SSL (https) \n"
printf "=========================================================================\n"
printf "  \n"

PS3="$prompt"
select opt in "${options[@]}" ; do 

    case "$REPLY" in
    1) /etc/lemp/menu/lemp-tao-ssl.sh;;
    2) /etc/lemp/menu/lemp-tao-ssl-link-download-domain-csr.sh;;
    3) /etc/lemp/menu/lemp-khong-the-download-csr-file.sh;;
    4) clear && /bin/lemp;;
    0) clear && lemp;;
        *) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu !";continue;;

    esac

done



