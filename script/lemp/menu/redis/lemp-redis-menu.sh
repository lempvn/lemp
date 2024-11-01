#!/bin/bash
. /home/lemp.conf

prompt="Nhap lua chon cua ban: "
options=()
redistatus=""

# Kiem tra trang thai dich vu Redis
if [ "$(systemctl is-active redis.service)" == "active" ]; then
    options=("Vo hieu hoa Redis Cache" "Xoa Redis Cache" "Cau hinh Redis Cache" "Kiem tra Redis Status" "Go cai dat Redis Cache")
    redistatus="Dang hoat dong"
else
    options=("Kich hoat Redis Cache" "Xoa Redis Cache" "Cau hinh Redis Cache" "Kiem tra Redis Status" "Go cai dat Redis Cache")
    redistatus="Da dung"
fi

# Hien thi thong tin Redis
printf "=========================================================================\n"
printf "                LEMP - Quan Ly VPS/Server by LEMP.VN \n"
printf "=========================================================================\n"
printf "                           Quan Ly Redis Cache                                \n"
printf "=========================================================================\n"
printf "          Redis: $redistatus - Ram Max: $(grep -E "^[^#]*maxmemory " /etc/redis/redis.conf | awk '{print $2}' | sed 's/mb//') M "
if [ "$(systemctl is-active redis.service)" == "active" ]; then
    printf " - Ram Dang Su Dung: $(redis-cli INFO | grep used_memory_human | sed 's/used_memory_human://') \n"
else
    printf "\n"
fi
printf "=========================================================================\n"

PS3="$prompt"
select opt in "${options[@]}" "Thoat"; do 
    case "$REPLY" in
        1) /etc/lemp/menu/redis/lemp-before-bat-tat-redis.sh;;
        2) /etc/lemp/menu/redis/lemp-clear-redis.sh;;
        3) /etc/lemp/menu/redis/lemp-redis-change-size.sh;;
        4) /etc/lemp/menu/redis/lemp-check-redis-status.sh;;
        5) /etc/lemp/menu/redis/lemp-install-remove-redis.sh;;
        $(( ${#options[@]} + 1 )) ) 
            echo ""; clear && /bin/lemp;;
        *) 
            echo "Ban nhap sai, vui long nhap theo so thu tu tren menu!"
            continue;;
    esac
done
