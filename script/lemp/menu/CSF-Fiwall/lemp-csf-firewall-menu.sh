#!/bin/bash
. /home/lemp.conf
prompt="Nhap lua chon cua ban (0-Thoat):"
if [ -f /etc/csf/csf.conf ]; then
options=("Block IP" "Unblock IP" "Unblock Tat Ca IP" "Them IP Vao CSF.Allow" "Remove IP Khoi CSF.Allow" "Block Countries By CSF" "Unblock All Countries" "Restart (Enable) CSF Firewall" "Disable CSF Firewall" "Remove CSF Firewall" "View IP Blocked List" "Update CSF Firewall" "Tat/Bat Canh Bao Tren Menu")
else
options=("Block IP" "Unblock IP" "Unblock Tat Ca IP" "Them IP Vao CSF.Allow" "Remove IP Khoi CSF.Allow" "Block Countries By CSF" "Unblock All Countries"  "Restart (Enable) CSF Firewall" "Disable CSF Firewall" "Remove CSF Firewall" "View IP Blocked List" "Cai dat CSF Firewall" "Tat/Bat Canh Bao Tren Menu")
fi
printf "=========================================================================\n"
printf "                LEMP - Quan Ly VPS/Server by LEMP.VN \n"
printf "=========================================================================\n"
printf "                            Quan Ly CSF Firewall                                \n"
printf "=========================================================================\n"


if [ ! -f "/etc/csf/csf.conf" ]; then
echo "                          CSF Firewall: Not install"
else
csf -v > /tmp/lempcheckcscfstatus
if [ "$(grep disabled /tmp/lempcheckcscfstatus)" = "" ]; then
echo "             CSF Firewall: installed | Running | Version: $(csf -v | awk 'NR==1 {print $2}' | sed 's/v//') "
else
echo "                    CSF Firewall: Installed but Disable" 
fi
fi

if [ -f "/etc/csf/csf.conf" ]; then
if [ ! -f /etc/csf/csf.deny ]; then
cat > "/etc/csf/csf.deny" <<END
END
fi
fi

if [ -f /etc/csf/csf.deny ]; then
if [ "$(cat /etc/csf/csf.deny | awk 'NR==2 {print $2}')" == "Copyright" ]; then
rm -rf /etc/csf/csf.deny
cat > "/etc/csf/csf.deny" <<END
END
fi
fi

printf "=========================================================================\n"

PS3="$prompt"
select opt in "${options[@]}" ; do 

    case "$REPLY" in

    1) /etc/lemp/menu/CSF-Fiwall/lemp-chan-ip-ddos.sh;;
    2) /etc/lemp/menu/CSF-Fiwall/lemp-bo-chan-ip.sh;;
    3) /etc/lemp/menu/CSF-Fiwall/lemp-bo-chan-tat-ca-ip.sh;;
    4) /etc/lemp/menu/CSF-Fiwall/lemp-csf-allow.sh;;
    5) /etc/lemp/menu/CSF-Fiwall/lemp-remove-ip-khoi-csf-allow.sh;;
    6) /etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-block-country.sh;;
    7) /etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-un-block-country.sh;;
    8) /etc/lemp/menu/CSF-Fiwall/lemp-restart-csf.sh;;
    9) /etc/lemp/menu/CSF-Fiwall/lemp-befor-tat-csf.sh;;
    10) /etc/lemp/menu/CSF-Fiwall/lemp-xoa-csf.sh;;
    11) /etc/lemp/menu/CSF-Fiwall/lemp-download-csf-denny.sh;;
    12) /etc/lemp/menu/CSF-Fiwall/lemp-cai-dat-csf-csf-before.sh;;
    13) /etc/lemp/menu/CSF-Fiwall/lemp-tat-bat-canh-bao-cai-dat-csf.sh;;
    #14) clear && lemp;;  
    0) clear && lemp;;  
    *) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu";continue;;

    esac
done
 
