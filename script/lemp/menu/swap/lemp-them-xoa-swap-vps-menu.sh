#!/bin/bash

prompt="Nhap lua chon cua ban (0-Thoat):"
options=("Swap 512 MB" "Swap 1 GB" "Swap 2 GB" "Swap 3 GB" "Swap 4 GB" "Swap 6 GB" "Xoa Swap" )
printf "=========================================================================\n"
printf "                LEMP - Quan Ly VPS/Server by LEMP.VN \n"
printf "=========================================================================\n"
printf "                   Chuc nang nay khong ho tro VPS OpenVZ\n"
printf "=========================================================================\n"
printf "                             Tao & Xoa Swap\n"
printf "=========================================================================\n"
PS3="$prompt"
select opt in "${options[@]}" "Thoat"; do 

    case "$REPLY" in

    1 ) /etc/lemp/menu/swap/lemp-create-swap-512.sh;;
    2 ) /etc/lemp/menu/swap/lemp-create-swap-1024.sh;;
    3 ) /etc/lemp/menu/swap/lemp-create-swap-2048.sh;;
    4 ) /etc/lemp/menu/swap/lemp-create-swap-3072.sh;;
    5 ) /etc/lemp/menu/swap/lemp-create-swap-4096.sh;;
    6 ) /etc/lemp/menu/swap/lemp-create-swap-6144.sh;;
    7 ) /etc/lemp/menu/swap/lemp-xoa-swap-vps.sh;;
        
$(( ${#options[@]}+1 )) ) echo "BYE!";  clear && /bin/lemp;;
0 ) echo "BYE!";  clear && /bin/lemp;;
     *) echo "Ban nhap sai, vui long nhap cac so trong list tren";continue;;

    esac

done
