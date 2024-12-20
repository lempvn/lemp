#!/bin/bash
. /home/lemp.conf

prompt="Nhap lua chon cua ban:"
options=()

# Kiem tra trang thai cua Memcached
if [ "$(systemctl is-active memcached.service)" == "active" ]; then
    options=("Disable Memcached" "Restart Memcached" "Config Memcached" "Clear Memcached" "Remove Memcached")
else
    options=("Enable Memcached" "Restart Memcached" "Config Memcached" "Clear Memcached" "Remove Memcached")
fi

printf "=========================================================================\n"
printf "                LEMP - Quan Ly VPS/Server by LEMP.VN \n"
printf "=========================================================================\n"
printf "                            Quan Ly Memcached \n"
printf "=========================================================================\n"

# Hien thi trang thai Memcached
if [ "$(systemctl is-active memcached.service)" == "active" ]; then
    echo "        Memcached Status: Running - Configured RAM Usage: $(/bin/systemctl show memcached.service | grep MemoryLimit | awk -F= '{print $2}') MB"
else
    echo "                      Memcached Status: Stopped"
fi

printf "=========================================================================\n"
printf "Link Memcached Manage: http://$serverip:$priport/memcache.php\n"
printf "=========================================================================\n"

PS3="$prompt"
select opt in "${options[@]}" "Thoat"; do 
    case "$REPLY" in
        1 ) /etc/lemp/menu/memcache/lemp-before-bat-tat-memcache.sh;;
        2 ) /etc/lemp/menu/memcache/lemp-memcache-restart.sh;;
        3 ) /etc/lemp/menu/memcache/lemp-memcache-change-size.sh;;
        4 ) /etc/lemp/menu/memcache/lemp-clear-memcache.sh;; 
        5 ) /etc/lemp/menu/memcache/lemp-install-remove-memcache.sh;;
        $(( ${#options[@]}+1 )) ) echo ""; clear && /bin/lemp;;
        *) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu !"; continue;;
    esac
done
