#!/bin/bash
. /home/lemp.conf

prompt="Nhap lua chon cua ban:"
options=()

# Kiem tra trang thai cua Memcached
if [ "$(systemctl is-active memcached.service)" == "active" ]; then
    options=("Install Memcached")
elif [ "$(systemctl is-active memcached.service)" == "inactive" ]; then
    options=("Install Memcached")
fi

printf "=========================================================================\n"
printf "                LEMP - Quan Ly VPS/Server by LEMP.VN \n"
printf "=========================================================================\n"
printf "                           Memcached Manage \n"
printf "=========================================================================\n"
printf "Link Memcached Manage: http://$serverip:$priport/memcache.php\n"
printf "=========================================================================\n"

PS3="$prompt"
select opt in "${options[@]}" "Thoat"; do
    case "$REPLY" in
        1 ) /etc/lemp/menu/memcache/lemp-install-remove-memcache.sh;;
        $(( ${#options[@]}+1 )) ) echo ""; clear && /bin/lemp;;
        *) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu !"; continue;;
    esac
done
