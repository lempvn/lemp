#!/bin/bash
prompt="Lua chon cua ban (0-Thoat):"
options=( "Mo Port (INPUT)" "Close Port (INPUT)" "Kiem Tra Service Dung Port" "Sao Luu IPtables Rules" "Phuc Hoi IPtables Rules" "Xem IPtables Rules Hien Tai" )
printf "============================================================================\n"
printf "                LEMP - Quan Ly VPS/Server by LEMP.VN \n"
printf "============================================================================\n"
printf "                       Quan Ly IPtables Firewall\n"
printf "============================================================================\n"
printf "============================   CANH BAO!   =================================\n"
printf "============================================================================\n"
printf "Neu dang dung CSF thi ban khong nen thao tac voi IPTABLES de tranh xung dot!\n"
printf "============================================================================\n"

PS3="$prompt"
select opt in "${options[@]}" ; do 

    case "$REPLY" in

    1) /etc/lemp/menu/tienich/lemp-mo-port-ip-tables.sh;;
    2) /etc/lemp/menu/tienich/lemp-dong-port-ip-tables.sh;;
    3) /etc/lemp/menu/tienich/lemp-check-port-service.sh;;
    4) /etc/lemp/menu/tienich/lemp-sao-luu-iptables.sh;;
    5) /etc/lemp/menu/tienich/lemp-phuc-hoi-iptables.sh;;
    6) /etc/lemp/menu/tienich/lemp-view-iptables-rules.sh;;
    7) clear && /bin/lemp;;
    0) clear && lemp;;

            *) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu !";continue;;

    esac
done










