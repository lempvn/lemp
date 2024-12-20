#!/bin/bash
prompt="Lua chon cua ban (0-Thoat):"
options=("Tu dong kiem tra va block IP" "Ket noi toi cong 80 & 443" "So ket noi dang SYN_RECV" "IP dang ket noi & so ket noi/IP" "Block IP")
printf "=========================================================================\n"
printf "                LEMP - Manage VPS/Server by LEMP.VN             \n"
printf "=========================================================================\n"
printf "                   Check DDOS, Flood & Block IP DOS\n"
printf "=========================================================================\n"
PS3="$prompt"
select opt in "${options[@]}" "Thoat"; do 

    case "$REPLY" in
    1 ) /etc/lemp/menu/checkddos/auto-check-block-ip-ddos.sh;;
    2 ) /etc/lemp/menu/checkddos/lemp-so-ket-noi.sh;;
    3 ) /etc/lemp/menu/checkddos/lemp-so-rysync.sh;;
    4 ) echo "Ket qua so luong ket noi den cong 80 (http) va 443 (https): "
	netstat -an | grep -E ':80|:443' | awk '{print $5}' | cut -d":" -f1 | sort | uniq -c | sort -rn;;
    5 ) /etc/lemp/menu/lemp-chan-ip-ddos.sh;;
    0) clear && lemp;;
      
    $(( ${#options[@]}+1 )) ) echo "Tam biet!";  clear && /bin/lemp;;
    *) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu !";continue;;

    esac
done
