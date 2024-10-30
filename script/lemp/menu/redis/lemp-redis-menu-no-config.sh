#!/bin/bash
. /home/lemp.conf

prompt="Nhap lua chon cua ban:"
options=()

# Kiem tra trang thai dich vu Redis
if [ "$(systemctl is-active redis.service)" == "active" ]; then
    options=("Go cai dat Redis Cache")
else
    options=("Cai dat Redis Cache")
fi

printf "=========================================================================\n"
printf "                LEMP - Quan Ly VPS/Server by LEMP.VN \n"
printf "=========================================================================\n"
printf "                           Quan Ly Redis Cache                                \n"
printf "=========================================================================\n"
printf "          		   Redis: Chua cai dat				      \n" 
printf "=========================================================================\n"

PS3="$prompt"
select opt in "${options[@]}" "Thoat"; do
    case "$REPLY" in
        1) 
            # Chay script cai dat hoac go cai dat Redis
            /etc/lemp/menu/redis/lemp-install-remove-redis.sh
            ;;
        $(( ${#options[@]} + 1 )) ) 
            echo ""; clear && /bin/lemp
            ;;
        *) 
            echo "Ban nhap sai, vui long nhap theo so thu tu tren menu!"
            continue
            ;;
    esac
done
